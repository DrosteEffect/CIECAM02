function XYZ = ciecam02_2_XYZ(arr,S,hdr)
% CIECAM02 to XYZ conversion (CIECAM02 Color Appearance Model to 1931 XYZ colorspace).
%
% (c) 2017 Stephen Cobeldick
%
%%% Syntax:
% XYZ = ciecam02_2_XYZ(arr,S,hdr)
%
%% Examples %%
%
% JMh = [43.7287542718846,52.4967672496318,256.693200456163];
% wp  = cie_whitepoint('D65');
% S   = ciecam02_parameters(wp,20,64/pi/5,'average');
% XYZ = ciecam02_2_XYZ(JMh,S,'JMh');
% RGB = xyz_2_srgb(XYZ/100)*255
% RGB =
%        64      128      255
%
%% Input And Output Arguments %%
%
%%% Inputs:
% arr = NumericArray, the CIECAM02 values [J|Q,C|M|s,H|h].
%       Size Nx3 or RxCx3, the last dimension encodes the J/Q,C/M/s,H/h values.
%       The value sequence must be specified using the third input <hdr>.
% S   = Scalar structure of parameters from CIECAM02_PARAMETERS.
% hdr = CharRowVector, specify the last dimension of <arr>, e.g. 'JMh', where:
%           J = Lightness
%           Q = Brightness
%           C = Chroma
%           M = Colorfulness
%           s = Saturation
%           H = Hue
%           h = Hue Angle
%
%%% Outputs:
% XYZ = NumericArray, tristimulus values, in 1931 XYZ colorspace (Ymax==100).
%       The same size as <arr>, the last dimension encodes the X,Y,Z values.
%
% XYZ = ciecam02_2_XYZ(arr,S,hdr)

%% Input Wrangling %%
%
isz = size(arr);
assert(isnumeric(arr)&&isreal(arr),'Input <arr> must be a real numeric array.')
assert(isz(end)==3,'Input <arr> must have size Nx3 or RxCx3.')
arr = double(reshape(arr,[],3));
%
name = 'ciecam02_parameters';
assert(isstruct(S)&&isscalar(S),'Input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'Structure must be that returned by "%s.m".',name)
%
assert(ischar(hdr)&&isrow(hdr)&&numel(hdr)==3,'Input <hdr> must be a 1x3 char vector.')
%
[id1,ch1] = c2xGetIndices(hdr,'JQ');
[id2,ch2] = c2xGetIndices(hdr,'CMs');
[id3,ch3] = c2xGetIndices(hdr,'hH');
%
%% Conversion %%
%
%%% Step 1:
%
switch ch1 % goal: lightness (J):
	case 'J'
		J = arr(:,id1);
	case 'Q'
		Q = arr(:,id1);
		J = 6.25 * ((S.c .* Q) ./ ((S.A_w+4) * sqrt(sqrt(S.F_L)))).^2;
end
%
switch ch2 % goal: chroma (C):
	case 'C'
		C = arr(:,id2);
	case 'M'
		C = arr(:,id2) ./ sqrt(sqrt(S.F_L));
	case 's'
		if ch1=='J'
			Q = (4./S.c) .* sqrt(J/100) .* (S.A_w+4) .* sqrt(sqrt(S.F_L));
		end
		C = (arr(:,id2) / 100).^2 * (Q ./ sqrt(sqrt(S.F_L)));
end
%
switch ch3 % goal: hue angle (h):
	case 'h'
		h = arr(:,id3);
	case 'H'
		H = arr(:,id3);
		tmp = bsxfun(@le,S.H_i,H.');
		tmp = flipud(cumsum(flipud(tmp),1))==1;
		[idx,~] = find(tmp);
		dH = (H - S.H_i(idx));
		nom = dH .* (S.e_i(idx+1).*S.h_i(idx) - S.e_i(idx).*S.h_i(idx+1))...
			- 100 .* S.e_i(idx+1) .* S.h_i(idx);
		den = dH .* (S.e_i(idx+1)-S.e_i(idx))...
			- 100 .* S.e_i(idx+1);
		h = mod(nom./den, 360);
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
%initalize a,b for vector use 
a=nan(isz(1),1);
b=a;
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ciecam02_2_XYZ
function [idx,typ] = c2xGetIndices(hdr,str)
%
[idx,idc] = ismember(hdr,str);
assert(nnz(idx)==1,'One of ''%s'' characters must be specified.',str)
typ = str(nonzeros(idc));
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%c2xGetIndices
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