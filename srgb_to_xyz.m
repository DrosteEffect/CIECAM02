function xyz = srgb_to_xyz(rgb)
% Convert a matrix of sRGB1 values to XYZ1.
%
% (c) 2107-2019 Stephen Cobeldick
%
%%% Syntax:
% xyz = srgb_to_xyz(rgb)
%
%% Example %%
%
% >> RGB = [64,128,255];
% >> YXZ = srgb_to_xyz(RGB/255)*100
% YXZ =
%       27.88352542538389  23.74833281838537  97.72201291885087
%
%% Input And Output Arguments %%
%
%%% Input:
% rgb = NumericArray, the sRGB values to convert, scaled so that 0<=rgb<=1.
%       Size Nx3 or RxCx3, the last dimension encodes the R,G,B values.
%
%%% Output:
% xyz = NumericArray, tristimulus values, scaled 1931 XYZ colorspace (Ymax==1).
%       The same size as <rgb>, the last dimension encodes the X,Y,Z values.
%
% See also XYZ_TO_SRGB XYZ_TO_CIECAM02

%% Input Wrangling %%
%
isz = size(rgb);
assert(isnumeric(rgb)&&isz(end)==3,'Input <rgb> must be an Nx3 or RxCx3 numeric array.')
assert(isreal(rgb)&&all(0<=rgb(:)&rgb(:)<=1),'Input <rgb> values must be 0<=rgb<=1.')
rgb = reshape(rgb,[],3);
%
%% RGB2XYZ %%
%
M = [...
	+3.2406255,-1.5372080,-0.4986286;...
	-0.9689307,+1.8757561,+0.0415175;...
	+0.0557101,-0.2040211,+1.0569959];
xyz = locGammaInv(rgb) / M.';
% Remember to include my license when copying my implementation.
xyz = reshape(xyz,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%srgb_to_xyz
function rgb = locGammaInv(rgb)
% Inverse gamma transform of sRGB data.
idx = rgb <= 0.04045;
rgb(idx) = rgb(idx) / 12.92;
rgb(~idx) = real(((rgb(~idx) + 0.055) / 1.055).^2.4);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%locGammaInv
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