function rgb = Jab_to_srgb(Jab,isd,varargin)
% Convert from the perceptually uniform CAM02 colorspace J'a'b' to the sRGB1 colorspace.
%
% (c) 2017-2019 Stephen Cobeldick
%
%%% Syntax:
%  rgb = Jab_to_srgb(Jab)
%  rgb = Jab_to_srgb(Jab,isd)
%  rgb = Jab_to_srgb(Jab,isd,space)
%  rgb = Jab_to_srgb(Jab,isd,K_L,c1,c2)
%
%% Examples %%
%
% >> Jab = [56.9166292124863,-7.94533638500214,-33.5933304829462];
% >> RGB = Jab_to_srgb(Jab)*255
% RGB =
%       64  128  255
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% Jab   = NumericArray, CAM02 perceptually uniform colorspace values J'a'b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J',a',b' values.
% isd   = ScalarLogical, select if the J' values are divided by K_L (only
%         required to calculate deltaE for LCD and SCD colorspaces), *false.
% space = CharRowVector, *'UCS'/'LCD'/'SCD' selects a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
%
%%% Outputs:
% rgb = NumericArray of sRGB colorspace values, scaled so 0<=rgb<=1.
%       Same size as input <Jab>, the last dimension encodes the R,G,B values.
%
% See also SRGB_TO_JAB JAB_TO_CIECAM02 CIECAM02_TO_XYZ XYZ_TO_SRGB CIECAM02_PARAMETERS JAB_PARAMETERS

%% Input Wrangling %%
%
isz = size(Jab);
assert(isnumeric(Jab)&&isz(end)==3,'Input <Jab> must be an Nx3 or RxCx3 numeric array.')
assert(isreal(Jab),'Input <Jab> values must be real.')
Jab = double(reshape(Jab,[],3));
%
%% Jab2RGB %%
%
tmp = Jab_to_ciecam02(Jab,Jab_parameters(varargin{:}),nargin>1&&islogical(isd)&&isd);
wp  = cie_whitepoint('D65');
prm = ciecam02_parameters(wp,20,64/pi/5,'average');
XYZ = ciecam02_to_XYZ(tmp,prm);
rgb = xyz_to_srgb(XYZ/100);
% Remember to include my license when copying my implementation.
rgb = reshape(rgb,isz);
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