function prm = CIECAM02_parameters(wp,Y_b,L_A,sur)
% Parameter values defined in the CIECAM02 model "Step 0".
%
% (c) 2017-2024 Stephen Cobeldick
%
%%% Syntax:
% prm = CIECAM02_parameters(wp,Y_b,L_A)
% prm = CIECAM02_parameters(wp,Y_b,L_A,sur)
%
%% Input and Output Arguments %%
%
%%% Inputs (**==default):
% wp  = NumericVector, whitepoint XYZ values [Xw,Yw,Zw], 1931 XYZ colorspace (Ymax==1).
% Y_b = NumericScalar, relative luminance of reference white in the adapting field.
% L_A = NumericScalar, adapting field luminance (cd/m^2).
% sur = CharRowVector, one of 'dim'/'dark'/'average'**.
%     = NumericVector, size 1x3, [F,c,N_c], CIECAM02 surround parameters.
%
%%% Output:
% prm = Scalar structure of CIECAM02 parameter values.
%
% See also CAM02UCS_PARAMETERS
% CIEXYZ_TO_CIECAM02 CIECAM02_TO_CIEXYZ SRGB_TO_CAM02UCS CAM02UCS_TO_SRGB

%% Input Wrangling %%
%
assert(isnumeric(L_A)&&isscalar(L_A)&&isreal(L_A),...
	'SC:CIECAM02_parameters:L_a:NotScalarNumeric',...
	'3rd input <L_a> must be a real scalar numeric.')
assert(isnumeric(Y_b)&&isscalar(Y_b)&&isreal(Y_b),...
	'SC:CIECAM02_parameters:Y_b:NotScalarNumeric',...
	'2nd input <Y_b> must be a real scalar numeric.')
assert(isnumeric(wp)&&numel(wp)==3&&isreal(wp),...
	'SC:CIECAM02_parameters:wp:NotThreeNumeric',...
	'1st input <wp> must be 3 real values in a numeric vector.')
assert(wp(2)>=0&wp(2)<=1,...
	'SC:CIECAM02_parameters:wp:OutOfRange',...
	'1st input <wp> must define the whitepoint scaled for Ymax==1')
%
prm.XYZ_w = 100*double(reshape(wp,1,[]));
%
Y_b = double(Y_b);
L_A = double(L_A);
%
if nargin<4
	sur = 'average';
end
if isnumeric(sur)
	assert(isreal(sur)&&numel(sur)==3,...
		'SC:CIECAM02_parameters:sur:NotThreeNumeric',...
		'4th input <sur> can be a 1x3 numeric vector')
	sur = double(sur);
	prm.F   = sur(1);
	prm.c   = sur(2);
	prm.N_c = sur(3);
else
	switch upper(sur)
		case 'AVERAGE'
			prm.F = 1.0;   prm.c = 0.690;   prm.N_c = 1.00;
		case 'DIM'
			prm.F = 0.9;   prm.c = 0.590;   prm.N_c = 0.90;
		case 'DARK'
			prm.F = 0.8;   prm.c = 0.525;   prm.N_c = 0.80;
		otherwise
			error('SC:CIECAM02_parameters:sur:UnknownValue',...
				'4th input <sur> value "%s" is not supported.',sur)
	end
end
%
%% Matrices %%
%
prm.M_CAT02 = [...
	+0.7328,+0.4296,-0.1624;...
	-0.7036,+1.6975,+0.0061;...
	+0.0030,+0.0136,+0.9834];
prm.M_HPE = [...
	+0.38971,+0.68898,-0.07868;...
	-0.22981,+1.18340,+0.04641;...
	+0      ,+0      ,+1      ];
%
prm.h_i = [20.14;90.00;164.25;237.53;380.14];
prm.e_i = [0.8;0.7;1.0;1.2;0.8];
prm.H_i = [0;100;200;300;400];
%
%% Derive Parameters %%
%
prm.LMS_w = prm.XYZ_w * prm.M_CAT02.';
prm.D = prm.F .* (1-(1/3.6) .* exp(-(L_A+42)/92));
prm.D = max(0,min(1,prm.D));
%
prm.LMS_c = prm.D*prm.XYZ_w(2) ./ prm.LMS_w + 1 - prm.D;
prm.LMSp_w = (prm.LMS_c .* prm.LMS_w) * (prm.M_HPE / prm.M_CAT02).';
% Michaelis-Mentis equation:
prm.k = 1 ./ (5*L_A+1);
prm.F_L = (prm.k.^4 .* (5*L_A))/5 + ((1-prm.k^4).^2 .* (5*L_A).^(1/3))/10;
prm.n = Y_b ./ prm.XYZ_w(2);
prm.z = 1.48 + sqrt(prm.n);
prm.N_bb = 0.725 * prm.n.^(-1/5);
prm.N_cb = prm.N_bb;
%
tmp = ((prm.F_L .* prm.LMSp_w)/100).^0.42;
prm.LMSp_aw = 400*(tmp ./ (27.13 + tmp)) + 0.1;
prm.A_w = (prm.LMSp_aw * [2;1;1/20] - 0.305) * prm.N_bb;
%
prm.name = mfilename();
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIECAM02_parameters
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