function rgb = CAM02UCS_to_sRGB(Jab,isd,varargin)
% Convert an array of perceptually uniform CAM02 colorspace values to sRGB values.
%
% (c) 2017-2024 Stephen Cobeldick
%
%%% Syntax:
%  rgb = CAM02UCS_to_sRGB(Jab)
%  rgb = CAM02UCS_to_sRGB(Jab,isd)
%  rgb = CAM02UCS_to_sRGB(Jab,isd,space)
%  rgb = CAM02UCS_to_sRGB(Jab,isd,K_L,c1,c2)
%
% If the input was being used for calculating the euclidean color distance
% (i.e. deltaE) use isd=true, so that J' values are multiplied by K_L.
%
%% Examples %%
%
% >> Jab = [56.9174814457648495,-7.94398845807383758,-33.5932377101949626];
% >> rgb = CAM02UCS_to_sRGB(Jab)*255
% rgb =
%      64.000    128.00    255.00
%
%% Input and Output Arguments %%
%
%%% Inputs (**==default):
% Jab   = Double/single array, CAM02 perceptually uniform colorspace values J'a'b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J',a',b' values.
% isd   = ScalarLogical, true/false** = euclidean distance/reference J' values.
% space = StringScalar or CharRowVector, one of the following:
%         'LCD'/'SCD'/'UCS'**, which selects a predefined CAM02 space
%         LargeColorDifference / SmallColorDifference / UniformColorSpace.
%
%%% Outputs:
% rgb = NumericArray of sRGB colorspace values, scaled so 0<=rgb<=1. The
%       same class & size as <Jab>, the last dimension encodes the R,G,B values.
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
%
% Copyright (c) 2017-2024 Stephen Cobeldick
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license