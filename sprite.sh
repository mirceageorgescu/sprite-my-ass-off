#!/bin/bash
#
# Sprite My Ass Off
#
# This script takes all the png's in a given folder, creates a vertical sprite, 
# optimizes it and generates a CSS file with the correct coordinates.
#
# In this case we have two folders: ${SOURCE1} and ${SOURCE2}.
#
# It uses
#
# ImageMagick http://www.imagemagick.org and
# OptiPNG     http://optipng.sourceforge.net
#
# Copyright (c) 2012 Mircea Georgescu <mircea.georgescu@gmail.com>
# MIT Licensed
#

# Paths
# Change this to fit your project
readonly CSS="css/sprite.css"
readonly SOURCE1="img/sprite-source-1x"
readonly SOURCE2="img/sprite-source-2x"
readonly SPRITE1="img/sprite-1x.png"
readonly SPRITE2="img/sprite-2x.png"

function createSprite {
    # create the sprite
    convert "${1}/*.png" -background transparent -bordercolor none -border 0x${3} -append ${2}
    echo "created ${2}"
    # optimize the sprite
    optipng ${2}
}

# create normal @1x sprite
createSprite ${SOURCE1} ${SPRITE1} 15
# create retina @2x sprite
createSprite ${SOURCE2} ${SPRITE2} 30

# start writing the css file
echo "/* sprite css generated on `eval date +%d-%m-%Y-%H:%M` */" > ${CSS}
echo ".s, .s:after{" >> ${CSS}
echo "  background-image: url(../img/${SPRITE1});" >> ${CSS}
echo "  background-repeat: no-repeat;" >> ${CSS}
echo "}" >> ${CSS}

# for each image in ${SOURCE1} folder, add a class
# in CSS file with the image coordonates
let offset=15
for f in ${SOURCE1}/*.png
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
    echo ".s.${className}{ background-position: 0 -${offset}px; }" >> ${CSS}
    let offset+=$height+30
done

# get normal sprite width to set it as background-size for retina
retinaBackgroundSize=`identify -format "%[fx:w]" ${SPRITE1}`

# in @2x media query overwrite background image path and add background size.
# The coordinates remain the same as inherited from @1x sprite.
echo "@media only screen and (-moz-min-device-pixel-ratio: 2), only screen and (-webkit-min-device-pixel-ratio: 2), only screen and (min-device-pixel-ratio: 2) {" >> ${CSS}
echo "  .s, .s:after{" >> ${CSS}
echo "    background-image: url(../img/${SPRITE2});" >> ${CSS}
echo "    background-size: ${retinaBackgroundSize}px auto;" >> ${CSS}
echo "  }" >> ${CSS}
echo "}" >> ${CSS}