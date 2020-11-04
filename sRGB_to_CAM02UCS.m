function Jab = sRGB_to_CAM02UCS(rgb,isd,varargin)
% Convert an array of sRGB values to perceptually uniform CAM02 values.
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
%  Jab = sRGB_to_CAM02UCS(rgb)
%  Jab = sRGB_to_CAM02UCS(rgb,isd)
%  Jab = sRGB_to_CAM02UCS(rgb,isd,space)
%  Jab = sRGB_to_CAM02UCS(rgb,isd,K_L,c1,c2)
%
% If the output is being used for calculating the euclidean color distance
% (i.e. deltaE) use isd=true, so that J' values are divided by K_L.
%
%% Examples %%
%
% >> rgb = [64,128,255]/255;
% >> Jab = sRGB_to_CAM02UCS(rgb)
% Jab =
%    56.9139   -7.9482  -33.5911
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% rgb = NumericArray of RGB values, scaled so that 0<=rgb<=1.
%       Size Nx3 or RxCx3, the last dimension encodes the R,G,B values.
% isd = ScalarLogical, true/false* = euclidean distance/reference J' values.
% space = CharRowVector, *'UCS'/'LCD'/'SCD' selects a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
%
%%% Outputs:
% Jab = NumericArray of CAM02 colorspace values J'a'b'.
%       The same size as <rgb>, the last dimension encodes the J',a',b' values.
%
% See also CAM02UCS_TO_SRGB CAM02UCS_PARAMETERS CIECAM02_PARAMETERS CIE_WHITEPOINT
% CAM02UCS_TO_CIECAM02 SRGB_TO_CIEXYZ

%% Input Wrangling %%
%
isz = size(rgb);
%
%% RGB2Jab %%
%
wp  = CIE_whitepoint('D65');
two = CIECAM02_parameters(wp,20,64/pi/5,'average');
c02 = CIEXYZ_to_CIECAM02(sRGB_to_CIEXYZ(rgb),two);
one = CAM02UCS_parameters(varargin{:});
Jab = CIECAM02_to_CAM02UCS(c02,one,nargin>1&&isd);
%
Jab = reshape(Jab,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sRGB_to_CAM02UCS
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
