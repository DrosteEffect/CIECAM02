CIECAM02 Color Appearance Model and CAM02 Uniform ColorSpace for MATLAB
=======================================================================

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=DrosteEffect/CIECAM02)

This code is based on the following sources:

1. the article "Algorithmic improvements for the CIECAM02 and CAM16 color
   appearance models" by Nico Schlömer, revised on the 14th of October 2021.
2. the chapter "CIECAM02 and Its Recent Developments" by Ming Ronnier Luo
   and Changjun Li, in the book "Advanced Color Image Processing
   and Analysis" published on the 26th of May 2012.
3. the article "Uniform Colour Spaces Based on CIECAM02 Colour Appearance
   Model", by Ming Ronnier Luo, Guihua Cui, and Changjun Li, from volume 31
   issue 4 of the journal "Color Research and Application", published on
   the 5th of July 2006.

This code does _**not**_ require the Image Processing Toolbox!

This code was inspired by the python module
"colorspacious" written by Nathaniel J. Smith, available here:

<https://github.com/njsmith/colorspacious>

Smith's very comprehensive python module "colorspacious" was used to
generate the new perceptually uniform colormaps which are now default
for MatPlotLib 2 & MatPlotLib 3. These colormaps are also available for MATLAB here:

<https://www.mathworks.com/matlabcentral/fileexchange/62729-matplotlib-2-0-colormaps--perceptually-uniform-and-beautiful>

My goal was to provide functionality as simple as the commonly used CIELab
colorspace conversions, whilst providing a much more perceptually uniform
colorspace. Note that I replaced calculations with a matrix inverse, e.g.
`inv(A)*b`, with the recommended and numerically more precise `\` or `/`,
see: <https://www.mathworks.com/help/matlab/ref/inv.html>

Quickstart Guide: As Easy As CIELAB!
------------------------------------

Many users will want to convert between sRGB and the CAM02 uniform colorspace,
just as easily as they might use `rgb2lab` and `lab2rgb`. This conversion
is easy with these convenience functions (i.e. `rgb2jab` and `jab2rgb`):

    Jab = sRGB_to_CAM02UCS(rgb)
    rgb = CAM02UCS_to_sRGB(Jab)

These use default values that are appropriate for sRGB (D65 illuminant, etc),
and the CAM02-UCS colorspace (option to select SCD, LCD, or UCS colorspaces).
Note that the sRGB inputs are MATLAB standard float values `0<=rgb<=1` or
integer values `0<=rgb<=intmax(class(rgb))`.

Other Conversions
-----------------

While most users will likely want to convert between sRGB and CAM02
colorspaces, the main functions provide the following conversions:

    CIEXYZ_to_CIECAM02()
    CIECAM02_to_CIEXYZ()

    CIECAM02_to_CAM02UCS()
    CAM02UCS_to_CIECAM02()

And for convenience in MATLAB (note that `XYZ` is scaled so `Ymax==1`):

    sRGB_to_CIEXYZ()
    CIEXYZ_to_sRGB()

Test Scripts
------------

Of course there is no point in writing a conversion this complex without
testing it thoroughly: test functions check the conversion between CIEXYZ
and CIECAM02 and CAM02 J'a'b'. The test values are those referenced in the
Python libraries "colorspacious" and "colour-science".
The test functions are included in this repository.