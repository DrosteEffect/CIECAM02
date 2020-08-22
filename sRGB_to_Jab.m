function jab = sRGB_to_Jab(rgb,isd,varargin)
% Convert an array of sRGB values to perceptually uniform CAM02 values.
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
%  jab = sRGB_to_Jab(rgb)
%  jab = sRGB_to_Jab(rgb,isd)
%  jab = sRGB_to_Jab(rgb,isd,space)
%  jab = sRGB_to_Jab(rgb,isd,K_L,c1,c2)
%
%% Examples %%
%
% >> rgb = [64,128,255]/255;
% >> jab = sRGB_to_Jab(rgb)
% jab =
%    56.9139   -7.9482  -33.5911
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% rgb   = NumericArray of RGB values, scaled so that 0<=rgb<=1.
%         Size Nx3 or RxCx3, the last dimension encodes the R,G,B values.
% isd   = ScalarLogical, select if the J' values are divided by K_L (only
%         required to calculate deltaE for LCD and SCD colorspaces), *false.
% space = CharRowVector, *'UCS'/'LCD'/'SCD' selects a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
%
%%% Outputs:
% jab = NumericArray of CAM02 colorspace values J'a'b'.
%       The same size as <rgb>, the last dimension encodes the J',a',b' values.
%
% See also JAB_TO_SRGB SRGB_TO_XYZ XYZ_TO_CIECAM02 CIECAM02_TO_JAB CIECAM02_PARAMETERS JAB_PARAMETERS

%% Input Wrangling %%
%
isz = size(rgb);
%
%% RGB2Jab %%
%
wp  = CIE_whitepoint('D65');
two = CIECAM02_parameters(wp,20,64/pi/5,'average');
c02 = XYZ_to_CIECAM02(sRGB_to_XYZ(rgb),two);
one = Jab_parameters(varargin{:});
jab = CIECAM02_to_Jab(c02,one,nargin>1&&islogical(isd)&&isd);
%
jab = reshape(jab,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sRGB_to_Jab
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
