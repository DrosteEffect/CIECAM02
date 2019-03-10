function Jab = ciecam02_to_Jab(inp,S,isd)
% Convert from CIECAM02 JMh values to the perceptually uniform CAM02 colorspace J'a'b'.
%
% (c) 2017-2019 Stephen Cobeldick
%
%%% Syntax:
%  Jab = ciecam02_to_Jab(inp,S)
%  Jab = ciecam02_to_Jab(inp,S,isd)
%
%% Example %%
%
% >> inp.J = 43.7296106370812;
% >> inp.M = 52.4958884171155;
% >> inp.h = 256.695342260531;
% >> S = Jab_parameters();
% >> Jab = ciecam02_to_Jab(inp,S)
% Jab =
%       56.91748261167756  -7.943988550631903  -33.59323817506418
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% inp = Scalar structure of CIECAM02 J, M, and h values. Each field must
%       have exactly the same size Nx1 or RxCx1. The fields encode:
%       J = Lightness
%       M = Colorfulness
%       h = Hue Angle
% S   = Scalar structure of parameters from the function JAB_PARAMETERS.
% isd = ScalarLogical, select if the J' values are divided by K_L (only
%       required to calculate deltaE for LCD and SCD colorspaces), *false.
%
%%% Outputs:
% Jab = NumericArray of CAM02 colorspace values J'a'b'.
%       Size Nx3 or RxCx3, the last dimension encodes the J'a'b' values.
%
% See also JAB_PARAMETERS JAB_TO_CIECAM02 SRGB_TO_JAB JAB_TO_SRGB

%% Input Wrangling %%
%
assert(isstruct(inp)&&isscalar(inp),'Input <inp> must be a scalar structure.')
fld = fieldnames(inp);
tmp = numel(fld);
fld = [fld{:}];
assert((tmp>=3)&&(tmp<=7),'Input <inp> must have three fields.')
tmp = structfun(@(a)isnumeric(a)&&isreal(a),inp);
assert(all(tmp),'Input <inp> fields must be real numeric arrays.')
tmp = structfun(@(a){size(a)},inp);
assert(isequal(tmp{:}),'Input <inp> fields must be arrays of the same size.')
isz = tmp{1};
isz(max(2,find([isz==1,true],1,'first'))) = 3;
%
name = 'Jab_parameters';
assert(isstruct(S)&&isscalar(S),'Input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'Structure must be that returned by "%s.m".',name)
%
J = double(inp.J(:));
M = double(inp.M(:));
h = double(inp.h(:));
%
%% JMh2Jab %%
%
Jp = (1 + 100*S.c1) .* J ./ (1 + S.c1*J);
%
if nargin>2&&islogical(isd)&&isd
	Jp = Jp / S.K_L;
end
%
Mp = (1 / S.c2) * log(1 + S.c2 * M);
%
ap = Mp .* cosd(h);
bp = Mp .* sind(h);
%
Jab = reshape([Jp,ap,bp],isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ciecam02_to_Jab
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