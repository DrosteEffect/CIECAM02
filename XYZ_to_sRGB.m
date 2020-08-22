function xyz = XYZ_to_sRGB(xyz)
% Convert an array of CIE 1931 XYZ values to sRGB values.
%
% (c) 2107-2020 Stephen Cobeldick
%
%%% Syntax:
% rgb = XYZ_to_sRGB(xyz)
%
%% Example %%
%
% >> xyz = [0.278770472005685,0.237451735943392,0.977024183310834];
% >> rgb = XYZ_to_sRGB(xyz)*255
% rgb =
%    64.0000  128.0000  255.0000
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
assert(isnumeric(xyz),'SC:XYZ_to_sRGB:NotNumeric',...
	'1st input <xyz> must be a numeric array.')
assert(isreal(xyz),'SC:XYZ_to_sRGB:Complex',...
	'1st input <xyz> cannot be complex.')
assert(isz(end)==3,'SC:XYZ_to_sRGB:InvalidSize',...
	'1st input <xyz> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
xyz = reshape(xyz,[],3);
err = 1e-4;
assert(all(xyz(:,2)>=(0-err)&xyz(:,2)<=(1+err)),'Input <xyz> values must be scaled so 0<=Y<=1')
%
if ~isfloat(xyz)
	xyz = double(xyz);
end
%
%% XYZ2RGB %%
%
M = [... High-precision sRGB to XYZ matrix:
	0.4124564,0.3575761,0.1804375;...
	0.2126729,0.7151522,0.0721750;...
	0.0193339,0.1191920,0.9503041];
xyz = max(0,min(1, sGammaCor(xyz / M.')));
% Remember to include my license when copying my implementation.
xyz = reshape(xyz,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%XYZ_to_sRGB
function rgb = sGammaCor(rgb)
% Gamma correction of sRGB data.
idx = rgb <= 0.0031308;
rgb(idx) = 12.92 * rgb(idx);
rgb(~idx) = real(1.055 * rgb(~idx).^(1/2.4) - 0.055);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sGammaCor
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
