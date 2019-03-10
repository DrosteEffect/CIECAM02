function test_Jab(sgf)
% Compare CIECAM02_TO_JAB and JAB_TO_CIECAM02 outputs against test values.
%
% (c) 2017-2019 Stephen Cobeldick
%
% See also TEST_FUN CIECAM02_TO_JAB JAB_TO_CIECAM02

% Initialize test function:
if nargin
	test_fun(mfilename(), sgf)
else
	test_fun(mfilename(), 8)
end
%
JMh = struct('J',50,'M',20,'h',10);
Jab = [62.96296296,16.22742674,2.86133316];
K_L=1.00; c1=0.007; c2=0.0228; % UCS
%
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters(K_L,c1,c2))
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters('UCS'))
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters())
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters(K_L,c1,c2))
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters('UCS'))
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters())
%
JMh = struct('J',10,'M',60,'h',100);
Jab = [15.88785047,-6.56546789,37.23461867];
%
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters(K_L,c1,c2))
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters('UCS'))
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters())
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters(K_L,c1,c2))
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters('UCS'))
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters())
%
JMh = struct('J',50,'M',20,'h',10);
Jab = [81.77008177,18.72061994,3.30095039];
K_L=0.77; c1=0.007; c2=0.0053; % LCD
%
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters(K_L,c1,c2), true)
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters('LCD'),     true)
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters(K_L,c1,c2), true)
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters('LCD'),     true)
%
JMh = struct('J',10,'M',60,'h',100);
Jab = [20.63357204,-9.04659289,51.30577777];
%
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters(K_L,c1,c2), true)
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters('LCD'),     true)
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters(K_L,c1,c2), true)
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters('LCD'),     true)
%
JMh = struct('J',50,'M',20,'h',10);
Jab = [50.77658303,14.80756375,2.61097301];
K_L=1.24; c1=0.007; c2=0.0363; % SCD
%
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters(K_L,c1,c2), true)
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters('SCD'),     true)
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters(K_L,c1,c2), true)
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters('SCD'),     true)
%
JMh = struct('J',10,'M',60,'h',100);
Jab = [12.81278263,-5.5311588,31.36876036];
%
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters(K_L,c1,c2), true)
test_fun(Jab, @ciecam02_to_Jab, JMh, Jab_parameters('SCD'),     true)
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters(K_L,c1,c2), true)
test_fun(JMh, @Jab_to_ciecam02, Jab, Jab_parameters('SCD'),     true)
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Jab_test
%
% Copyright (c) 2017 Stephen Cobeldick
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