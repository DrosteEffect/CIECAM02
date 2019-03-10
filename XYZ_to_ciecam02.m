function out = XYZ_to_ciecam02(XYZ,S,isn)
% XYZ to CIECAM02 conversion (1931 XYZ colorspace to CIECAM02 Color Appearance Model).
%
% (c) 2017-2019 Stephen Cobeldick
%
%%% Syntax:
% out = XYZ_to_ciecam02(XYZ,S)
% out = XYZ_to_ciecam02(XYZ,S,isn)
%
%% Example %%
%
% >> RGB = [64,128,255];
% >> XYZ = srgb_to_xyz(RGB/255)*100
% XYZ =
%       27.88352542538389  23.74833281838537  97.72201291885087
% >> wp  = cie_whitepoint('D65');
% >> S   = ciecam02_parameters(wp,20,64/pi/5,'average');
% >> XYZ_to_ciecam02(XYZ,S)
% ans =
%     J: 43.7296106370812
%     Q: 81.7991095162447
%     C: 72.6160673792035
%     M: 52.4958884171155
%     s: 80.1102998021592
%     H: 309.379495827481
%     h: 256.695342260531
%
%% Input And Output Arguments %%
%
%%% Inputs (*==default):
% XYZ = NumericArray, tristimulus values to convert, 1931 XYZ colorspace (Ymax==100).
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
isz = size(XYZ);
assert(isnumeric(XYZ)&&isreal(XYZ),'Input <XYZ> must be a real numeric array.')
assert(isz(end)==3,'Input <XYZ> must have size Nx3 or RxCx3.')
XYZ = double(reshape(XYZ,[],3));
isz(end) = 1;
%
name = 'ciecam02_parameters';
assert(isstruct(S)&&isscalar(S),'Input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'Structure must be that returned by "%s.m".',name)
%
%% Conversion %%
%
%%% Step 1: cone responses:
%
LMS = XYZ * S.M_CAT02.';
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%XYZ_to_ciecam02
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