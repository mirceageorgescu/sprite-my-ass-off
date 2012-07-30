#!/bin/bash
#
# Sprite My Ass Off
#
# This script takes all the png's in a given folder, creates a vertical sprite, 
# optimizes it and generates a less file with the correct coordinates.
#
# In this case we have two folders: sprite-source-1x and sprite-source-2x.
#
# It uses
#
# ImageMagick http://www.imagemagick.org and
# OptiPNG     http://optipng.sourceforge.net
#
# Copyright (c) 2012 Mircea Georgescu <mircea.georgescu@gmail.com>
# MIT Licensed
#

readonly LESS="sprite.less"

function createSprite {
    # create the sprite
    convert "${1}/*.png" -background transparent -bordercolor none -border 0x${3} -append ${2}
    echo "created ${2}"
    # optimize the sprite
    optipng ${2}
}

# create normal @1x sprite
createSprite sprite-source-1x sprite-1x.png 15
# create retina @2x sprite
createSprite sprite-source-2x sprite-2x.png 30

# start writing the css file
echo "// sprite css generated on `eval date +%d-%m-%Y-%H:%M`" > ${LESS}
echo ".s, .s:after{" >> ${LESS}
echo "  background-image: url(../img/sprite-1x.png);" >> ${LESS}
echo "  background-repeat: no-repeat;" >> ${LESS}
echo "}" >> ${LESS}

# for each image in sprite-source-1x folder, add a class
# in LESS file with the image coordonates
let offset=15
for f in sprite-source-1x/*.png
do
    width=`identify -format "%[fx:w]" $f`
    height=`identify -format "%[fx:h]" $f`
    filename=`identify -format "%f" $f`
    #remove extension
    name=${filename%.*}
    #remove prefix_
    className=${name##*_}
    #replace '@' with ':'
    className=${className//"@"/":"}
    echo ".s.${className}{ background-position: 0 -${offset}px; }" >> ${LESS}
    let offset+=$height+30
done

# get normal sprite width to set it as background-size for retina
retinaBackgroundSize=`identify -format "%[fx:w]" sprite-1x.png`

# in @2x media query overwrite background image path and add background size.
# The coordinates remain the same as inherited from @1x sprite.
echo "@media only screen and (-moz-min-device-pixel-ratio: 2), only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min-device-pixel-ratio: 2) {" >> ${LESS}
echo "  .s, .s:after{" >> ${LESS}
echo "    background-image: url(../img/sprite-2x.png);" >> ${LESS}
echo "    background-size: ${retinaBackgroundSize}px auto;" >> ${LESS}
echo "  }" >> ${LESS}
echo "}" >> ${LESS}