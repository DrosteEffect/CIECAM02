function [dE,Jab1,Jab2] = CAM02UCS_deltaE(rgb1,rgb2,varargin)
% Calculate perceptual color difference (deltaE) between sRGB colors using CAM02-UCS.
%
%%% Syntax %%%
%
%   dE = CAM02UCS_deltaE(rgb1,rgb2)
%   dE = CAM02UCS_deltaE(rgb1,rgb2,coords)
%   dE = CAM02UCS_deltaE(rgb1,rgb2,...,<opts>)
%   [dE,Jab1,Jab2] = CAM02UCS_deltaE(...)
%
%% Examples %%
%
%   >> rgb1 = [64,128,255]/255;
%   >> rgb2 = [128,64,200]/255;
%   >> dE = CAM02UCS_deltaE(rgb1,rgb2)
%   dE =
%        25.7346
%
%   >> rgb1 = uint8([64,128,255; 100,150,200]);
%   >> rgb2 = uint8([128,64,200]);
%   >> dE = CAM02UCS_deltaE(rgb1,rgb2)
%   dE =
%        25.7346
%        30.6617
%
%   >> dE = CAM02UCS_deltaE(rgb1,rgb2,'JCh')
%   dE =
%        25.7346
%        30.6617
%
%   >> dE = CAM02UCS_deltaE(rgb1,rgb2,'Jab','LCD')
%   dE =
%        34.1038
%        39.8976
%
%% Input Arguments (**==default) %%
%
%   rgb1 = Numeric array of sRGB values. Floating point values must be
%          0<=rgb<=1, integer must be 0<=rgb<=intmax(class(rgb)).
%          Size Nx3 or RxCx3, the last dimension encodes the R,G,B values.
%   rgb2 = Numeric array of sRGB values, same format as <rgb1>. Note that
%	       either <rgb1> or <rgb2> may consist of one color, which will be
%	       implicitly expanded to match the colors of the other rgb array.
%   coords = StringScalar or CharRowVector, either of the following:
%          'Jab'** / 'JCh', which selects the CAM02 deltaE coordinates:
%          Jab   cartesian coordinates: lightness - red/green - yellow/blue
%          JCh cylindrical coordinates: lightness - chroma - hue angle
%   <opts> = all trailing inputs are passed to CAM02UCS_parameters.
%
%% Output Arguments %%
%
%   dE = Column vector of Euclidean color differences in CAM02-UCS space.
%        Size Nx1, where N is the max number of colors in <rgb1> or <rgb2>.
%   Jab1 = Numeric Nx3 matrix of the <rgb1> colors in CAM02 colorspace.
%   Jab2 = Numeric Nx3 matrix of the <rgb2> colors in CAM02 colorspace.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * sRGB_to_CAM02UCS.m from <https://github.com/DrosteEffect/CIECAM02>
%
% See also SRGB_TO_CAM02UCS CAM02UCS_TO_SRGB CAM02UCS_PARAMETERS

%% Input Wrangling %%
%
dcs = 'JAB'; % default coordinates
for k = 1:numel(varargin)
	try %#ok<TRYNC>
		tmp = upper(varargin{k});
		switch tmp
			case {'JAB','JCH'}
				varargin(k) = [];
				dcs = tmp;
		end
	end
end
%
% Convert to CAM02-UCS with isd=true for deltaE calculations.
% The conversion function performs input checking on the sRGB.
Jab1 = sRGB_to_CAM02UCS(rgb1,true,varargin{:});
Jab2 = sRGB_to_CAM02UCS(rgb2,true,varargin{:});
%
% Reshape to Nx3
Jab1 = reshape(Jab1,[],3);
Jab2 = reshape(Jab2,[],3);
%
n1 = size(Jab1,1);
n2 = size(Jab2,1);
%
% Check size compatibility
assert(n1==n2 || n1==1 || n2==1,...
	'SC:CAM02UCS_deltaE:rgb:IncompatibleSizes',...
	'Inputs <rgb1> and <rgb2> must have the same number of rows, or one must have a single row.')
%
%% Calculate DeltaE %%
%
% Calculate Euclidean distance based on selected colorspace
switch dcs
	case 'JAB'
		% Already in J'a'b' format - use bsxfun for compatibility
		diff = bsxfun(@minus, Jab1, Jab2);
		dE = sqrt(sum(diff.^2, 2));
	case 'JCH'
		% Convert to J'C'h
		J1 = Jab1(:,1); a1 = Jab1(:,2); b1 = Jab1(:,3);
		J2 = Jab2(:,1); a2 = Jab2(:,2); b2 = Jab2(:,3);
		C1 = sqrt(a1.^2 + b1.^2);
		C2 = sqrt(a2.^2 + b2.^2);
		h1 = atan2(b1,a1);
		h2 = atan2(b2,a2);
		dh = bsxfun(@minus, h1, h2);
		dh = mod(dh+pi,2*pi)-pi;
		dH = 2*sqrt(bsxfun(@times, C1, C2)).*sin(dh/2);
		dE = sqrt(...
			bsxfun(@minus, J1, J2).^2 + ...
			bsxfun(@minus, C1, C2).^2 + dH.^2);
end
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAM02UCS_deltaE
% Copyright (c) 2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license