function [rgb,raw] = CIEXYZ_to_sRGB(XYZ,M)
% Convert an array of CIE 1931 XYZ values to sRGB values.
%
%%% Syntax %%%
%
%   rgb = CIEXYZ_to_sRGB(XYZ)
%   rgb = CIEXYZ_to_sRGB(XYZ,M)
%
%% Example %%
%
%   >> XYZ = sRGB_to_CIEXYZ([64,128,255]./255)
%   XYZ = [0.2788, 0.2375, 0.9773]
%   >> rgb = CIEXYZ_to_sRGB(XYZ)*255
%   rgb =
%         64    128    255
%
%% Input Arguments %%
%
%   XYZ = Double/single array of tristimulus values to convert. Values are
%         defined by the CIE 1931 XYZ colorspace, scaled such that Ymax==1.
%         Size Nx3 or RxCx3, the last dimension encodes the X,Y,Z values.
%     M = Numeric array of size 3x3, a matrix of sRGB->XYZ conversion.
%       = StringScalar/CharVector of a supported sRGB->XYZ conversion,
%         see get_sRGB_matrix.m for a list of the supported conversions.
%
%% Output Arguments %%
%
%   rgb = Array of sRGB values, scaled from 0 to 1. The same
%         class & size as <XYZ>, the last dimension encodes the R,G,B values.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * get_sRGB_matrix.m from <https://github.com/DrosteEffect/CIECAM02>
%
% See also SRGB_TO_CIEXYZ GET_SRGB_MATRIX CAM02UCS_TO_SRGB OKLAB_TO_SRGB

%% Input Wrangling %%
%
isz = size(XYZ);
assert(isfloat(XYZ),...
	'SC:CIEXYZ_to_sRGB:XYZ:NotFloat',...
	'1st input <XYZ> must be a floating point array.')
assert(isreal(XYZ),...
	'SC:CIEXYZ_to_sRGB:XYZ:NotReal',...
	'1st input <XYZ> must be a real array (not complex).')
assert(isz(end)==3 || isequal(isz,[3,1]),...
	'SC:CIEXYZ_to_sRGB:XYZ:InvalidSize',...
	'1st input <XYZ> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
XYZ = reshape(XYZ,[],3);
assert(all(-0.001<XYZ(:,2)&XYZ(:,2)<1.001),...
	'SC:CIEXYZ_to_sRGB:XYZ:OutOfRangeY',...
	'Input <XYZ> values must be scaled so 0<=Y<=1')
%
if nargin<2 || isequal(M,[])
	M = get_sRGB_matrix();
else
	M = get_sRGB_matrix(M); % this does input checking!
end
%
%% XYZ2RGB %%
%
raw = sGammaCor(XYZ / M.');
raw = reshape(raw,isz);
rgb = max(0,min(1,raw));
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIEXYZ_to_sRGB
function out = sGammaCor(inp)
% Gamma correction: Nx3 linear RGB -> Nx3 sRGB.
idx = inp > 0.0031308;
out = 12.92 * inp;
out(idx) = real(1.055 * inp(idx) .^ (1./2.4) - 0.055);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sGammaCor
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license