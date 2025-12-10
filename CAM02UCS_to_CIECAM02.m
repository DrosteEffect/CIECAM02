function out = CAM02UCS_to_CIECAM02(Jab,prm,isd)
% Convert an array of CAM02 colorspace values to a structure of CIECAM02 values.
%
%%% Syntax %%%
%
%   out = CAM02UCS_to_CIECAM02(Jab,prm)
%   out = CAM02UCS_to_CIECAM02(Jab,prm,isd)
%
% If the input was being used for calculating the euclidean color distance
% (i.e. deltaE) then set isd=true, so that J' values are multiplied by K_L.
%
%% Example %%
%
%   >> Jab = [56.9174814457648495,-7.94398845807383758,-33.5932377101949626];
%   >> prm = CAM02UCS_parameters();
%   >> out = CAM02UCS_to_CIECAM02(Jab,prm)
%   out =
%       J:  43.730
%       M:  52.496
%       h: 256.70
%
%% Input Arguments (**==default) %%
%
%   Jab = Double/single array, CAM02 perceptually uniform colorspace values J',a',b'.
%         Size Nx3 or RxCx3, the last dimension encodes the J'a'b' values.
%   prm = ScalarStructure of parameters from the function CAM02UCS_PARAMETERS.
%   isd = true    -> scaled J' for euclidean distance calculations (divided by K_L)
%       = false** -> reference J' values (no scaling).
%
%% Output Arguments %%
%
%   out = ScalarStructure of CIECAM02 J, M, and h values. Each field has the
%         class of <Jab>, and either size Nx1 or RxCx1. The fields encode:
%         J = Lightness
%         M = Colorfulness
%         h = Hue Angle
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * CAM02UCS_parameters.m <https://github.com/DrosteEffect/CIECAM02>
%
% See also CIECAM02_TO_CAM02UCS CAM02UCS_PARAMETERS
% CAM02UCS_TO_SRGB SRGB_TO_CAM02UCS CIECAM02_TO_CIEXYZ

%% Input Wrangling %%
%
isz = size(Jab);
assert(isfloat(Jab),...
	'SC:CAM02UCS_to_CIECAM02:Jab:NotFloat',...
	'1st input <Jab> must be a floating point array.')
assert(isreal(Jab),...
	'SC:CAM02UCS_to_CIECAM02:Jab:NotReal',...
	'1st input <Jab> must be a real array (not complex).')
assert(isz(end)==3,...
	'SC:CAM02UCS_to_CIECAM02:Jab:InvalidSize',...
	'1st input <Jab> last dimension must have size 3 (e.g. Nx3 or RxCx3).')
isz(end) = 1;
%
Jab = reshape(Jab,[],3);
%
Jp = Jab(:,1);
ap = Jab(:,2);
bp = Jab(:,3);
%
mfname = 'CAM02UCS_parameters';
assert(isstruct(prm)&&isscalar(prm),...
	'SC:CAM02UCS_to_CIECAM02:prm:NotScalarStruct',...
	'2nd input <prm> must be a scalar structure.')
assert(strcmp(prm.mfname,mfname),...
	'SC:CAM02UCS_to_CIECAM02:prm:UnknownStructOrigin',...
	'2nd input <prm> must be the structure returned by "%s.m".',mfname)
%
%% Jab2JMh %%
%
if nargin>2&&isd
	Jp = Jp * prm.K_L;
end
%
J  = -Jp ./ (prm.c1 * Jp - 100*prm.c1 -1);
%
h  = myAtan2d(bp,ap);
Mp = hypot(ap,bp);
%
M  = (exp(prm.c2*Mp) - 1) / prm.c2;
%
out = struct('J',J,'M',M,'h',h);
out = structfun(@(v)reshape(v,isz), out, 'UniformOutput',false);
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%CAM02UCS_to_CIECAM02
function ang = myAtan2d(Y,X)
% ATAN2 with an output in degrees. Note: ATAN2D only introduced R2012b.
ang = mod(360*atan2(Y,X)/(2*pi),360);
ang(Y==0 & X==0) = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%myAtan2d
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license