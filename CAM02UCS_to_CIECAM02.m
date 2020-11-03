function out = CAM02UCS_to_CIECAM02(Jab,prm,isd)
% Convert an array of CAM02 colorspace values to a structure of CIECAM02 values.
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
%  out = CAM02UCS_to_CIECAM02(Jab,prm)
%  out = CAM02UCS_to_CIECAM02(Jab,prm,isd)
%
% If the input was being used for calculating the euclidean color distance
% (i.e. deltaE) use isd=true, so that J' values are multiplied by K_L.
%
%% Example %%
%
% >> Jab = [56.913892296685113,-7.948223793113011,-33.591062955940835];
% >> prm = CAM02UCS_parameters();
% >> out = CAM02UCS_to_CIECAM02(Jab,prm)
% out =
%     J:  43.7260
%     M:  52.4934
%     h: 256.6877
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% Jab = NumericArray, CAM02 perceptually uniform colorspace values J',a',b'.
%       Size Nx3 or RxCx3, the last dimension encodes the J'a'b' values.
% prm = ScalarStructure of parameters from the function CAM02UCS_PARAMETERS.
% isd = ScalarLogical, true/false* = euclidean distance/reference J' values.
%
%%% Outputs:
% out = ScalarStructure of CIECAM02 J, M, and h values. Each field
%       has exactly the same size Nx1 or RxCx1. The fields encode:
%       J = Lightness
%       M = Colorfulness
%       h = Hue Angle
%
% See also CIECAM02_TO_CAM02UCS CAM02UCS_PARAMETERS
% CAM02UCS_TO_SRGB SRGB_TO_CAM02UCS CIECAM02_TO_CIEXYZ

%% Input Wrangling %%
%
isz = size(Jab);
assert(isnumeric(Jab),...
	'SC:CAM02UCS_to_CIECAM02:Jab:NotNumeric',...
	'1st input <Jab> must be a numeric array.')
assert(isreal(Jab),...
	'SC:CAM02UCS_to_CIECAM02:Jab:ComplexValue',...
	'1st input <Jab> cannot be complex.')
assert(isz(end)==3,...
	'SC:CAM02UCS_to_CIECAM02:Jab:InvalidSize',...
	'1st input <Jab> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
Jab = reshape(Jab,[],3);
isz(end) = 1;
%
if ~isfloat(Jab)
	Jab = double(Jab);
end
%
name = 'CAM02UCS_parameters';
assert(isstruct(prm)&&isscalar(prm),...
	'SC:CAM02UCS_to_CIECAM02:prm:NotScalarStruct',...
	'2nd input <prm> must be a scalar structure.')
assert(strcmp(prm.name,name),...
	'SC:CAM02UCS_to_CIECAM02:prm:UnknownStructOrigin',...
	'2nd input <prm> must be the structure returned by "%s.m".',name)
%
Jp = Jab(:,1);
ap = Jab(:,2);
bp = Jab(:,3);
%
%% Jab2JMh %%
%
if nargin>2&&isd
	Jp = Jp * prm.K_L;
end
%
J  = -Jp ./ (prm.c1 * Jp - 100*prm.c1 -1);
%
h  = myAtan2d(ap,bp);
Mp = hypot(ap,bp);
M  = (exp(prm.c2*Mp) - 1) / prm.c2;
%
out = struct('J',J,'M',M,'h',h);
out = structfun(@(v)reshape(v,isz), out, 'UniformOutput',false);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAM02UCS_to_CIECAM02
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
