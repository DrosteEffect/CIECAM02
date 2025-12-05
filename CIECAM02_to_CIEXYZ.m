function XYZ = CIECAM02_to_CIEXYZ(inp,prm)
% Convert a structure of CIECAM02 values to an array of CIE 1931 XYZ values.
%
%%% Syntax %%%
%
%   xyz = CIECAM02_to_CIEXYZ(inp,prm)
%
%% Example %%
%
%   >> inp.J = 43.7296094671109756;
%   >> inp.M = 52.4958873764575245;
%   >> inp.h = 256.695342232470466;
%   >> wp  = CIE_whitepoint('D65');
%   >> prm = CIECAM02_parameters(wp,20,64/pi/5,'average');
%   >> XYZ = CIECAM02_to_CIEXYZ(inp,prm)
%   XYZ =
%        0.27884    0.23748    0.97722
%   >> rgb = CIEXYZ_to_sRGB(XYZ)*255
%   rgb =
%        64.000     128.00     255.00
%
%% Input Arguments %%
%
%   inp = Scalar structure of the CIECAM02 values, with one field from each
%         of these three groups: [J|Q], [C|M|s], and [H|h]. Each field must
%         have exactly the same size Nx1 or RxCx1. The fields must be
%         all double or all single. The fields encode:
%         J = Lightness
%         Q = Brightness
%         C = Chroma
%         M = Colorfulness
%         s = Saturation
%         H = Hue Composition
%         h = Hue Angle
%   prm = Scalar structure of parameters from CIECAM02_PARAMETERS.
%
%% Output Arguments %%
%
%   XYZ = Numeric array of converted tristimulus values. Values are 
%         defined by the CIE 1931 XYZ colorspace, scaled such that Ymax==1.
%         Size Nx3 or RxCx3, the last dimension encodes the X,Y,Z values.
%
%% Dependencies %%
%
% * MATLAB R2009a or later.
% * CIECAM02_parameters.m <https://github.com/DrosteEffect/CIECAM02>
%
% See also CIEXYZ_TO_CIECAM02 CIEXYZ_TO_SRGB CIECAM02_TO_CAM02UCS
% CIECAM02_PARAMETERS

%% Input Wrangling %%
%
assert(isstruct(inp)&&isscalar(inp),...
	'SC:CIECAM02_to_CIEXYZ:inp:NotScalarStruct',...
	'1st input <inp> must be a scalar structure.')
assert(all(structfun(@isfloat,inp)),...
	'SC:CIECAM02_to_CIEXYZ:inp:FieldsAreNotFloat',...
	'1st input <inp> fields must be floating point arrays.')
assert(all(structfun(@isreal,inp)),...
	'SC:CIECAM02_to_CIEXYZ:inp:FieldsAreNotReal',...
	'1st input <inp> fields must be real arrays (not complex).')
tmp = structfun(@(a){class(a)},inp);
assert(isequal(tmp{:}),...
	'SC:CIECAM02_to_CIEXYZ:inp:FieldsAreNotSameClass',...
	'1st input <inp> fields must be arrays of the same class.')
tmp = structfun(@(a){size(a)},inp);
assert(isequal(tmp{:}),...
	'SC:CIECAM02_to_CIEXYZ:inp:FieldsAreNotSameSize',...
	'1st input <inp> fields must be arrays of the same size.')
isz = tmp{1};
isz(max(2,find([isz==1,true],1,'first'))) = 3;
%
mfname = 'CIECAM02_parameters';
assert(isstruct(prm)&&isscalar(prm),...
	'SC:CIECAM02_to_CIEXYZ:prm:NotScalarStruct',...
	'2nd input <prm> must be a scalar structure.')
assert(strcmp(prm.mfname,mfname),...
	'SC:CIECAM02_to_CIEXYZ:prm:UnknownStructOrigin',...
	'2nd input <prm> must be the structure returned by "%s.m".',mfname)
%
%% Conversion %%
%
%%% Step 1 %%%
%
% Goal: lightness (J)
if isfield(inp,'J')
	J = inp.J(:);
elseif isfield(inp,'Q')
	Q = inp.Q(:);
	J = 6.25 * ((prm.c .* Q) ./ ((prm.A_w+4) * sqrt(sqrt(prm.F_L)))).^2;
else
	error('SC:CIECAM02_to_CIEXYZ:inp:MissingField_J_Q',...
		'Input <inp> must contain the field "J" or "Q".')
