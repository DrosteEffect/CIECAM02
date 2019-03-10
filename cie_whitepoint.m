function xyz = cie_whitepoint(obs)
% CIE 2 degree observer (1931) and CIE 10 degree observer (1964) illuminants.
%
%%% Syntax:
% xyz = cie_whitepoint(obs)
%
%% Example %%
%
% >> cie_whitepoint('D65')
% ans =
%       95.047   100.000   108.883
%
%% Input and Output Arguments %%
%
%%% Input:
% obs = CharRowVector, the name of the illuminant, e.g. 'D65' (the sRGB standard).
%       Optional prefix specifies 2 or 10 degree, e.g. '2D50' or '10D50'.  
%
%%% Output:
% XYZ = NumericVector, whitepoint XYZ values [Xw,Yw,Zw], 1931 XYZ colorspace (Ymax==100).
%
% See also CIECAM02_PARAMETERS CIECAM02_TO_XYZ XYZ_TO_CIECAM02 SRGB_TO_JAB JAB_TO_SRGB

switch upper(obs)
	case {'A','2A'}
		xyz = [109.850,100,035.585];
	case {'C','2C'}
		xyz = [098.074,100,118.232];
	case {'D50','2D50'}
		xyz = [096.422,100,082.521];
	case {'D55','2D55'}
		xyz = [095.682,100,092.149];
	case {'D65','2D65'} % sRGB standard whitepoint.
		xyz = [095.047,100,108.883];
	case {'D75','2D75'}
		xyz = [094.972,100,122.638];
	case '10A'
		xyz = [111.144,100,035.200];
	case '10C'
		xyz = [097.285,100,116.145];
	case '10D50'
		xyz = [096.720,100,081.427];
	case '10D55'
		xyz = [095.799,100,090.926];
	case '10D65'
		xyz = [094.811,100,107.304];
	case '10D75'
		xyz = [094.416,100,120.641];
	otherwise
		error('Illuminant "%s" is not supported.',obs)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cie_whitepoint