function Jab = JMh_2_Jab(JMh,S)
% Convert from CIECAM02 JMh values to the perceptually uniform J'a'b' colorspace (UCS).
%
% (c) 2017 Stephen Cobeldick
%
%%% Syntax:
%  Jab = JMh_2_Jab(JMh,S)
%
%% Input and Output Arguments %%
%
%%% Inputs:
% JMh = NumericArray, with CIECAM02 lightness, colorfulness, and hue angle values.
%       Size Nx3 or RxCx3, the last dimension encodes the J,M,h values.
% S   = Scalar structure of parameters from the function JAB_PARAMETERS.
%
%%% Outputs:
% Jab = NumericArray of CAM02 J'a'b' colorspace values.
%       The same size as <JMh>, the last dimension encodes the J',a',b' values.
%
% Jab = JMh_2_Jab(JMh,S)

%% Input Wrangling %%
%
isz = size(JMh);
assert(isnumeric(JMh)&&isreal(JMh)&&isz(end)==3,'Input <Jab> must be an Nx3 or RxCx3 numeric array.')
JMh = double(reshape(JMh,[],3));
%
name = 'Jab_parameters';
assert(isstruct(S)&&isscalar(S),'Input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'Structure must be that returned by "%s.m".',name)
%
J = JMh(:,1);
M = JMh(:,2);
h = JMh(:,3);
%
%% JMh2Jab %%
%
Jp = (1 + 100*S.c1) .* J ./ (1 + S.c1*J);
Jp = Jp / S.KL;
Mp = (1 / S.c2) * log(1 + S.c2 * M);
%
ap = Mp .* cosd(h);
bp = Mp .* sind(h);
%
Jab = reshape([Jp,ap,bp],isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%JMh_2_Jab
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