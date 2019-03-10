function S = ciecam02_parameters(wp,Y_b,L_A,sur)
% Parameter values defined in the CIECAM02 model "Step 0".
%
% (c) 2017-2019 Stephen Cobeldick
%
%%% Syntax:
% S = ciecam02_parameters(wp,Y_b,L_A)
% S = ciecam02_parameters(wp,Y_b,L_A,sur)
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% wp  = NumericVector, whitepoint XYZ values [Xw,Yw,Zw], 1931 XYZ colorspace (Ymax==100).
% Y_b = NumericScalar, relative luminance of reference white in the adapting field.
% L_A = NumericScalar, adapting field luminance (cd/m^2).
% sur = CharRowVector, one of *'average'/'dim'/'dark'.
%     = NumericVector, size 1x3, [F,c,N_c], CIECAM02 surround parameters.
%
%%% Output:
% S = Scalar structure of CIECAM02 parameter values.
%
% See also CIE_WHITEPOINT CIECAM02_TO_XYZ XYZ_TO_CIECAM02 SRGB_TO_JAB JAB_TO_SRGB JAB_PARAMETERS

%% Input Wrangling %%
%
assert(isnumeric(Y_b)&&isscalar(Y_b)&&isreal(Y_b),'Y_b must be a real scalar numeric.')
assert(isnumeric(L_A)&&isscalar(L_A)&&isreal(L_A),'L_A must be a real scalar numeric.')
assert(isnumeric(wp) &&numel(wp)==3 &&isreal(wp),'WhitePoint must be 3 real numeric values.')
%
S.XYZ_w = wp(:).';
%
if nargin<4
	sur = 'average';
end
if isnumeric(sur)
	assert(isreal(sur)&&numel(sur)==3,'Surround input can be a 1x3 numeric vector')
	sur = double(sur);
	S.F = sur(1);  S.c = sur(2);  S.N_c = sur(3);
elseif ischar(sur)&&isrow(sur)
	switch lower(sur)
		case 'average'
			S.F = 1.0; S.c = 0.690; S.N_c = 1.00;
		case 'dim'
			S.F = 0.9; S.c = 0.590; S.N_c = 0.90;
		case 'dark'
			S.F = 0.8; S.c = 0.525; S.N_c = 0.80;
		otherwise
			error('Surround option "%s" is not supported.',sur)
	end
else
	error('Surround must be a char row vector or a numeric vector.')
end
%
%% Matrices %%
%
S.M_CAT02 = [0.7328,0.4296,-0.1624;-0.7036,1.6975,0.0061;0.003,0.0136,0.9834];
S.M_HPE   = [0.38971,0.68898,-0.07868;-0.22981,1.1834,0.04641;0,0,1];
%
S.h_i = [20.14;90.00;164.25;237.53;380.14];
S.e_i = [0.8;0.7;1.0;1.2;0.8];
S.H_i = [0;100;200;300;400];
%
%% Derive Parameters %%
%
S.LMS_w = S.XYZ_w * S.M_CAT02.';
S.D = S.F .* (1-(1/3.6) .* exp(-(L_A+42)/92));
S.D = max(0,min(1,S.D));
%
S.LMS_c = S.D*S.XYZ_w(2) ./ S.LMS_w + 1 - S.D;
S.LMSp_w = (S.LMS_c .* S.LMS_w) * (S.M_HPE / S.M_CAT02).';
% Michaelis-Mentis equation:
S.k = 1 ./ (5*L_A+1);
S.F_L = (S.k.^4 .* (5*L_A))/5 + ((1-S.k^4).^2 .* (5*L_A).^(1/3))/10;
S.n = Y_b ./ S.XYZ_w(2);
S.z = 1.48 + sqrt(S.n);
S.N_bb = 0.725 * S.n.^(-1/5);
S.N_cb = S.N_bb;
%
tmp = ((S.F_L .* S.LMSp_w)/100).^0.42;
S.LMSp_aw = 400*(tmp ./ (27.13 + tmp)) + 0.1;
S.A_w = (S.LMSp_aw * [2;1;1/20] - 0.305) * S.N_bb;
%
S.name = mfilename();
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ciecam02_parameters
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