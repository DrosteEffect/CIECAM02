function out = Jab_to_CIECAM02(jab,S,isd)
% Convert an array of CAM02 values to a structure of CIECAM02 values.
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
%  out = Jab_to_CIECAM02(jab,S)
%  out = Jab_to_CIECAM02(jab,S,isd)
%
%% Example %%
%
% >> Jab = [56.913892296685113,-7.948223793113011,-33.591062955940835];
% >> S = Jab_parameters();
% >> out = Jab_to_CIECAM02(Jab,S)
% out =
%     J:  43.7260
%     M:  52.4934
%     h: 256.6877
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% jab = NumericArray, CAM02 perceptually uniform colorspace values J',a',b'.
%       Size Nx3 or RxCx3, the last dimension encodes the J'a'b' values.
% S   = Scalar structure of parameters from the function JAB_PARAMETERS.
% isd = ScalarLogical, select if the J' values are divided by K_L (only
%       required to calculate deltaE for LCD and SCD colorspaces), *false.
%
%%% Outputs:
% out = Scalar structure of CIECAM02 J, M, and h values. Each field
%       has exactly the same size Nx1 or RxCx1. The fields encode:
%       J = Lightness
%       M = Colorfulness
%       h = Hue Angle
%
% See also JAB_PARAMETERS CIECAM02_TO_JAB SRGB_TO_JAB JAB_TO_SRGB

%% Input Wrangling %%
%
isz = size(jab);
assert(isnumeric(jab),'SC:Jab_to_CIECAM02:NotNumeric',...
	'1st input <jab> must be a numeric array.')
assert(isreal(jab),'SC:Jab_to_CIECAM02:Complex',...
	'1st input <jab> cannot be complex.')
assert(isz(end)==3,'SC:Jab_to_CIECAM02:InvalidSize',...
	'1st input <jab> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
jab = reshape(jab,[],3);
isz(end) = 1;
%
if ~isfloat(jab)
	jab = double(jab);
end
%
name = 'Jab_parameters';
assert(isstruct(S)&&isscalar(S),'SC:Jab_to_CIECAM02:NotScalarStruct_S',...
	'2nd input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'SC:Jab_to_CIECAM02:UnknownStructOrigin_S',...
	'2nd input <S> must be the structure returned by "%s.m".',name)
%
Jp = jab(:,1);
ap = jab(:,2);
bp = jab(:,3);
%
%% Jab2JMh %%
%
if nargin>2&&islogical(isd)&&isd
	Jp = Jp * S.K_L;
end
%
J  = -Jp ./ (S.c1 * Jp - 100*S.c1 -1);
%
h  = myAtan2d(ap,bp);
Mp = hypot(ap,bp);
M  = (exp(S.c2*Mp) - 1) / S.c2;
%
out = struct('J',J,'M',M,'h',h);
out = structfun(@(v)reshape(v,isz), out, 'UniformOutput',false);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Jab_to_CIECAM02
function ang = myAtan2d(X,Y)
ang = mod(180*atan2(Y,X)/pi,360);
ang(Y==0 & X==0) = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%myAtan2d
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
