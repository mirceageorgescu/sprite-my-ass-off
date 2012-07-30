sprite-my-ass-off
=================
## What is this? ##
Is a bash script that eases sprite generation and maintaining.

## Dependencies ##
* [ImageMagick](http://www.imagemagick.org )
* [OptiPNG](http://optipng.sourceforge.net)

## How does it work? ##
The script takes all png files in a folder and merges them in a vertical sprite. It then uses optipng on the sprite file and generates a css file with the coordinates. It was written to use two source folders and generate two sprites.

### Source folders ###
* img/sprite-source-1x
* img/sprite-source-2x

### Generated sprites ###
* img/sprite-1x.png
* img/sprite-2x.png

We use two sprites because we want to take care of retina display too. So we have a second folder with the same images, same image naming but twice the width and height.

### Generated css file ###
* css/sprite.css

The file is generated when we run this script so we don't have to update our css by hand every time we add or change something. It contains sprite coordinates and a media query that takes care of high pixel density displays.

### Retina display ###
The media query changes the url() of the sprite file and adds the css3 [background-size](http://www.css3.info/preview/background-size/) property. The background-size is the width of the normal sprite. This way, the coordinates can stay the same. Actually, the browser resizes the retina sprite to the size of the normal one and displays it at double pixel density.

### Source files naming ###
We use the individual image filenames to generate the css selectors. We start each filename with a number so we can control the item position in the sprite. The starting number do not appear in the class name. We can also use :hover or :after in our filenames but we have to use @ instead of :. This because windows does not like the colon character in a filename.

### Examples ###

<table>
<tr>
<td>003_basket-full.png</td><td>.s.basket-full{ background-position: 0 -139px; }</td>
</tr>
<tr>
<td>001_antivirus@hover.png</td><td>.s.antivirus:hover{ background-position: 0 -15px; }</td>
</tr>
</table>

### Running the script ###
run ./sprite.sh in the console

## Drawbacks ##
Unfortunately, this mechanism is not perfect. There will be cases when you'll want to manually specify the coordinates in other css files. This explains the number prefix in the source files. We kind of want to avoid changing position of items when we insert new ones because we might affect the ones with hard-coded coordinates.

## Important stuff ##
* When you need to add a new item to the sprite, make sure you have it in both sizes. Regular and retina. Naming of the files must be the same in both folders.
* Make sure the retina version is exactly twice the size. Pixel perfection needed here.
* If we have a variable height element and we want to use a sprite item as a background, it's better to use pseudo-elements with a specified size to avoid sprite bleeding.
* When adding a new item into the sprite, make sure that the source item has exactly the height of the future-containing html element. Because we don't (always) write the coordinates by hand this is what we have to do to center it.
* When adding a new sprite element, remember to add the s class to the html element. That class holds the url() and no-repeat of the sprite. So we'll have something like <a class="s my-awesome-sprite-element"...

## Sample images ##
Sample images are designed by [Artua](http://www.artua.com) especially for [Smashing Magazine](http://www.smashingmagazine.com/2009/01/05/stationery-icons-soccer-icons-and-atlantic-wordpress-theme/).