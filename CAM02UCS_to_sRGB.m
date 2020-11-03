function rgb = CAM02UCS_to_sRGB(Jab,isd,varargin)
% Convert an array of perceptually uniform CAM02 colorspace values to sRGB values.
%
% (c) 2017-2020 Stephen Cobeldick
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
% >> Jab = [56.913892296685113,-7.948223793113011,-33.591062955940835];
% >> rgb = CAM02UCS_to_sRGB(Jab)*255
% rgb =
%    64.0000  128.0000  255.0000
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% Jab   = NumericArray, CAM02 perceptually uniform colorspace values J'a'b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J',a',b' values.
% isd   = ScalarLogical, true/false* = euclidean distance/reference J' values.
% space = CharRowVector, *'UCS'/'LCD'/'SCD' selects a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
%
%%% Outputs:
% rgb = NumericArray of sRGB colorspace values, scaled so 0<=rgb<=1.
%       Same size as input <Jab>, the last dimension encodes the R,G,B values.
%
% See also SRGB_TO_CAM02UCS CAM02UCS_PARAMETERS CIECAM02_PARAMETERS CIE_WHITEPOINT
% CAM02UCS_TO_CIECAM02 SRGB_TO_CIEXYZ

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
% Copyright (c) 2017-2020 Stephen Cobeldick
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
