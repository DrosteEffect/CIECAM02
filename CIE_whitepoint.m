function xyz = CIE_whitepoint(obs)
% CIE 2 degree observer (1931) and CIE 10 degree observer (1964) illuminants.
%
%%% Syntax:
% xyz = CIE_whitepoint(obs)
%
%% Example %%
%
% >> CIE_whitepoint('D65')
% ans =
%       0.9505   1.0000   1.0888
%
%% Input and Output Arguments %%
%
%%% Input:
% obs = CharRowVector, the name of the illuminant, e.g. 'D65' (the sRGB standard).
%       Optional prefix specifies 2 or 10 degree, e.g. '2D50' or '10D50'.  
%
%%% Output:
% xyz = NumericVector, whitepoint XYZ values [Xw,Yw,Zw], 1931 XYZ colorspace (Ymax==1).
%
% See also CIECAM02_PARAMETERS CIECAM02_TO_XYZ XYZ_TO_CIECAM02 SRGB_TO_JAB JAB_TO_SRGB

assert(ischar(obs),'SC:CIE_whitepoint:NotChar','Input must be character.')
%
switch upper(obs)
	case {'A','2A'}
		xyz = [1.09850,1,0.35585];
	case {'C','2C'}
		xyz = [0.98074,1,1.18232];
	case {'D50','2D50'}
		xyz = [0.96422,1,0.82521];
	case {'D55','2D55'}
		xyz = [0.95682,1,0.92149];
	case {'D65','2D65'} % sRGB standard whitepoint.
		xyz = [0.95047,1,1.08883];
	case {'D75','2D75'}
		xyz = [0.94972,1,1.22638];
	case '10A'
		xyz = [1.11144,1,0.35200];
	case '10C'
		xyz = [0.97285,1,1.16145];
	case '10D50'
		xyz = [0.96720,1,0.81427];
	case '10D55'
		xyz = [0.95799,1,0.90926];
	case '10D65'
		xyz = [0.94811,1,1.07304];
	case '10D75'
		xyz = [0.94416,1,1.20641];
	otherwise
		error('Illuminant "%s" is not supported.',obs)
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CIE_whitepoint
