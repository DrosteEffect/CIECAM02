function rgb = Jab_to_sRGB(jab,isd,varargin)
% Convert an array of perceptually uniform CAM02 values to sRGB values.
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
%  rgb = Jab_to_sRGB(jab)
%  rgb = Jab_to_sRGB(jab,isd)
%  rgb = Jab_to_sRGB(jab,isd,space)
%  rgb = Jab_to_sRGB(jab,isd,K_L,c1,c2)
%
%% Examples %%
%
% >> jab = [56.913892296685113,-7.948223793113011,-33.591062955940835];
% >> rgb = Jab_to_sRGB(jab)*255
% rgb =
%    64.0000  128.0000  255.0000
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% jab   = NumericArray, CAM02 perceptually uniform colorspace values J'a'b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J',a',b' values.
% isd   = ScalarLogical, select if the J' values are divided by K_L (only
%         required to calculate deltaE for LCD and SCD colorspaces), *false.
% space = CharRowVector, *'UCS'/'LCD'/'SCD' selects a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
%
%%% Outputs:
% rgb = NumericArray of sRGB colorspace values, scaled so 0<=rgb<=1.
%       Same size as input <jab>, the last dimension encodes the R,G,B values.
%
% See also SRGB_TO_JAB JAB_TO_CIECAM02 CIECAM02_TO_XYZ XYZ_TO_SRGB CIECAM02_PARAMETERS JAB_PARAMETERS

%% Input Wrangling %%
%
isz = size(jab);
%
%% Jab2RGB %%
%
one = Jab_parameters(varargin{:});
c02 = Jab_to_CIECAM02(jab,one,nargin>1&&islogical(isd)&&isd);
wp  = CIE_whitepoint('D65');
two = CIECAM02_parameters(wp,20,64/pi/5,'average');
xyz = CIECAM02_to_XYZ(c02,two);
rgb = XYZ_to_sRGB(xyz);
%
rgb = reshape(rgb,isz);
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
