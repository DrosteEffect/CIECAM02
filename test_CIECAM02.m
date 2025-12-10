function test_CIECAM02()
% Test CIECAM02_TO_CIEXYZ and CIEXYZ_TO_CIECAM02 against sample values.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
% * CIECAM02_parameters.m, CIECAM02_to_CIEXYZ.m,
%   CIEXYZ_to_CIECAM02.m, and test_fun.m
%   all from <https://github.com/DrosteEffect/CIECAM02>
%
% See also TEST_FUN CIECAM02_TO_CIEXYZ CIEXYZ_TO_CIECAM02
fprintf('Running @%s...\n',mfilename())
%
% Source: values apparently taken from CIE 159:2004 Section 9, available at:
% <https://github.com/igd-geo/pcolor/blob/master/de.fhg.igd.pcolor.test/src/de/fhg/igd/pcolor/test/CAMWorkedExample.java>
XYZ = [0.1931,0.2393,0.1014];
wp  = [0.9888,0.9,0.3203]; Y_b = 18; L_A = 200; F=1.0; c=0.69; N_c=1.0;
prm = CIECAM02_parameters(wp,Y_b,L_A,[F,c,N_c]);
h=191.0452; J=48.0314; Q=183.1240; s=46.0177; C=38.7789; M=38.7789; H=240.8885;
%
test_fun(mkStruct(J,Q,C,M,s,H,h), @CIEXYZ_to_CIECAM02, XYZ, prm)
%
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,H), prm)
%
% Source: ditto
L_A = 20; % <- different from above.
prm   = CIECAM02_parameters(wp,Y_b,L_A,[F,c,N_c]);
h=185.3445; J=47.6856; Q=113.8401; s=51.1275; C=36.0527; M=29.7580; H=232.6630;
%
test_fun(mkStruct(J,Q,C,M,s,H,h), @CIEXYZ_to_CIECAM02, XYZ, prm)
%
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,H), prm)
%
% Source: values from Mark Fairchild's spreadsheet at:
% <http://rit-mcsl.org/fairchild//files/AppModEx.xls>
XYZ = [0.1901,0.2,0.2178];
wp  = [0.9505,1.0,1.0888]; Y_b = 20.0; L_A = 318.30988618379; F=1.0; c=0.69; N_c=1.0;
prm   = CIECAM02_parameters(wp,Y_b,L_A,[F,c,N_c]);
h=219.04841; J=41.73109; Q=195.37131; s=2.36031; C=0.10471; M=0.10884; H=278.06070;
%
test_fun(mkStruct(J,Q,C,M,s,H,h), @CIEXYZ_to_CIECAM02, XYZ, prm)
%
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,H), prm)
%
% Source: ditto
XYZ = [0.5706,0.4306,0.3196];
wp  = [0.9505,1,1.0888]; Y_b = 20.0; L_A = 31.830988618379; F=1.0; c=0.69; N_c=1.0;
prm   = CIECAM02_parameters(wp,Y_b,L_A,[F,c,N_c]);
h=19.55739; J=65.95523; Q=152.67220; s=52.24549; C=48.57050; M=41.67327; H=399.38837;
%
test_fun(mkStruct(J,Q,C,M,s,H,h), @CIEXYZ_to_CIECAM02, XYZ, prm)
%
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,H), prm)
%
%% <https://colour.readthedocs.io/en/latest/generated/colour.XYZ_to_CIECAM02.html>
XYZ = [19.01, 20.00, 21.78]/100;
wp  = [95.05, 100, 108.88]/100;
L_A = 318.31;
Y_b = 20.0;
prm = CIECAM02_parameters(wp,Y_b,L_A,'average');
J=41.7310911; C=0.1047077; h=219.0484326; s=2.3603053; Q=195.3713259; M=0.1088421; H=278.0607358;
%
test_fun(mkStruct(J,Q,C,M,s,H,h), @CIEXYZ_to_CIECAM02, XYZ, prm)
%
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,h), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,C,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,M,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,s,H), prm)
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(Q,s,H), prm)
%
% <https://colour.readthedocs.io/en/latest/generated/colour.CIECAM16_to_XYZ.html>
J=41.731091132513917; C=0.104707757171031; h=219.048432658311780;
%
test_fun(XYZ, @CIECAM02_to_CIEXYZ, mkStruct(J,C,h), prm)
%
%test_fun(mkStruct(J,C,h), @CIEXYZ_to_CIECAM02, XYZ, prm)
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_CIECAM02
function S = mkStruct(varargin)
C = varargin([1,1],:);
for k = 1:nargin
	C{1,k} = inputname(k);
end
S = struct(C{:});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%mkStruct
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license