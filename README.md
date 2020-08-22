CIECAM02 Color Appearance Model and CAM02 Uniform ColorSpace for MATLAB
=======================================================================

This code is based on two sources:

1. the chapter "CIECAM02 and Its Recent Developments" by color
   researchers Ming Ronnier Luo and Changjun Li, published in the book
   "Advanced Color Image Processing and Analysis" on the 26th May 2012.
2. the article "Uniform Colour Spaces Based on CIECAM02
   Colour Appearance Model", by color researchers Ming Ronnier Luo,
   Guihua Cui, and Changjun Li, from volume 31 issue 4 of the journal
   "Color Research and Application", published on the 5th July 2006.

This MATLAB implementation was inspired by the python module
"colorspacious" written by Nathaniel J. Smith, available here:

https://github.com/njsmith/colorspacious

Smith's very comprehensive python module "colorspacious" was used to
generate the new perceptually uniform colormaps which are now default
for MatPlotLib 2.0. These colormaps are also available for MATLAB here:

https://www.mathworks.com/matlabcentral/fileexchange/62729-matplotlib-2-0-colormaps--perceptually-uniform-and-beautiful

My goal was to provide functionality as simple as the commonly used Lab
colorspace conversions, whilst providing a much more perceptually uniform
colorspace. Note that I replaced calculations with a matrix inverse, e.g.
inv(A)*b, with the recommended and numerically more precise A\b. See:

https://www.mathworks.com/help/matlab/ref/inv.html

Quickstart Guide: As Easy As CIELAB!
------------------------------------

Many users will want to convert between sRGB and the CAM02 uniform colorspace,
just as easily as they might use |rgb2lab| and |lab2rgb|. I made this conversion
easy with the convenience functions |sRGB_to_Jab| and |Jab_to_sRGB|:

    Jab = sRGB_to_Jab(rgb)
    rgb = Jab_to_sRGB(Jab)

These use default values that are appropriate for sRGB (D65 illuminant, etc),
and by default the CAM02 UCS colorspace (SCD, LCD, etc. can be selected).
Note that the sRGB inputs are MATLAB standard float values 0<=rgb<=1.

Other Conversions
-----------------

While many users will likely want sRGB to Jab and back again, the
main functions provide the following conversions:

    XYZ_to_CIECAM02()
    CIECAM02_to_XYZ()

    CIECAM02_to_Jab()
    Jab_to_CIECAM02()

And for convenience in MATLAB (note that XYZ is scaled so Ymax==1):

    sRGB_to_XYZ()
    XYZ_to_sRGB()

Please pay careful attention to the data numeric ranges!

Test Scripts
------------

Of course there is no point in writing a conversion this complex without
testing it thoroughly: test functions check the conversion between XYZ
and CIECAM02 and J'a'b'. The test values are those referenced in
"colorspacious", and the test functions are included in this repository.

CIECAM02 Color Appearance Model and CAM02 Uniform ColorSpace for MATLAB
=======================================================================

This code is based on two sources:

1. the chapter "CIECAM02 and Its Recent Developments" by color
   researchers Ming Ronnier Luo and Changjun Li, published in the book
   "Advanced Color Image Processing and Analysis" on the 26th May 2012.
2. the article "Uniform Colour Spaces Based on CIECAM02
   Colour Appearance Model", by color researchers Ming Ronnier Luo,
   Guihua Cui, and Changjun Li, from volume 31 issue 4 of the journal
   "Color Research and Application", published on the 5th July 2006.

This MATLAB implementation was inspired by the python module
"colorspacious" written by Nathaniel J. Smith, available here:

https://github.com/njsmith/colorspacious

Smith's very comprehensive python module "colorspacious" was used to
generate the new perceptually uniform colormaps which are now default
for MatPlotLib 2.0. These colormaps are also available for MATLAB here:

https://www.mathworks.com/matlabcentral/fileexchange/62729-matplotlib-2-0-colormaps--perceptually-uniform-and-beautiful

My goal was to provide functionality as simple as the commonly used Lab
colorspace conversions, whilst providing a much more perceptually uniform
colorspace. Note that I replaced calculations with a matrix inverse, e.g.
inv(A)*b, with the recommended and numerically more precise A\b. See:

https://www.mathworks.com/help/matlab/ref/inv.html

Quickstart Guide: As Easy As CIELAB!
------------------------------------

Many users will want to convert between sRGB and the CAM02 uniform colorspace,
just as easily as they might use |rgb2lab| and |lab2rgb|. I made this conversion
easy with the convenience functions |sRGB_to_Jab| and |Jab_to_sRGB|:

    Jab = sRGB_to_Jab(rgb)
    rgb = Jab_to_sRGB(Jab)

These use default values that are appropriate for sRGB (D65 illuminant, etc),
and by default the CAM02 UCS colorspace (SCD, LCD, etc. can be selected).
Note that the sRGB inputs are MATLAB standard float values 0<=rgb<=1.

Other Conversions
-----------------

While many users will likely want sRGB to Jab and back again, the
main functions provide the following conversions:

    XYZ_to_CIECAM02()
    CIECAM02_to_XYZ()

    CIECAM02_to_Jab()
    Jab_to_CIECAM02()

And for convenience in MATLAB (note that XYZ is scaled so Ymax==1):

    sRGB_to_XYZ()
    XYZ_to_sRGB()

Please pay careful attention to the data numeric ranges!

Test Scripts
------------

Of course there is no point in writing a conversion this complex without
testing it thoroughly: test functions check the conversion between XYZ
and CIECAM02 and J'a'b'. The test values are those referenced in
"colorspacious", and the test functions are included in this repository.
