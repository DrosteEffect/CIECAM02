function rgb = xyz_to_srgb(xyz)
% Convert a matrix of XYZ1 values to sRGB1.
%
% (c) 2107-2019 Stephen Cobeldick
%
%%% Syntax:
% rgb = xyz_to_srgb(xyz)
%
%% Example %%
%
% >> XYZ = [27.88352542538389,23.74833281838537,97.72201291885087];
% >> RGB = xyz_to_srgb(XYZ/100)*255
% RGB =
%       64  128  255
%
%% Input And Output Arguments %%
%
%%% Input
% xyz = NumericArray, tristimulus values to convert, scaled 1931 XYZ colorspace (Ymax==1).
%       Size Nx3 or RxCx3, the last dimension encodes the X,Y,Z values.
%
%%% Output
% rgb = NumericArray, the sRGB values, scaled from 0 to 1.
%       Same size as <xyz>, the last dimension encodes the R,G,B values.
%
% See also SRGB_TO_XYZ CIECAM02_TO_XYZ

%% Input Wrangling %%
%
isz = size(xyz);
assert(isnumeric(xyz)&&isz(end)==3&&isreal(xyz),'Input <rgb> must be an Nx3 or RxCx3 numeric array.')
xyz = reshape(xyz,[],3);
%
%% XYZ2RGB %%
%
M = [...
	+3.2406255,-1.5372080,-0.4986286;...
	-0.9689307,+1.8757561,+0.0415175;...
	+0.0557101,-0.2040211,+1.0569959];
rgb = max(0,min(1, locGammaCor(xyz * M.')));
% Remember to include my license when copying my implementation.
rgb = reshape(rgb,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%xyz_to_srgb
function rgb = locGammaCor(rgb)
% Gamma correction of sRGB data.
idx = rgb <= 0.0031308;
rgb(idx) = 12.92 * rgb(idx);
rgb(~idx) = real(1.055 * rgb(~idx).^(1/2.4) - 0.055);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%locGammaCor
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