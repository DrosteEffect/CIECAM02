function M = get_sRGB_matrix(M)
% Return a linear sRGB-to-CIEXYZ conversion matrix.
%
% Named sRGB/CIEXYZ matrices and user-supplied RGB-to-CIEXYZ matrices.
% The returned matrix converts linear-light sRGB values to CIEXYZ values
% using the Ymax==1 convention. Reverse conversions should derive the
% inverse transformation from this matrix e.g. using MRDIVIDE, rather than
% using separately rounded inverse matrix values.
%
%%% Syntax %%%
%
% M = get_sRGB_matrix()
% M = get_sRGB_matrix(name)
% M = get_sRGB_matrix(M)
%
%% Input Arguments (**=default) %%
%
% name = StringScalar/CharVector specifying one of the supported matrices:
%      = 'BT709'** or 'D65HP' or 'sRGB', high precision matrix derived
%        from ITU-R BT.709/sRGB primaries and D65 whitepoint,
%      = 'D65' or '2D65', rounded matrix whose row sums match the common
%        CIE D65 whitepoint [0.95047,1,1.08883],
%      = 'IEC61966', rounded IEC 61966-2-1:1999 matrix,
%      = 'Lindbloom', Bruce Lindbloom sRGB/XYZ matrix,
%      = 'RIT' or 'NCS', RIT/NCS sRGB/XYZ matrix.
%    M = Double/single 3x3 RGB-to-CIEXYZ matrix, where the rows encode
%        X Y Z and the columns encode linear-light R G B contributions.
%
%% Output Arguments %%
%
% M = Double/single 3x3 RGB-to-CIEXYZ matrix using the Ymax==1 convention.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
%
% See also SRGB_TO_CIEXYZ CIEXYZ_TO_SRGB

if nargin<1
	M = 'BT709';
elseif isnumeric(M)
	assert(isfloat(M)&&isreal(M),...
		'SC:get_sRGB_matrix:M:NotRealFloat',...
		'1st input <M> must be a real floating point matrix.')
	assert(isequal(size(M),[3,3]),...
		'SC:get_sRGB_matrix:M:InvalidSize',...
		'1st input <M> must have size 3x3.')
	assert(all(isfinite(M(:))),...
		'SC:get_sRGB_matrix:M:NonFinite',...
		'1st input <M> must contain only finite values.')
	return
end
%
cnm.BT709 = {'BT709','D65HP','sRGB'};
cnm.D65 = {'D65','2D65'};
cnm.IEC61966 = {'IEC61966'};
cnm.lindbloom = {'Lindbloom'};
cnm.RIT = {'RIT','NCS'};
switch upper(M)
	case upper(cnm.BT709)
		M = [... Derived from ITU-R BT.709-6
			0.412390799265959,0.357584339383878,0.180480788401834;...
			0.212639005871510,0.715168678767756,0.072192315360734;...
			0.019330818715592,0.119194779794626,0.950532152249661];
	case upper(cnm.D65)
		M = [... matches common D65 illuminant with 5 sigfig
			0.41239,0.35758,0.18050;...
			0.21264,0.71517,0.07219;...
			0.01933,0.11919,0.95031];
	case upper(cnm.IEC61966)
		M = [... IEC 61966-2-1:1999
			0.4124,0.3576,0.1805;...
			0.2126,0.7152,0.0722;...
			0.0193,0.1192,0.9505];
	case upper(cnm.lindbloom)
		M = [... <http://brucelindbloom.com/index.html?Eqn_RGB_XYZ_Matrix.html>
			0.4124564,0.3575761,0.1804375;...
			0.2126729,0.7151522,0.0721750;...
			0.0193339,0.1191920,0.9503041];
	case upper(cnm.RIT)
		M = [... RIT / NCS
			0.412453, 0.357580, 0.180423;...
			0.212671, 0.715160, 0.072169;...
			0.019334, 0.119193, 0.950227];
	otherwise
		tmp = struct2cell(cnm);
		tmp = [tmp{:}];
		tmp = sprintf(', "%s"',tmp{:});
		error('SC:get_sRGB_matrix:M:NotSupported',...
			'1st input <M> must be a 3x3 numeric matrix or one of the following: %s.',tmp(3:end))
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%get_sRGB_matrix
% Copyright (c) 2018-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license