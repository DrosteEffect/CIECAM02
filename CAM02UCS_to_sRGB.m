function rgb = CAM02UCS_to_sRGB(Jab,isd,varargin)
% Convert an array of perceptually uniform CAM02 colorspace values to sRGB values.
%
%%% Syntax %%%
%
%   rgb = CAM02UCS_to_sRGB(Jab)
%   rgb = CAM02UCS_to_sRGB(Jab,isd)
%   rgb = CAM02UCS_to_sRGB(Jab,isd,space)
%   rgb = CAM02UCS_to_sRGB(Jab,isd,K_L,c1,c2)
%
% If the input was being used for calculating the euclidean color distance
% (i.e. deltaE) use isd=true, so that J' values are multiplied by K_L.
%
%% Example %%
%
%   >> Jab = [56.9174814457648495,-7.94398845807383758,-33.5932377101949626];
%   >> rgb = CAM02UCS_to_sRGB(Jab)*255
%   rgb =
%        64.000    128.00    255.00
%
%% Input Arguments (**==default) %%
%
%   Jab = Double/single array, CAM02 perceptually uniform colorspace values J'a'b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J',a',b' values.
%   isd = true    -> scale J' for euclidean distance calculations (divide by K_L)
%       = false** -> return reference J' values (no scaling).
%   space = StringScalar or CharRowVector, one of the following:
%           'LCD'/'SCD'/'UCS'**, which selects a predefined CAM02 space
%           LargeColorDifference / SmallColorDifference / UniformColorSpace.
%
%% Output Arguments %%
%
%   rgb = NumericArray of sRGB colorspace values, scaled so 0<=rgb<=1. Has the
%         same class & size as <Jab>, the last dimension encodes the R,G,B values.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * CAM02UCS_parameters.m, CAM02UCS_to_CIECAM02.m, CIE_whitepoint.m,
%   CIECAM02_parameters.m, CIECAM02_to_CIEXYZ.m, and CIEXYZ_to_sRGB.m 
%   all from <https://github.com/DrosteEffect/CIECAM02>
%
% See also SRGB_TO_CAM02UCS CAM02UCS_PARAMETERS CIECAM02_PARAMETERS
% CIE_WHITEPOINT CAM02UCS_TO_CIECAM02 SRGB_TO_CIEXYZ MAXDISTCOLOR

%% Input Wrangling %%
%
isz = size(Jab);
%
%% Jab2RGB %%
%
one = CAM02UCS_parameters(varargin{:});
c02 = CAM02UCS_to_CIECAM02(Jab,one,nargin>1&&isd);
wp  = CIE_whitepoint('D65');
two = CIECAM02_parameters(wp,20,64/pi/5,'average');
xyz = CIECAM02_to_CIEXYZ(c02,two);
rgb = CIEXYZ_to_sRGB(xyz);
%
rgb = reshape(rgb,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAM02UCS_to_sRGB
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license