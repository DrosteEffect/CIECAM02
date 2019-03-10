function XYZ = ciecam02_to_XYZ(inp,S)
% CIECAM02 to XYZ conversion (CIECAM02 Color Appearance Model to 1931 XYZ colorspace).
%
% (c) 2017-2019 Stephen Cobeldick
%
%%% Syntax:
% XYZ = ciecam02_to_XYZ(inp,S)
%
%% Example %%
%
% >> inp.J = 43.7296106370812;
% >> inp.M = 52.4958884171155;
% >> inp.h = 256.695342260531;
% >> wp  = cie_whitepoint('D65');
% >> S   = ciecam02_parameters(wp,20,64/pi/5,'average');
% >> XYZ = ciecam02_to_XYZ(inp,S)
% XYZ =
%       27.88352542538377  23.74833281838534  97.72201291885064
% >> RGB = xyz_to_srgb(XYZ/100)*255
% RGB =
%       64  128  255
%
%% Input And Output Arguments %%
%
%%% Inputs:
% inp = Scalar structure of the CIECAM02 values, with one field from each
%       of these three groups: [J|Q], [C|M|s], and [H|h]. Each field must
%       have exactly the same size Nx3 or RxCx3. The fields encode:
%       J = Lightness
%       Q = Brightness
%       C = Chroma
%       M = Colorfulness
%       s = Saturation
%       H = Hue Composition
%       h = Hue Angle
% S   = Scalar structure of parameters from CIECAM02_PARAMETERS.
%
%%% Outputs:
% XYZ = NumericArray, tristimulus values, in 1931 XYZ colorspace (Ymax==100).
%       Size Nx3 or RxCx3, the last dimension encodes the XYZ values.
%
% See also CIECAM02_PARAMETERS XYZ_TO_CIECAM02 SRGB_TO_JAB JAB_TO_SRGB

%% Input Wrangling %%
%
assert(isstruct(inp)&&isscalar(inp),'Input <inp> must be a scalar structure.')
fld = fieldnames(inp);
tmp = numel(fld);
fld = [fld{:}];
assert((tmp>=3)&&(tmp<=7),'Input <inp> must have three fields.')
tmp = structfun(@(a)isnumeric(a)&&isreal(a),inp);
assert(all(tmp),'Input <inp> fields must be real numeric arrays.')
tmp = structfun(@(a){size(a)},inp);
assert(isequal(tmp{:}),'Input <inp> fields must be arrays of the same size.')
isz = tmp{1};
isz(max(2,find([isz==1,true],1,'first'))) = 3;
%
name = 'ciecam02_parameters';
assert(isstruct(S)&&isscalar(S),'Input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'Structure <S> must be that returned by "%s.m".',name)
%
%% Conversion %%
%
%%% Step 1:
%
switch true % goal: lightness (J):
	case any(fld=='J')
		J = double(inp.J(:));
	case any(fld=='Q')
		Q = double(inp.Q(:));
		J = 6.25 * ((S.c .* Q) ./ ((S.A_w+4) * sqrt(sqrt(S.F_L)))).^2;
	otherwise
		error('Input <inp> must contain one field ''J'' or ''Q''.')
end
%
switch true % goal: chroma (C):
	case any(fld=='C')
		C = double(inp.C(:));
	case any(fld=='M')
		C = double(inp.M(:)) ./ sqrt(sqrt(S.F_L));
	case any(fld=='s')
		if any(fld=='J')
			Q = (4./S.c) .* sqrt(J/100) .* (S.A_w+4) .* sqrt(sqrt(S.F_L));
		end
		C = (double(inp.s(:)) / 100).^2 * (Q ./ sqrt(sqrt(S.F_L)));
	otherwise
		error('Input <inp> must contain one field ''C'' or ''M'' or ''s''.')
end
%
switch true % goal: hue angle (h):
	case any(fld=='h')
		h = double(inp.h(:));
	case any(fld=='H')
		H = double(inp.H(:));
		tmp = bsxfun(@le,S.H_i,H.');
		tmp = flipud(cumsum(flipud(tmp),1))==1;
		[idx,~] = find(tmp);
		dH = (H - S.H_i(idx));
		nom = dH .* (S.e_i(idx+1).*S.h_i(idx) - S.e_i(idx).*S.h_i(idx+1))...
			- 100 .* S.e_i(idx+1) .* S.h_i(idx);
		den = dH .* (S.e_i(idx+1)-S.e_i(idx))...
			- 100 .* S.e_i(idx+1);
		h = mod(nom./den, 360);
	otherwise
		error('Input <inp> must contain one field ''h'' or ''H''.')
end
%
%%% Step 2:
%
t = (C ./ (sqrt(J./100) .* (1.64 - 0.29.^S.n).^0.73)) .^ (1/0.9);
et = (cos(pi*h/180+2)+3.8) / 4;
A = S.A_w .* (J./100) .^ (1./(S.c*S.z));
p1 = (50000/13 * S.N_c * S.N_cb) * et ./ t;
p2 = A ./ S.N_bb + 0.305;
p3 = 21/20;
%
%%% Step 3: red-green (a), yellow-blue (b):
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
%%% Step 4: post-adaption cone response:
%
LMSp_a = (460*p2+[+451*a+288*b,-891*a-261*b,-220*a-6300*b])/1403;
%
%%% Step 5: Hunt-Pointer-Estevez response:
%
tmp = (27.13 * abs(LMSp_a-0.1)) ./ (400-abs(LMSp_a-0.1));
LMSp = sign(LMSp_a - 0.1) .* (100./S.F_L) .* tmp.^(1/0.42);
%
%%% Step 6: cone responses considering luminance and surround:
%
LMS_C = LMSp * (S.M_CAT02 / S.M_HPE).';
%
%%% Step 7: cone responses:
%
LMS = bsxfun(@rdivide,LMS_C,S.LMS_c);
%
%%% Step 8: tristimulus values:
%
XYZ = LMS / S.M_CAT02.';
%
XYZ = reshape(XYZ,isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ciecam02_to_XYZ
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