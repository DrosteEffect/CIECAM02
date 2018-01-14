function S = Jab_parameters(KL,c1,c2)
% Parameter values defined in the CAM02 Color Space (UCS/LCD/SCD).
%
% (c) 2017 Stephen Cobeldick
%
%%% Syntax:
% S = Jab_parameters()
% S = Jab_parameters(space)
% S = Jab_parameters(KL,c1,c2)
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% space = CharRowVector, *'UCS'/'LCD'/'SCD' selects a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
% KL = NumericScalar, CAM02 coefficient (lightness parameter).
% c1 = NumericScalar, CAM02 coefficient (space constant).
% c2 = NumericScalar, CAM02 coefficient (space constant).
%
%%% Output:
% S = Scalar structure of CIECAM UCS parameter values.
%
% S = Jab_parameters(KL,c1,c2)

switch nargin
	case 0
		KL = 'UCS';
	case 1
		assert(ischar(KL)&&isrow(KL),'Input can be a 1xN character.')
	case 3
		S.KL = KL; S.c1 = c1; S.c2 = c2;
		KL = '';
	otherwise
		error('Either one 1xN character, or three numeric inputs required.')
end
switch upper(KL)
	case ''
		idx = structfun(@(x)isnumeric(x)&&isscalar(x)&&isreal(x),S);
		assert(all(idx),'All numeric inputs must be real numeric scalars.')
	case 'UCS'
		S.KL = 1.00; S.c1 = 0.007; S.c2 = 0.0228;
	case 'LCD'
		S.KL = 0.77; S.c1 = 0.007; S.c2 = 0.0053;
	case 'SCD'
		S.KL = 1.24; S.c1 = 0.007; S.c2 = 0.0363;
	otherwise
		error('Colorspace choice "%s" is not supported.',spc)
end
%
S.name = mfilename();
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Jab_parameters
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