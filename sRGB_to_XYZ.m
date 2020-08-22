function xyz = sRGB_to_XYZ(rgb)
% Convert an array of sRGB values to CIE 1931 XYZ values.
%
% (c) 2107-2020 Stephen Cobeldick
%
%%% Syntax:
% xyz = sRGB_to_XYZ(rgb)
%
%% Example %%
%
% >> rgb = [64,128,255]/255;
% >> xyz = sRGB_to_XYZ(rgb)
% xyz =
%     0.2788    0.2375    0.9770
%
%% Input And Output Arguments %%
%
%%% Input:
% rgb = NumericArray, the sRGB values to convert, scaled so that 0<=rgb<=1.
%       Size Nx3 or RxCx3, the last dimension encodes the R,G,B values.
%
%%% Output:
% xyz = NumericArray, tristimulus values, scaled XYZ colorspace (Ymax==1).
%       The same size as <rgb>, the last dimension encodes the X,Y,Z values.
%
% See also XYZ_TO_SRGB XYZ_TO_CIECAM02

%% Input Wrangling %%
%
isz = size(rgb);
assert(isnumeric(rgb),'SC:sRGB_to_XYZ:NotNumeric',...
	'1st input <rgb> must be a numeric array.')
assert(isreal(rgb),'SC:sRGB_to_XYZ:Complex',...
	'1st input <rgb> cannot be complex.')
assert(isz(end)==3,'SC:sRGB_to_XYZ:InvalidSize',...
	'1st input <rgb> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
rgb = reshape(rgb,[],3);
assert(all(0<=rgb(:)&rgb(:)<=1),'',...
	'1st input <rgb> values must be 0<=rgb<=1')
%
if ~isfloat(rgb)
	rgb = double(rgb);
end
%
%% RGB2XYZ %%
%
M = [... High-precision sRGB to XYZ matrix:
	0.4124564,0.3575761,0.1804375;...
	0.2126729,0.7151522,0.0721750;...
	0.0193339,0.1191920,0.9503041];
xyz = sGammaInv(rgb) * M.';
% Remember to include my license when copying my implementation.
xyz = reshape(xyz,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sRGB_to_xyz
function rgb = sGammaInv(rgb)
% Inverse gamma transform of sRGB data.
idx = rgb <= 0.04045;
rgb(idx) = rgb(idx) / 12.92;
rgb(~idx) = real(((rgb(~idx) + 0.055) / 1.055).^2.4);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sGammaInv
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
