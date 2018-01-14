function JMh = Jab_2_JMh(Jab,S)
% Convert from the perceptually uniform J'a'b' colorspace (UCS) to CIECAM02 JMh values.
%
% (c) 2017 Stephen Cobeldick
%
%%% Syntax:
%  JMh = Jab_2_JMh(Jab,S)
%
%% Input and Output Arguments %%
%
%%% Inputs:
% Jab = NumericArray, perceptually uniform colorspace values J',a',b'.
%       Size Nx3 or RxCx3, the last dimension encodes the J'a'b' values.
% S   = Scalar structure of parameters from the function JAB_PARAMETERS.
%
%%% Outputs:
% JMh = NumericArray of CIECAM02 lightness, colorfulness, and hue angle values.
%       The same size as <Jab>, the last dimension encodes the J,M,h values.
%
% JMh = Jab_2_JMh(Jab,S)

%% Input Wrangling %%
%
isz = size(Jab);
assert(isnumeric(Jab)&&isreal(Jab)&&isz(end)==3,'Input <Jab> must be an Nx3 or RxCx3 numeric array.')
Jab = double(reshape(Jab,[],3));
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
Jp = Jp * S.KL;
J  = -Jp ./ (S.c1 * Jp - 100*S.c1 -1);
%
h  = locAtan2d(ap,bp);
Mp = hypot(ap,bp);
M  = (exp(S.c2*Mp) - 1) / S.c2;
%
JMh = reshape([J,M,h],isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Jab_2_JMh
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