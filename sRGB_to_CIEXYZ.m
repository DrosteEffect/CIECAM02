function XYZ = sRGB_to_CIEXYZ(rgb)
% Convert an array of sRGB values to CIE 1931 XYZ values.
%
%%% Syntax %%%
%
%   XYZ = sRGB_to_CIEXYZ(rgb)
%
%% Examples %%
%
%   >> rgb = [64,128,255]/255;
%   >> XYZ = sRGB_to_CIEXYZ(rgb)
%   XYZ =
%        0.27884    0.23748    0.97722
%
%   >> rgb = uint8([64,128,255]);
%   >> XYZ = sRGB_to_CIEXYZ(rgb)
%   XYZ =
%        0.27884    0.23748    0.97722
%
%% Input Arguments %%
%
%   rgb = Numeric array of sRGB values to convert. Floating point values
%         must be 0<=rgb<=1, integer must be 0<=rgb<=intmax(class(rgb)).
%         Size Nx3 or RxCx3, the last dimension encodes the R,G,B values.
%
%% Output Arguments %%
%
%   XYZ = Double/single array of converted tristimulus values. Values are
%         defined by the CIE 1931 XYZ colorspace, scaled such that Ymax==1.
%         Size Nx3 or RxCx3, the last dimension encodes the X,Y,Z values.
%
%% Dependencies %%
%
% * MATLAB R2009a or later.
%
% See also CIEXYZ_TO_SRGB SRGB_TO_CAM02UCS SRGB_TO_JZAZBZ SRGB_TO_OKLAB

%% Input Wrangling %%
%
isz = size(rgb);
if isfloat(rgb)
	mxv = 1;
elseif isinteger(rgb)
	mxv = intmax(class(rgb));
	rgb = double(rgb)./double(mxv);
else
	error('SC:sRGB_to_CIEXYZ:rgb:NotNumeric',...
	'1st input <rgb> must be a numeric array, not %s',class(rgb))
end
assert(isreal(rgb),...
	'SC:sRGB_to_CIEXYZ:rgb:NotReal',...
	'1st input <rgb> must be a real array (not complex).')
assert(isz(end)==3,...
	'SC:sRGB_to_CIEXYZ:rgb:InvalidSize',...
	'1st input <rgb> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
rgb = reshape(rgb,[],3);
assert(all(0<=rgb(:)&rgb(:)<=1),'SC:sRGB_to_CIEXYZ:rgb:OutOfRange',...
	'1st input <rgb> values must be 0<=rgb<=%d',mxv)
%
%% RGB2XYZ %%
%
M = [... IEC 61966-2-1:1999, used for compatibility with other implementations.
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
% Copyright (c) 2017-2025 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license