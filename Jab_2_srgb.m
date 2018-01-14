function rgb = Jab_2_srgb(Jab,varargin)
% Convert from the perceptually uniform J'a'b' colorspace to the sRGB1 colorspace.
%
% (c) 2017 Stephen Cobeldick
%
%%% Syntax:
%  rgb = Jab_2_srgb(Jab)
%  rgb = Jab_2_srgb(Jab,space)
%
%% Examples %%
%
% Jab = [56.9166292124863,-7.94533638500214,-33.5933304829462];
% RGB = Jab_2_srgb(Jab)*255
% RGB =
%          64          128          255
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% Jab   = NumericArray, perceptually uniform colorspace values J',a',b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J',a',b' values.
% space = CharRowVector, *'UCS'/'LCD'/'SCD' selects a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
%
%%% Outputs:
% rgb = NumericArray of sRGB colorspace values, scaled so 0<=rgb<=1.
%       Same size as input <Jab>, the last dimension encodes the R,G,B values.
%
% rgb = Jab_2_srgb(Jab,*space)

%% Input Wrangling %%
%
isz = size(Jab);
assert(isnumeric(Jab)&&isz(end)==3,'Input <Jab> must be an Nx3 or RxCx3 numeric array.')
assert(isreal(Jab),'Input <Jab> values must be real.')
Jab = double(reshape(Jab,[],3));
%
%% Jab2RGB %%
%
JMh = Jab_2_JMh(Jab,Jab_parameters(varargin{:}));
wp = cie_whitepoint('D65');
S  = ciecam02_parameters(wp,20,64/pi/5,'average');
XYZ = ciecam02_2_XYZ(JMh,S,'JMh');
rgb = xyz_2_srgb(XYZ/100);
% Remember to include my license when copying my implementation.
rgb = reshape(rgb,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%srgb_2_Jab
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