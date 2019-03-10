function Jab = srgb_to_Jab(rgb,isd,varargin)
% Convert from sRGB1 colorspace to the perceptually uniform CAM02 colorspace J'a'b'.
%
% (c) 2017-2019 Stephen Cobeldick
%
%%% Syntax:
%  Jab = srgb_to_Jab(rgb)
%  Jab = srgb_to_Jab(rgb,isd)
%  Jab = srgb_to_Jab(rgb,isd,space)
%  Jab = srgb_to_Jab(rgb,isd,K_L,c1,c2)
%
%% Examples %%
%
% >> RGB = [64,128,255];
% >> Jab = srgb_to_Jab(RGB/255)
% Jab =
%       56.9166292124863     -7.94533638500214     -33.5933304829462
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
% Jab = NumericArray of CAM02 colorspace values J'a'b'.
%       The same size as <rgb>, the last dimension encodes the J',a',b' values.
%
% See also JAB_TO_SRGB SRGB_TO_XYZ XYZ_TO_CIECAM02 CIECAM02_TO_JAB CIECAM02_PARAMETERS JAB_PARAMETERS

%% Input Wrangling %%
%
isz = size(rgb);
assert(isnumeric(rgb)&&isz(end)==3,'Input <rgb> must be an Nx3 or RxCx3 numeric array.')
assert(isreal(rgb)&&all(0<=rgb(:)&rgb(:)<=1),'Input <rgb> values must be 0<=rgb<=1.')
rgb = double(reshape(rgb,[],3));
%
%% RGB2Jab %%
%
wp  = cie_whitepoint('D65');
prm = ciecam02_parameters(wp,20,64/pi/5,'average');
tmp = XYZ_to_ciecam02(100*srgb_to_xyz(rgb),prm);
Jab = ciecam02_to_Jab(tmp,Jab_parameters(varargin{:}),nargin>1&&islogical(isd)&&isd);
% Remember to include my license when copying my implementation.
Jab = reshape(Jab,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%srgb_to_Jab
%
% Copyright (c) 2017 Stephen Cobeldick
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