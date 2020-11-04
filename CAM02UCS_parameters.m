function prm = CAM02UCS_parameters(K_L,c1,c2)
% Parameter values to define the CAM02 colorspace (UCS/LCD/SCD/etc.).
%
% (c) 2017-2020 Stephen Cobeldick
%
%%% Syntax:
% prm = CAM02UCS_parameters()
% prm = CAM02UCS_parameters(space)
% prm = CAM02UCS_parameters(K_L,c1,c2)
%
%% Input and Output Arguments %%
%
%%% Inputs (*==default):
% space = CharRowVector, *'UCS'/'LCD'/'SCD' selects a standard CAM02 space:
%         UniformColorSpace / LargeColorDifference / SmallColorDifference.
%%% OR:
% K_L = NumericScalar, CAM02 coefficient (lightness parameter).
% c1  = NumericScalar, CAM02 coefficient (space constant).
% c2  = NumericScalar, CAM02 coefficient (space constant).
%
%%% Output:
% prm = Scalar structure of CAM02 colorspace parameter values.
%
% See also CIECAM02_PARAMETERS
% CIECAM02_TO_CAM02UCS CAM02UCS_TO_CIECAM02 SRGB_TO_CAM02UCS CAM02UCS_TO_SRGB

%% Input Wrangling %%
%
switch nargin
	case 0
		K_L = 'UCS';
	case 1
		assert(ischar(K_L),...
			'SC:CAM02UCS_parameters:NotCharVector',...
			'If using only one input it must be a 1xN character.')
	case 3
		prm.K_L = K_L; prm.c1 = c1; prm.c2 = c2;
		K_L = '';
	otherwise
		error('SC:CAM02UCS_parameters:InvalidInputs',...
			'Either one 1xN character, or three numeric inputs are required.')
end
%
switch upper(K_L)
	case ''
		assert(all(structfun(@(x)isnumeric(x)&&isscalar(x)&&isreal(x),prm)),...
			'SC:CAM02UCS_parameters:NotNumericScalars',...
			'All numeric inputs must be real numeric scalars.')
	case 'UCS'
		prm.K_L = 1.00; prm.c1 = 0.007; prm.c2 = 0.0228;
	case 'LCD'
		prm.K_L = 0.77; prm.c1 = 0.007; prm.c2 = 0.0053;
	case 'SCD'
		prm.K_L = 1.24; prm.c1 = 0.007; prm.c2 = 0.0363;
	otherwise
		error('SC:CAM02UCS_parameters:UnknownColorspace',...
			'The requested colorspace "%s" is not supported.',spc)
end
%
prm.name = mfilename();
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAM02UCS_parameters
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
