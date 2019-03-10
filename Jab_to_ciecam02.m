function out = Jab_to_ciecam02(Jab,S,isd)
% Convert from the perceptually uniform CAM02 colorspace J'a'b' to CIECAM02 JMh values.
%
% (c) 2017-2019 Stephen Cobeldick
%
%%% Syntax:
%  out = Jab_to_ciecam02(Jab,S)
%  out = Jab_to_ciecam02(Jab,S,isd)
%
%% Example %%
%
% >> Jab = [56.91748261167756,-7.943988550631903,-33.59323817506418];
% >> S = Jab_parameters();
% >> out = Jab_to_ciecam02(Jab,S)
% out =
%    J: 43.72961063708121
%    M: 52.49588841711551
%    h: 256.6953422605310
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% Jab = NumericArray, CAM02 perceptually uniform colorspace values J',a',b'.
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
isz = size(Jab);
assert(isnumeric(Jab)&&isreal(Jab)&&isz(end)==3,'Input <Jab> must be an Nx3 or RxCx3 numeric array.')
Jab = double(reshape(Jab,[],3));
isz(end) = 1;
%
name = 'Jab_parameters';
assert(isstruct(S)&&isscalar(S),'Input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'Structure must be that returned by "%s.m".',name)
%
Jp = Jab(:,1);
ap = Jab(:,2);
bp = Jab(:,3);
%
%% Jab2JMh %%
%
if nargin>2&&islogical(isd)&&isd
	Jp = Jp * S.K_L;
end
%
J  = -Jp ./ (S.c1 * Jp - 100*S.c1 -1);
%
h  = locAtan2d(ap,bp);
Mp = hypot(ap,bp);
M  = (exp(S.c2*Mp) - 1) / S.c2;
%
out = struct('J',J,'M',M,'h',h);
out = structfun(@(v)reshape(v,isz), out, 'UniformOutput',false);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Jab_to_ciecam02
function ang = locAtan2d(X,Y)
ang = mod(180*atan2(Y,X)/pi,360);
ang(Y==0 & X==0) = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%locAtan2d
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