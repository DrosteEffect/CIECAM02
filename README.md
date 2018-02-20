CIECAM02 Color Appearance Model and CAM02 Uniform ColorSpace for MATLAB
=======================================================================

Based on the paper "CIECAM02 and Its Recent Developments" by color
researchers Ming Ronnier Luo and Changjun Li, published in the book
"Advanced Color Image Processing and Analysis" on the 26th May 2012.
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

Quickstart Guide: As Easy As Lab!
---------------------------------

Many users will want to convert from sRGB1 to J'a'b' uniform colorspace,
just as easily as they might use RGB2LAB and LAB2RGB. I made this just as
easy with the convenience functions srgb_2_Jab and Jab_2_srgb:

    Jab = srgb_2_Jab(rgb)
    rgb = Jab_2_srgb(Jab)

These use default values that are appropriate for sRGB (D65 illuminant, etc).
Note that the sRGB inputs are MATLAB standard values between zero and one.

Other Conversions
-----------------

While most people will likely want RGB to Jab and back again, the
main functions provide the following conversions:

    XYZ_2_ciecam02 % XYZ100 to CIECAM02.
    ciecam02_2_XYZ % CIECAM02 to XYZ100.

    JMh_2_Jab % CIECAM02 subset to Jab.
    Jab_2_JMh % Jab to CIECAM02 subset.

And for convenience in MATLAB (note that XYZ is scaled so Ymax==1):

    srgb_2_xyz % sRGB1 to XYZ1.
    xyz_2_srgb % XYZ1 to sRGB1.

Please pay careful attention to the function input ranges!

Test Script
-----------

Of course there is no point in writing a conversion this complex without
testing it thoroughly. The test values are those referenced in
"colorspacious". The script is included so you can check it yourself.

File and Function Names
-----------------------

Yes, I am well aware that the function names do not follow the common
MATLAB practice: case sensitivity is required because the two
characters "h" and "H" have distinct meanings, and the underscore
helps to distinguish the digits in the case "ciecam02_2_XYZ".
