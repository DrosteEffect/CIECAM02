function Jab = srgb_2_Jab(rgb,varargin)
% Convert from sRGB1 colorspace to the perceptually uniform J'a'b' colorspace.
%
% (c) 2017 Stephen Cobeldick
%
%%% Syntax:
%  Jab = srgb_2_Jab(rgb)
%  Jab = srgb_2_Jab(rgb,space)
%
%% Examples %%
%
% RGB = [64,128,255];
% Jab = srgb_2_Jab(RGB/255)
% Jab =
%       56.9166292124863     -7.94533638500214     -33.5933304829462
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% rgb   = Nx3 or RxCx3 numeric array of RGB values, 0<=rgb<=1.
% space = 1xN char, *'UCS'/'LCD'/'SCD': to select a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
%
%%% Outputs:
% Jab = numeric array of CAM02 J'a'b' colorspace values, same size as input <rgb>.

%% Input Wrangling %%
%
isz = size(rgb);
assert(isnumeric(rgb)&&isz(end)==3,'Input <rgb> must be an Nx3 or RxCx3 numeric array.')
assert(isreal(rgb)&&all(0<=rgb(:)&rgb(:)<=1),'Input <rgb> values must be 0<=rgb<=1.')
rgb = double(reshape(rgb,[],3));
%
%% RGB2Jab %%
%
wp = cie_whitepoint('D65');
S  = ciecam02_parameters(wp,20,64/pi/5,'average');
JQCMsHh = XYZ_2_ciecam02(100*srgb_2_xyz(rgb),S);
Jab  = JMh_2_Jab(JQCMsHh(:,[1,4,7]),Jab_parameters(varargin{:}));
% Remember to include my license when copying my implementation.
Jab = reshape(Jab,isz);
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