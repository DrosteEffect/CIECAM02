function test_CIECAM02()
% Test CIECAM02_TO_CIEXYZ and CIECIEXYZ_TO_CIECAM02 against sample values.
%
% (c) 2017-2020 Stephen Cobeldick
%
% See also TEST_FUN CIECAM02_TO_CIEXYZ CIECIEXYZ_TO_CIECAM02

% Initialize test function:
test_fun(mfilename())
%
% Source: values apparently taken from CIE 159:2004 Section 9, available at:
% https://github.com/igd-geo/pcolor/blob/master/de.fhg.igd.pcolor.test/src/de/fhg/igd/pcolor/test/CAMWorkedExample.java
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
