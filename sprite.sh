#!/bin/bash

# spriteMyAssOff
#
# This script takes all the png's in a given folder, creates a sprite, 
# optimizes it and displays the css styles needed to use the sprite.
# It uses ImageMagick http://www.imagemagick.org and
# OptiPNG http://optipng.sourceforge.net
#
# Copyright (c) 2012 Mircea Georgescu <mircea.georgescu@gmail.com>
# MIT Licensed
#

function spriteMyAssOff {
    # create the sprite
    convert "${1}/*.png" -background transparent -append ${2}.png
    echo "Converted ${1} files to ${2}"

    # print css properties needed for each file    
    echo "--------------------  CSS Styles for ${1}  -----------------------"
    offset=0
    for f in ${1}/*.png
    do
        width=`identify -format "%[fx:w]" $f`
        height=`identify -format "%[fx:h]" $f`
        filename=`identify -format "%f" $f`
        echo "+ $filename"
        echo "  width: ${width}px;"
        echo "  height: ${width}px;"
        echo "  background-position: 0 -${offset}px;"
        echo "--------------------------------------"
        let offset+=$height
    done

    # optimize the sprite
    optipng ${2}.png
}

# I call the function twice because I have two folders:
# One for regular resolution and one for retina display
spriteMyAssOff sprite-source@1x sprite@1x
spriteMyAssOff sprite-source@2x sprite@2x