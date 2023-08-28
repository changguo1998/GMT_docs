#!/usr/bin/env bash
#
# Download some datasets and make changes for CI.
#

# Create the .gmt folder
mkdir ~/.gmt

# Download the GMT remote datasets
gmt which -Ga @earth_relief_30m_g \
            @earth_relief_30m_p \
            @earth_relief_20m_p \
            @earth_relief_20m_g \
            @earth_relief_10m_p \
            @earth_relief_06m_p \
            @earth_relief_05m_p \
            @earth_relief_04m_p \
            @earth_age_06m_p \
            @earth_day_20m_p \
            @earth_day_06m_p \
            @earth_night_20m_p \
            @earth_mask_05m_p \
            @earth_mag4km_20m_p \
            @earth_geoid_20m_p \
            @earth_faa_20m_p
gmt grdcut @earth_relief_01m_p -R118/125/20/26 -G/dev/null

# Download GMT cache files
gmt which -Ga @age_chrons_GTS2012_2020.cpt \
            @ternary.txt \
            @mississippi.txt \
            @NY_traffic.txt \
            @Table_5_11.txt \
            @sunglasses.eps \
            @Wessel_GJI_Fig_5.txt

# Download the china-geospatial-data datasets
git clone --depth 1 https://github.com/gmt-china/china-geospatial-data china-geospatial-data
rm -rf china-geospatial-data/.git
mv china-geospatial-data/* ~/.gmt/cache/

# Download custom symbols
git clone --depth 1 https://github.com/gmt-china/GMT_custom_symbols GMT_custom_symbols
rm -rf GMT_custom_symbols/.git
mv GMT_custom_symbols ~/.gmt/custom/

# Download plate boundary types data
wget -q https://raw.githubusercontent.com/dhasterok/global_tectonics/main/plates%26provinces/gmt/boundaries.gmt
wget -q https://raw.githubusercontent.com/dhasterok/global_tectonics/main/plates%26provinces/gmt/plates.gmt
wget -q https://raw.githubusercontent.com/dhasterok/global_tectonics/main/plates%26provinces/gmt/global_gprv.gmt
mv boundaries.gmt plates.gmt global_gprv.gmt ~/.gmt/cache/

# Download Chinese fonts
git clone --depth 1 https://github.com/ZMAlt/winfonts.git
rm -rf winfonts/.git
mv winfonts ~/.gmt/

# Create gs fontmap file for GMT Chinese support
cat > ~/.gmt/cidfmap << EOF
/STSong-Light <</FileType /TrueType /Path (${HOME}/.gmt/winfonts/simsun.ttc) /SubfontId 0 /CSI [(GB1) 4] >> ;
/STFangsong-Light <</FileType /TrueType /Path (${HOME}/.gmt/winfonts/simfang.ttf) /SubfontId 0 /CSI [(GB1) 4] >> ;
/STHeiti-Regular <</FileType /TrueType /Path (${HOME}/.gmt/winfonts/simhei.ttf) /SubfontId 0 /CSI [(GB1) 4] >> ;
/STKaiti-Regular <</FileType /TrueType /Path (${HOME}/.gmt/winfonts/simkai.ttf) /SubfontId 0 /CSI [(GB1) 4] >> ;
EOF

# Create font configuration file for GMT Chinese support.
cat > ~/.gmt/PSL_custom_fonts.txt << EOF
STSong-Light--UniGB-UTF8-H  0.700    1
STFangsong-Light--UniGB-UTF8-H  0.700    1
STHeiti-Regular--UniGB-UTF8-H   0.700   1
STKaiti-Regular--UniGB-UTF8-H   0.700   1
STSong-Light--UniGB-UTF8-V  0.700    1
STFangsong-Light--UniGB-UTF8-V  0.700    1
STHeiti-Regular--UniGB-UTF8-V   0.700   1
STKaiti-Regular--UniGB-UTF8-V   0.700   1
EOF

# Fix the gmt_cn1.locale file
mkdir -p ~/.gmt/localization
iconv -f GBK -t UTF-8 $(gmt --show-sharedir)/localization/gmt_cn1.locale > ~/.gmt/localization/gmt_cn1.locale
# The WESN patch is required for GMT<=6.4
cat > ~/.gmt/localization/gmt_cn1.locale << EOF
C   1       West            W       西
C   2       East            E       东
C   3       South           S       南
C   4       North           N       北
EOF

# Check
ls -lhR ~/.gmt
gmt text -L
cat ~/.gmt/cidfmap
cat ~/.gmt/PSL_custom_fonts.txt