end
%
% Goal: chroma (C)
if isfield(inp,'C')
	C = inp.C(:);
elseif isfield(inp,'M')
	C = inp.M(:) ./ sqrt(sqrt(prm.F_L));
elseif isfield(inp,'s')
	if isfield(inp,'J')
		Q = (4./prm.c) .* sqrt(J/100) .* (prm.A_w+4) .* sqrt(sqrt(prm.F_L));
	end
	C = (inp.s(:) / 100).^2 * (Q ./ sqrt(sqrt(prm.F_L)));
else
	error('SC:CIECAM02_to_CIEXYZ:inp:MissingField_C_M_s',...
		'Input <inp> must contain the field "C" or "M" or "s".')
end
%
% Goal: hue angle (h)
if isfield(inp,'h')
	h = inp.h(:);
elseif isfield(inp,'H')
	H = inp.H(:);
	tmp = bsxfun(@le,prm.H_i,H.');
	tmp = flipud(cumsum(flipud(tmp),1))==1;
	[idx,~] = find(tmp);
	dH  = (H - prm.H_i(idx));
	nom = dH .* (prm.e_i(idx+1).*prm.h_i(idx) - prm.e_i(idx).*prm.h_i(idx+1))...
		- 100 .* prm.e_i(idx+1) .* prm.h_i(idx);
	den = dH .* (prm.e_i(idx+1)-prm.e_i(idx))...
		- 100 .* prm.e_i(idx+1);
	h = mod(nom./den, 360);
else
	error('SC:CIECAM02_to_CIEXYZ:inp:MissingField_H_h',...
		'Input <inp> must contain the field "h" or "H".')
end
%
%%% Step 2 %%%
%
t  = (C ./ (sqrt(J./100) .* (1.64 - 0.29.^prm.n).^0.73)) .^ (1/0.9);
et = (cos(pi*h/180+2)+3.8) / 4;
A  = prm.A_w .* (J./100) .^ (1./(prm.c*prm.z));
p1 = (50000/13 * prm.N_c * prm.N_cb) * et ./ t;
p2 = A ./ prm.N_bb + 0.305;
p3 = 21/20;
%
%%% Step 3: red-green (a), yellow-blue (b) %%%
%
a = nan(size(h),class(h));
b = nan(size(h),class(h));
%
idx = abs(sind(h)) >= abs(cosd(h));
%
nom = 460 * (p2 .* (2+p3)) / 1403;
den = 220 * (2+p3) / 1403;
%
tmp = cosd(h(idx))./sind(h(idx));
b(idx) = nom(idx) ./ ((p1(idx) ./ sind(h(idx))) + den .* tmp - ...
	(27/1403) + p3.*(6300/1403)); %bryce:change: p3 is a scalar so should not be p3(idx)
a(idx) = b(idx) .* tmp;
%
idx = ~idx;
%
tmp = sind(h(idx))./cosd(h(idx));
a(idx) = nom(idx) ./ ((p1(idx) ./ cosd(h(idx))) + den - ...
	((27/1403) - p3.*(6300/1403)) .* tmp); %bryce:change: p3 is a scalar so should not be p3(idx)
b(idx) = a(idx) .* tmp;
%
idx = t==0;
a(idx) = 0;
b(idx) = 0;
%
%%% Step 4: post-adaption cone response %%%
%
LMSp_a = (460*p2+[+451*a+288*b,-891*a-261*b,-220*a-6300*b])/1403;
%
%%% Step 5: Hunt-Pointer-Estevez response %%%
%
tmp = (27.13 * abs(LMSp_a-0.1)) ./ (400-abs(LMSp_a-0.1));
LMSp = sign(LMSp_a - 0.1) .* (100./prm.F_L) .* tmp.^(1/0.42);
%
%%% Step 6: cone responses considering luminance and surround %%%
%
LMS_C = LMSp * (prm.M_CAT02 / prm.M_HPE).';
%
%%% Step 7: cone responses %%%
%
LMS = bsxfun(@rdivide,LMS_C,prm.LMS_c);
%
%%% Step 8: tristimulus values %%%
%
XYZ = LMS / prm.M_CAT02.';
%
XYZ = reshape(max(0,min(1,XYZ/100)),isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIECAM02_to_CIEXYZ
% Copyright (c) 2017-2025 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license