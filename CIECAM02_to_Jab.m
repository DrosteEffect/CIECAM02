function Jab = CIECAM02_to_Jab(inp,S,isd)
% Convert a structure of CIECAM02 values to an array of CAM02 values.
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
%  Jab = CIECAM02_to_Jab(inp,S)
%  Jab = CIECAM02_to_Jab(inp,S,isd)
%
%% Example %%
%
% >> inp.J = 43.726007896909451;
% >> inp.M = 52.493379855966843;
% >> inp.h = 256.68767017409704;
% >> S = Jab_parameters();
% >> Jab = CIECAM02_to_Jab(inp,S)
% Jab =
%    56.9139   -7.9482  -33.5911
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
% See also JAB_PARAMETERS JAB_TO_CIECAM02 CIECAM02_TO_XYZ SRGB_TO_JAB JAB_TO_SRGB

%% Input Wrangling %%
%
assert(isstruct(inp)&&isscalar(inp),'SC:CIECAM02_to_Jab:NotScalarStruct_inp',...
	'1st input <inp> must be a scalar structure.')
fld = fieldnames(inp);
tmp = numel(fld);
fld = [fld{:}]; %#ok<NASGU>
assert((tmp>=3)&&(tmp<=7),'SC:CIECAM02_to_Jab:MustHaveThreeFields_inp',...
	'1st input <inp> must have at least three fields (J, M, h).')
tmp = structfun(@(a)isnumeric(a)&&isreal(a),inp);
assert(all(tmp),'SC:CIECAM02_to_Jab:FieldsMustBeNumeric_inp',...
	'1st input <inp> fields must be real numeric arrays.')
tmp = structfun(@(a){size(a)},inp);
assert(isequal(tmp{:}),'SC:CIECAM02_to_Jab:FieldsMustBeSameSize_inp',...
	'1st input <inp> fields must be arrays of the same size.')
isz = tmp{1};
isz(max(2,find([isz==1,true],1,'first'))) = 3;
%
name = 'Jab_parameters';
assert(isstruct(S)&&isscalar(S),'SC:CIECAM02_to_Jab:NotScalarStruct_S',...
	'2nd input <S> must be a scalar structure.')
assert(strcmp(S.name,name),'SC:CIECAM02_to_Jab:UnknownStructOrigin_S',...
	'2nd input <S> must be the structure returned by "%s.m".',name)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIECAM02_to_Jab
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
