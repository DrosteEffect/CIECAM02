function XYZ = CIE_whitepoint(obs)
% CIE 2 degree observer (1931) and CIE 10 degree observer (1964) illuminants.
%
%%% Syntax %%%
%
%   XYZ = CIE_whitepoint(obs)
%
%% Example %%
%
%   >> CIE_whitepoint('D65')
%   ans =
%        0.95047    1.00000    1.08883
%
%% Input Arguments %%
%
%   obs = StringScalar or CharRowVector name of the illuminant, e.g. 'D65'.
%         Optional prefix specifies 2 or 10 degree, e.g. '2D50' or '10D50'.
%       = Double/Single 1x3 vector of X Y Z values, scaled so Y==1.
%
%% Output Arguments %%
%
%   XYZ = NumericVector, whitepoint XYZ values [Xw,Yw,Zw], 1931 XYZ colorspace (Ymax==1).
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
%
% See also CIECAM02_PARAMETERS CAM02UCS_PARAMETERS
% CIEXYZ_TO_CIECAM02 CIECAM02_TO_CIEXYZ SRGB_TO_CAM02UCS CAM02UCS_TO_SRGB
if isnumeric(obs)
	assert(isfloat(obs)&&isreal(obs),...
		'SC:CIE_whitepoint:wpt:NotRealFloat',...
		'1st input <wpt> must be a real floating-point array.')
	assert(numel(obs)==3,...
		'SC:CIE_whitepoint:wpt:InvalidSize',...
		'1st input <wpt> must be an [X,Y,Z] whitepoint.')
	assert(obs(2)==1,...
		'SC:CIE_whitepoint:wpt:OutOfRange_Y',...
		'1st input <wpt> Y value must be exactly one.')
	XYZ = reshape(obs,1,[]);
	return
end
%
switch upper(obs)
	case 'ICC'
		XYZ = [31595,32768,27030]/32768;
	case {'A','2A'}
		XYZ = [1.09850,1,0.35585];
	case {'C','2C'}
		XYZ = [0.98074,1,1.18232];
	case {'D50','2D50'}
		XYZ = [0.96422,1,0.82521];
	case {'D55','2D55'}
		XYZ = [0.95682,1,0.92149];
	case {'D65','2D65'} % sRGB standard whitepoint.
		XYZ = [0.95047,1,1.08883];
	case {'D75','2D75'}
		XYZ = [0.94972,1,1.22638];
	case '10A'
		XYZ = [1.11144,1,0.35200];
	case '10C'
		XYZ = [0.97285,1,1.16145];
	case '10D50'
		XYZ = [0.96720,1,0.81427];
	case '10D55'
		XYZ = [0.95799,1,0.90926];
	case '10D65'
		XYZ = [0.94811,1,1.07304];
	case '10D75'
		XYZ = [0.94416,1,1.20641];
	otherwise
		error('SC:CIE_whitepoint:obs:UnknownIlluminant',...
			'The requested illuminant "%s" is not supported.',obs)
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIE_whitepoint