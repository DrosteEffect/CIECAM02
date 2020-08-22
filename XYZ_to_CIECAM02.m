function out = XYZ_to_CIECAM02(xyz,S,isn)
% Convert an array of CIE 1931 XYZ values to a structure of CIECAM02 values.
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
% out = XYZ_to_CIECAM02(XYZ,S)
% out = XYZ_to_CIECAM02(XYZ,S,isn)
%
%% Example %%
%
% >> rgb = [64,128,255]/255;
% >> xyz = sRGB_to_XYZ(rgb)
% xyz =
%     0.2788    0.2375    0.9770
% >> wp  = CIE_whitepoint('D65');
% >> S   = CIECAM02_parameters(wp,20,64/pi/5,'average');
% >> XYZ_to_CIECAM02(xyz,S)
% ans =
%     J:  43.7260
%     Q:  81.7957
%     C:  72.6126
%     M:  52.4934
%     s:  80.1100
%     H: 309.3756
%     h: 256.6877
%
%% Input And Output Arguments %%
%
%%% Inputs (*==default):
% xyz = NumericArray, tristimulus values to convert, 1931 XYZ colorspace (Ymax==1).
%       Size Nx3 or RxCx3, the last dimension encodes the X,Y,Z values.
% S   = Scalar structure of parameters from CIECAM02_PARAMETERS.
% isn = *true/false -> negative A values are converted to NaNs/zeros.
%
%%% Outputs:
% out = a scalar structure with numeric fields of size Nx1 or RxCx1, with
%       CIECAM02 values calculated from <XYZ> and the input parameters:
%       J = Lightness
%       Q = Brightness
%       C = Chroma
%       M = Colorfulness
%       s = Saturation
%       H = Hue Composition
%       h = Hue Angle
%
% See also CIECAM02_PARAMETERS CIECAM02_TO_XYZ SRGB_TO_JAB JAB_TO_SRGB

%% Input Wrangling %%
%
isz = size(xyz);
assert(isnumeric(xyz),'SC:XYZ_to_CIECAM02:NotNumeric',...
	'1st input <xyz> must be a numeric array.')
assert(isreal(xyz),'SC:XYZ_to_CIECAM02:Complex',...
	'1st input <xyz> cannot be complex.')
assert(isz(end)==3,'SC:XYZ_to_CIECAM02:InvalidSize',...
	'1st input <xyz> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
xyz = reshape(xyz,[],3);
err = 1e-4;
assert(all(xyz(:,2)>=(0-err)&xyz(:,2)<=(1+err)),'Input <xyz> values must be scaled so 0<=Y<=1')
isz(end) = 1;
%
if ~isfloat(xyz)
	xyz = double(xyz);
end
%
name = 'CIECAM02_parameters';
assert(isstruct(S)&&isscalar(S),'SC:XYZ_to_CIECAM02:NotScalarStruct_S',...
	'2nd input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'SC:XYZ_to_CIECAM02:UnknownStructOrigin_S',...
	'2nd input <S> must be the structure returned by "%s.m".',name)
%
%% Conversion %%
%
%%% Step 1: cone responses:
%
LMS = (100*xyz) * S.M_CAT02.';
%
%%% Step 2: cone responses considering luminance and surround:
%
LMS_C = bsxfun(@times, S.LMS_c, LMS);
%
%%% Step 3: Hunt-Pointer-Estevez response:
%
LMSp = LMS_C * (S.M_HPE / S.M_CAT02).';
%
%%% Step 4: post-adaption cone response:
%
LMSp_signs = sign(LMSp);
tmp = (S.F_L .* bsxfun(@times,LMSp_signs,LMSp)/100).^0.42;
LMSp_a = 400*LMSp_signs .* (tmp ./ (tmp+27.13)) + 0.1;
%
%%% Step 5: red-green (a), yellow-blue (b) and hue angle:
%
a = LMSp_a * ([11;-12;1]/11);
b = LMSp_a * ([1;1;-2]/9);
h_rad = atan2(b,a);
h = mod(180*h_rad/pi, 360);
%
%%% Step 6: eccentricity and hue composition:
%
hp = h + 360*(h < S.h_i(1));
tmp = bsxfun(@le,S.h_i,hp.');
tmp = flipud(cumsum(flipud(tmp),1))==1;
[idx,~] = find(tmp);
tmp = (hp - S.h_i(idx)) ./ S.e_i(idx);
H = S.H_i(idx) + (100*tmp) ./ (tmp + (S.h_i(idx+1)-hp) ./ S.e_i(idx+1));
%
%%% Step 7: achromatic response:
%
A = (LMSp_a*[2;1;1/20] - 0.305) .* S.N_bb;
A(A<0) = 0 / ~(nargin<6 || isn);
%
%%% Step 8: correlate of lightness:
%
J = 100*(A ./ S.A_w).^(S.c.*S.z); % lightness
%
%%% Step 9: correlate of brightness:
%
Q = (4./S.c) .* sqrt(J/100) .* (S.A_w+4) .* sqrt(sqrt(S.F_L)); % brightness
%
%%% Step 10: correlates of chroma, colorfulness, and saturation:
%
e = (12500/13) .* S.N_c .* S.N_cb .* (cos(h_rad+2) + 3.8); % eccentricity
tmp = (e .* sqrt(a.^2 + b.^2) ./ (LMSp_a*[1;1;21/20]));
C = tmp.^0.9 .* sqrt(J/100) .* (1.64 - 0.29.^S.n).^0.73; % chroma
M = C .* sqrt(sqrt(S.F_L)); % colorfulness
s = 100*sqrt(M ./ Q); % saturation
%
out = struct('J',J,'Q',Q,'C',C,'M',M,'s',s,'H',H,'h',h);
out = structfun(@(v)reshape(v,isz), out, 'UniformOutput',false);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%XYZ_to_CIECAM02
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
