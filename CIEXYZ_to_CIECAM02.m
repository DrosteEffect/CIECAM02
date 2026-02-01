function out = CIEXYZ_to_CIECAM02(XYZ,prm,isn)
% Convert an array of CIE 1931 XYZ values to a structure of CIECAM02 values.
%
%%% Syntax %%%
%
%   out = CIEXYZ_to_CIECAM02(XYZ,prm)
%   out = CIEXYZ_to_CIECAM02(XYZ,prm,isn)
%
%% Example %%
%
%   >> XYZ = [0.278835239474185759,0.237483316531782285,0.977220072160195796];
%   >> wp  = CIE_whitepoint('D65');
%   >> prm = CIECAM02_parameters(wp,20,64/pi/5,'average');
%   >> out = CIEXYZ_to_CIECAM02(XYZ,prm)
%   out =
%       J:  43.730
%       Q:  81.799
%       C:  72.616
%       M:  52.496
%       s:  80.110
%       H: 309.38
%       h: 256.70
%
%% Input Arguments (**==default) %%
%
%   XYZ = Double/single array of tristimulus values to convert. Values are
%         defined by the CIE 1931 XYZ colorspace, scaled such that Ymax==1.
%         Size Nx3 or RxCx3, the last dimension encodes the X,Y,Z values.
%   prm = ScalarStructure of parameters from CIECAM02_PARAMETERS.
%   isn = false  -> negative A values are converted to zero.
%       = true** -> negative A values are converted to NaN.
%
%% Output Arguments %%
%
%   out = ScalarStructure with fields of size Nx1 or RxCx1.
%         The fields have the class of <XYZ>. The fields encode:
%         J = Lightness
%         Q = Brightness
%         C = Chroma
%         M = Colorfulness
%         s = Saturation
%         H = Hue Composition
%         h = Hue Angle
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * CIECAM02_parameters.m <https://github.com/DrosteEffect/CIECAM02>
%
% See also CIECAM02_TO_CIEXYZ CIECAM02_TO_CAM02UCS CIEXYZ_TO_SRGB
% CIECAM02_PARAMETERS

%% Input Wrangling %%
%
isz = size(XYZ);
assert(isfloat(XYZ),...
	'SC:CIEXYZ_to_CIECAM02:XYZ:NotFloat',...
	'1st input <XYZ> must be a floating point array.')
assert(isreal(XYZ),...
	'SC:CIEXYZ_to_CIECAM02:XYZ:NotReal',...
	'1st input <XYZ> must be a real array (not complex).')
assert(isz(end)==3 || isequal(isz,[3,1]),...
	'SC:CIEXYZ_to_CIECAM02:XYZ:InvalidSize',...
	'1st input <XYZ> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
isz(find(isz==3,1,'last')) = 1;
%
XYZ = reshape(XYZ,[],3);
assert(all(-0.001<XYZ(:,2)&XYZ(:,2)<1.001),...
	'SC:CIEXYZ_to_CIECAM02:XYZ:OutOfRangeY',...
	'Input <XYZ> values must be scaled so 0<=Y<=1')
%
mfname = 'CIECAM02_parameters';
assert(isstruct(prm)&&isscalar(prm),...
	'SC:CIEXYZ_to_CIECAM02:prm:NotScalarStruct',...
	'2nd input <prm> must be a scalar structure.')
assert(strcmp(prm.mfname,mfname),...
	'SC:CIEXYZ_to_CIECAM02:prm:UnknownStructOrigin',...
	'2nd input <prm> must be the structure returned by "%s.m".',mfname)
%
%% Conversion %%
%
%%% Step 1: cone responses (CAT02) %%%
%
RGB = (100*XYZ) * prm.M_CAT02.';
%
%%% Step 2: chromatic adaptation (cone responses considering luminance and surround) %%%
%
RGB_C = bsxfun(@times, prm.RGB_c, RGB);
%
%%% Step 3: Hunt-Pointer-Estevez response %%%
%
RGBp = RGB_C * (prm.M_HPE / prm.M_CAT02).';
%
%%% Step 4: post-adaption cone response (nonlinear compression) %%%
%
if prm.isns
	tmp = ((prm.F_L.*abs(RGBp))./100).^0.42;
	RGBp_a = 400 .* sign(RGBp) .* tmp ./ (tmp+27.13);
else % CIE
	RGBp_signs = sign(RGBp);
	tmp = (prm.F_L .* bsxfun(@times,RGBp_signs,RGBp)/100).^0.42;
	RGBp_a = 400 .* RGBp_signs .* tmp ./ (tmp+27.13) + 0.1;
end
%
%%% Step 5: hue angle & opponent color dimensions a (red-green) & b (yellow-blue) %%%
%
a = RGBp_a*([11;-12;1]./11);
b = RGBp_a*([1;1;-2]./9);
h_rad = atan2(b,a);
h = mod(180*h_rad/pi, 360);
%
%%% Step 6: hue composition (using unique hue data) %%%
%
hp = h + 360*(h < prm.h_i(1));
tmp = bsxfun(@le,prm.h_i,hp.');
tmp = flipud(cumsum(flipud(tmp),1))==1;
[idx,~] = find(tmp);
tmp = (hp - prm.h_i(idx)) ./ prm.e_i(idx);
H = prm.H_i(idx) + (100*tmp) ./ (tmp + (prm.h_i(idx+1)-hp) ./ prm.e_i(idx+1));
%
%%% Step 7: achromatic response %%%
%
if prm.isns
	A = (RGBp_a*[2;1;1/20]) .* prm.N_bb;
else % CIE
	A = (RGBp_a*[2;1;1/20] - 0.305) .* prm.N_bb;
end
A(A<0) = 0 / ~(nargin<3 || isn);
%
%%% Step 8: correlate of lightness %%%
%
J = 100*(A ./ prm.A_w).^(prm.c.*prm.z); % lightness
%
%%% Step 9: correlate of brightness %%%
%
Q = (4./prm.c) .* sqrt(J/100) .* (prm.A_w+4) .* sqrt(sqrt(prm.F_L)); % brightness
%
%%% Step 10: correlates of chroma, colorfulness, and saturation %%%
%
e = (12500/13) .* prm.N_c .* prm.N_cb .* (cos(h_rad+2) + 3.8); % eccentricity factor
if prm.isns
	tmp = e .* sqrt(a.^2 + b.^2) ./ (RGBp_a*[1;1;21/20]+0.305);
else % CIE
	tmp = e .* sqrt(a.^2 + b.^2) ./ (RGBp_a*[1;1;21/20]);
end
C = tmp.^0.9 .* sqrt(J/100) .* (1.64 - 0.29.^prm.n).^0.73; % chroma
M = C .* sqrt(sqrt(prm.F_L)); % colorfulness
if prm.isns
	s = 50 .* sqrt((C.*prm.c) ./ ((prm.A_w+4).*sqrt(J/100)));
	s(J==0 | s==0) = 0; % saturation
else % CIE
	s = 100*sqrt(M ./ Q); % saturation
end
%
out = struct('J',J,'Q',Q,'C',C,'M',M,'s',s,'H',H,'h',h);
out = structfun(@(v)reshape(v,isz), out, 'UniformOutput',false);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIEXYZ_to_CIECAM02
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license