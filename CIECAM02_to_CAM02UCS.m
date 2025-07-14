function Jab = CIECAM02_to_CAM02UCS(inp,prm,isd)
% Convert a structure of CIECAM02 values to an array of CAM02 colorspace values.
%
%%% Syntax %%%
%
%   Jab = CIECAM02_to_CAM02UCS(inp,prm)
%   Jab = CIECAM02_to_CAM02UCS(inp,prm,isd)
%
% If the output is being used for calculating the euclidean color distance
% (i.e. deltaE) then specify isd=true, so that J' values are divided by K_L.
%
%% Example %%
%
%   >> inp.J = 43.7296094671109756;
%   >> inp.M = 52.4958873764575245;
%   >> inp.h = 256.695342232470466;
%   >> prm = CAM02UCS_parameters();
%   >> Jab = CIECAM02_to_CAM02UCS(inp,prm)
%   Jab =
%      56.917   -7.9440  -33.593
%
%% Input Arguments (**==default) %%
%
%   inp = Scalar structure of CIECAM02 J, M, and h values. Each field must
%         have exactly the same size Nx1 or RxCx1. The fields must be all
%         double or all single. The fields encode:
%         J = Lightness
%         M = Colorfulness
%         h = Hue Angle
%   prm = ScalarStructure of parameters from the function CAM02UCS_PARAMETERS.
%   isd = ScalarLogical, true/false** = euclidean distance/reference J' values.
%
%% Output Arguments %%
%
%   Jab = NumericArray of CAM02 colorspace values J'a'b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J'a'b' values.
%
%% Dependencies %%
%
% CAM02UCS_parameters.m <https://github.com/DrosteEffect/CIECAM02>
%
% See also CAM02UCS_TO_CIECAM02 CAM02UCS_PARAMETERS
% CIECAM02_TO_CIEXYZ CAM02UCS_TO_SRGB

%% Input Wrangling %%
%
assert(isstruct(inp)&&isscalar(inp),...
	'SC:CIECAM02_to_CAM02UCS:inp:NotScalarStruct',...
	'1st input <inp> must be a scalar structure.')
assert(all(structfun(@isfloat,inp)),...
	'SC:CIECAM02_to_CAM02UCS:inp:FieldsAreNotFloat',...
	'1st input <inp> fields must be floating point arrays.')
assert(all(structfun(@isreal,inp)),...
	'SC:CIECAM02_to_CAM02UCS:inp:FieldsAreNotReal',...
	'1st input <inp> fields must be real arrays (not complex).')
tmp = structfun(@(a){class(a)},inp);
assert(isequal(tmp{:}),...
	'SC:CIECAM02_to_CIEXYZ:inp:FieldsAreNotSameClass',...
	'1st input <inp> fields must be arrays of the same class.')
tmp = structfun(@(a){size(a)},inp);
assert(isequal(tmp{:}),...
	'SC:CIECAM02_to_CAM02UCS:inp:FieldsAreNotSameSize',...
	'1st input <inp> fields must be arrays of the same size.')
isz = tmp{1};
isz(max(2,find([isz==1,true],1,'first'))) = 3;
%
assert(isfield(inp,'J'),'SC:CIECAM02_to_CAM02UCS:inp:MissingField_J',...
	'Input <inp> must contain the field "J".')
assert(isfield(inp,'M'),'SC:CIECAM02_to_CAM02UCS:inp:MissingField_M',...
	'Input <inp> must contain the field "M".')
assert(isfield(inp,'h'),'SC:CIECAM02_to_CAM02UCS:inp:MissingField_h',...
	'Input <inp> must contain the field "h".')
%
J = inp.J(:);
M = inp.M(:);
h = inp.h(:);
%
name = 'CAM02UCS_parameters';
assert(isstruct(prm)&&isscalar(prm),...
	'SC:CIECAM02_to_CAM02UCS:prm:NotScalarStruct',...
	'2nd input <prm> must be a scalar structure.')
assert(strcmp(prm.name,name),...
	'SC:CIECAM02_to_CAM02UCS:prm:UnknownStructOrigin',...
	'2nd input <prm> must be the structure returned by "%s.m".',name)
%
%% JMh2Jab %%
%
Jp = (1 + 100*prm.c1) .* J ./ (1 + prm.c1*J);
%
if nargin>2&&isd
	Jp = Jp / prm.K_L;
end
%
Mp = (1 / prm.c2) * log(1 + prm.c2 * M);
%
ap = Mp .* cosd(h);
bp = Mp .* sind(h);
%
Jab = reshape([Jp,ap,bp],isz);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIECAM02_to_CAM02UCS
%
% Copyright (c) 2017-2025 Stephen Cobeldick
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