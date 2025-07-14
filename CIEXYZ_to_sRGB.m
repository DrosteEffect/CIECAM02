function rgb = CIEXYZ_to_sRGB(XYZ)
% Convert an array of CIE 1931 XYZ values to sRGB values.
%
%%% Syntax %%%
%
%   rgb = CIEXYZ_to_sRGB(XYZ)
%
%% Example %%
%
%   >> XYZ = [0.278835239474185759,0.237483316531782285,0.977220072160195796];
%   >> rgb = CIEXYZ_to_sRGB(XYZ)*255
%   rgb =
%        64.000    128.00    255.00
%
%% Input Arguments %%
%
%   XYZ = Double/single array of tristimulus values to convert. Values 
%         defined by the 1931 XYZ colorspace, scaled such that Ymax==1.
%         Size Nx3 or RxCx3, the last dimension encodes the X,Y,Z values.
%
%% Output Arguments %%
%
%   rgb = Array of sRGB values, scaled from 0 to 1. The same
%         class & size as <XYZ>, the last dimension encodes the R,G,B values.
%
%% Dependencies %%
%
% None
%
% See also SRGB_TO_CIEXYZ CIEXYZ_TO_CIECAM02 SRGB_TO_CAM02UCS

%% Input Wrangling %%
%
isz = size(XYZ);
assert(isfloat(XYZ),...
	'SC:CIEXYZ_to_sRGB:XYZ:NotFloat',...
	'1st input <XYZ> must be a floating point array.')
assert(isreal(XYZ),...
	'SC:CIEXYZ_to_sRGB:XYZ:NotReal',...
	'1st input <XYZ> must be a real array (not complex).')
assert(isz(end)==3,...
	'SC:CIEXYZ_to_sRGB:XYZ:InvalidSize',...
	'1st input <XYZ> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
XYZ = reshape(XYZ,[],3);
assert(all(XYZ(:,2)>=0&XYZ(:,2)<=1),...
	'SC:CIEXYZ_to_sRGB:XYZ:OutOfRangeY',...
	'Input <XYZ> values must be scaled so 0<=Y<=1')
%
%% XYZ2RGB %%
%
M = [... IEC 61966-2-1:1999
	0.4124,0.3576,0.1805;...
	0.2126,0.7152,0.0722;...
	0.0193,0.1192,0.9505];
% M = [... Derived from ITU-R BT.709-6
%    0.412390799265959,0.357584339383878,0.180480788401834;...
%    0.212639005871510,0.715168678767756,0.072192315360734;...
%    0.019330818715592,0.119194779794626,0.950532152249661];
% M = [... <http://brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html>
% 	0.4124564,0.3575761,0.1804375;...
% 	0.2126729,0.7151522,0.0721750;...
% 	0.0193339,0.1191920,0.9503041];
%
rgb = sGammaCor(XYZ / M.');
rgb = max(0,min(1,reshape(rgb,isz)));
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIEXYZ_to_sRGB
function out = sGammaCor(inp)
% Gamma correction of sRGB data.
idx = inp > 0.0031308;
out = 12.92 * inp;
out(idx) = real(1.055 * inp(idx) .^ (1./2.4) - 0.055);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sGammaCor
%
% Copyright (c) 2017-2025 Stephen Cobeldick
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