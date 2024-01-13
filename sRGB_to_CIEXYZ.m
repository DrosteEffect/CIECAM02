function XYZ = sRGB_to_CIEXYZ(rgb)
% Convert an array of sRGB values to CIE 1931 XYZ values.
%
% (c) 2107-2024 Stephen Cobeldick
%
%%% Syntax:
% XYZ = sRGB_to_CIEXYZ(rgb)
%
%% Example %%
%
% >> rgb = [64,128,255]/255;
% >> XYZ = sRGB_to_CIEXYZ(rgb)
% XYZ =
%      0.27884    0.23748    0.97722
%
%% Input And Output Arguments %%
%
%%% Input:
% rgb = NumericArray, the sRGB values to convert, scaled so that 0<=rgb<=1.
%       Size Nx3 or RxCx3, the last dimension encodes the R,G,B values.
%
%%% Output:
% XYZ = NumericArray, tristimulus values, scaled XYZ colorspace (Ymax==1).
%       The same size as <rgb>, the last dimension encodes the X,Y,Z values.
%
% See also CIEXYZ_TO_SRGB SRGB_TO_CAM02UCS CIEXYZ_TO_CIECAM02

%% Input Wrangling %%
%
isz = size(rgb);
assert(isnumeric(rgb),'SC:sRGB_to_CIEXYZ:rgb:NotNumeric',...
	'1st input <rgb> must be a numeric array.')
assert(isreal(rgb),'SC:sRGB_to_CIEXYZ:rgb:ComplexValue',...
	'1st input <rgb> cannot be complex.')
assert(isz(end)==3,'SC:sRGB_to_CIEXYZ:rgb:InvalidSize',...
	'1st input <rgb> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
rgb = reshape(rgb,[],3);
assert(all(0<=rgb(:)&rgb(:)<=1),'SC:sRGB_to_CIEXYZ:rgb:OutOfRange',...
	'1st input <rgb> values must be 0<=rgb<=1')
%
if ~isfloat(rgb)
	rgb = double(rgb);
end
%
%% RGB2XYZ %%
%
M = [... Standard sRGB to XYZ matrix:
	0.4124,0.3576,0.1805;...
	0.2126,0.7152,0.0722;...
	0.0193,0.1192,0.9505];
% source: IEC 61966-2-1:1999
%
% M = [... High-precision sRGB to XYZ matrix:
% 	0.4124564,0.3575761,0.1804375;...
% 	0.2126729,0.7151522,0.0721750;...
% 	0.0193339,0.1191920,0.9503041];
% source: <http://brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html>
%
XYZ = sGammaInv(rgb) * M.';
XYZ = max(0,min(1,reshape(XYZ,isz)));
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sRGB_to_CIEXYZ
function out = sGammaInv(inp)
% Inverse gamma correction: Nx3 sRGB -> Nx3 linear RGB.
idx = inp > 0.04045;
out = inp / 12.92;
out(idx) = real(((inp(idx) + 0.055) ./ 1.055) .^ 2.4);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sGammaInv
%
% Copyright (c) 2017-2024 Stephen Cobeldick
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