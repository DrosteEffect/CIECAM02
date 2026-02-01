function prm = CAM02UCS_parameters(K_L,c1,c2)
% Parameter values to define the CAM02 colorspace (UCS/LCD/SCD/etc.).
%
%%% Syntax %%%
%
%   prm = CAM02UCS_parameters()
%   prm = CAM02UCS_parameters(space)
%   prm = CAM02UCS_parameters(K_L,c1,c2)
%
%% Input Arguments (**==default) %%
%
%   space = StringScalar or CharRowVector, one of the following:
%           'LCD'/'SCD'/'UCS'**, which selects a predefined CAM02 space
%           LargeColorDifference / SmallColorDifference / UniformColorSpace.
%   K_L = NumericScalar, CAM02 coefficient (lightness parameter).
%   c1  = NumericScalar, CAM02 coefficient (space constant).
%   c2  = NumericScalar, CAM02 coefficient (space constant).
%
%% Output Arguments %%
%
%   prm = ScalarStructure of CAM02 colorspace parameter values.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
%
% See also CIECAM02_PARAMETERS
% CIECAM02_TO_CAM02UCS CAM02UCS_TO_CIECAM02 SRGB_TO_CAM02UCS CAM02UCS_TO_SRGB

%% Input Wrangling %%
%
fnh = @(x)isnumeric(x)&&isscalar(x)&&isreal(x);
%
switch nargin
	case 0
		prm = GetParam('UCS'); % default
	case 1
		prm = GetParam(K_L);
	case 3
		prm.K_L = K_L;
		prm.c1  = c1;
		prm.c2  = c2;
		assert(all(structfun(fnh,prm)),...
			'SC:CAM02UCS_parameters:NotNumericScalars',...
			'All numeric inputs must be real numeric scalars.')
		prm = structfun(@double,prm, 'UniformOutput',false);
		prm.suffix = 'custom';
	otherwise
		error('SC:CAM02UCS_parameters:InvalidInputs',...
			'Three numeric inputs or one text input is required.')
end
%
prm.mfname = mfilename();
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAM02UCS_parameters
function prm = GetParam(K_L)
switch upper(K_L)
	case 'UCS'
		prm.K_L=1.00; prm.c1=0.007; prm.c2=0.0228; prm.suffix='UCS';
	case 'LCD'
		prm.K_L=0.77; prm.c1=0.007; prm.c2=0.0053; prm.suffix='LCD';
	case 'SCD'
		prm.K_L=1.24; prm.c1=0.007; prm.c2=0.0363; prm.suffix='SCD';
	otherwise
		error('SC:CAM02UCS_parameters:UnknownColorspace',...
			'The requested colorspace "%s" is not supported.',K_L)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%GetParam
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license