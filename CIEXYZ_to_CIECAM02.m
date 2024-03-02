function out = CIEXYZ_to_CIECAM02(XYZ,prm,isn)
% Convert an array of CIE 1931 XYZ values to a structure of CIECAM02 values.
%
% (c) 2017-2024 Stephen Cobeldick
%
%%% Syntax:
% out = CIEXYZ_to_CIECAM02(XYZ,prm)
% out = CIEXYZ_to_CIECAM02(XYZ,prm,isn)
%
%% Example %%
%
% >> XYZ = [0.278835239474185759,0.237483316531782285,0.977220072160195796];
% >> wp  = CIE_whitepoint('D65');
% >> prm = CIECAM02_parameters(wp,20,64/pi/5,'average');
% >> out = CIEXYZ_to_CIECAM02(XYZ,prm)
% out =
%     J:  43.730
%     Q:  81.799
%     C:  72.616
%     M:  52.496
%     s:  80.110
%     H: 309.38
%     h: 256.70
%
%% Input And Output Arguments %%
%
%%% Inputs (**==default):
% XYZ = Double/single array of tristimulus values to convert, values 
%       defined by the 1931 XYZ colorspace, scaled such that Ymax==1.
%       Size Nx3 or RxCx3, the last dimension encodes the X,Y,Z values..
% prm = Scalar structure of parameters from CIECAM02_PARAMETERS.
% isn = false/true** -> negative A values are converted to zeros/NaNs.
%
%%% Outputs:
% out = a scalar structure with numeric fields of size Nx1 or RxCx1, with
%       CIECAM02 values (calculated from <XYZ> and the input parameters):
%       J = Lightness
%       Q = Brightness
%       C = Chroma
%       M = Colorfulness
%       s = Saturation
%       H = Hue Composition
%       h = Hue Angle
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
assert(isz(end)==3,...
	'SC:CIEXYZ_to_CIECAM02:XYZ:InvalidSize',...
	'1st input <XYZ> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
XYZ = reshape(XYZ,[],3);
assert(all(XYZ(:,2)>=0&XYZ(:,2)<=1),...
	'SC:CIEXYZ_to_CIECAM02:XYZ:OutOfRangeY',...
	'Input <XYZ> values must be scaled so 0<=Y<=1')
isz(end) = 1;
%
name = 'CIECAM02_parameters';
assert(isstruct(prm)&&isscalar(prm),...
	'SC:CIEXYZ_to_CIECAM02:prm:NotScalarStruct',...
	'2nd input <prm> must be a scalar structure.')
assert(strcmp(prm.name,name),...
	'SC:CIEXYZ_to_CIECAM02:prm:UnknownStructOrigin',...
	'2nd input <prm> must be the structure returned by "%s.m".',name)
%
%% Conversion %%
%
%%% Step 1: cone responses:
%
LMS = (100*XYZ) * prm.M_CAT02.';
%
%%% Step 2: cone responses considering luminance and surround:
%
LMS_C = bsxfun(@times, prm.LMS_c, LMS);
%
%%% Step 3: Hunt-Pointer-Estevez response:
%
LMSp = LMS_C * (prm.M_HPE / prm.M_CAT02).';
%
%%% Step 4: post-adaption cone response:
%
LMSp_signs = sign(LMSp);
tmp = (prm.F_L .* bsxfun(@times,LMSp_signs,LMSp)/100).^0.42;
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
hp = h + 360*(h < prm.h_i(1));
tmp = bsxfun(@le,prm.h_i,hp.');
tmp = flipud(cumsum(flipud(tmp),1))==1;
[idx,~] = find(tmp);
tmp = (hp - prm.h_i(idx)) ./ prm.e_i(idx);
H = prm.H_i(idx) + (100*tmp) ./ (tmp + (prm.h_i(idx+1)-hp) ./ prm.e_i(idx+1));
%
%%% Step 7: achromatic response:
%
A = (LMSp_a*[2;1;1/20] - 0.305) .* prm.N_bb;
A(A<0) = 0 / ~(nargin<3 || isn);
%
%%% Step 8: correlate of lightness:
%
J = 100*(A ./ prm.A_w).^(prm.c.*prm.z); % lightness
%
%%% Step 9: correlate of brightness:
%
Q = (4./prm.c) .* sqrt(J/100) .* (prm.A_w+4) .* sqrt(sqrt(prm.F_L)); % brightness
%
%%% Step 10: correlates of chroma, colorfulness, and saturation:
%
e = (12500/13) .* prm.N_c .* prm.N_cb .* (cos(h_rad+2) + 3.8); % eccentricity
tmp = (e .* sqrt(a.^2 + b.^2) ./ (LMSp_a*[1;1;21/20]));
C = tmp.^0.9 .* sqrt(J/100) .* (1.64 - 0.29.^prm.n).^0.73; % chroma
M = C .* sqrt(sqrt(prm.F_L)); % colorfulness
s = 100*sqrt(M ./ Q); % saturation
%
out = struct('J',J,'Q',Q,'C',C,'M',M,'s',s,'H',H,'h',h);
out = structfun(@(v)reshape(v,isz), out, 'UniformOutput',false);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIEXYZ_to_CIECAM02
%
% Copyright (c) 2017-2024 Stephen Cobeldick
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