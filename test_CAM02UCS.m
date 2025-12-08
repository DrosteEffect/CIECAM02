function test_CAM02UCS()
% Test CIECAM02_TO_CAM02UCS and CAM02UCS_TO_CIECAM02 against sample values.
%
%% Dependencies %%
%
% * MATLAB R2009a or later.
% * CAM02UCS_parameters.m, CIECAM02_to_CAM02UCS.m,
%   CAM02UCS_to_CIECAM02.m, and test_fun.m
%   all from <https://github.com/DrosteEffect/CIECAM02>
%
% See also TEST_FUN CIECAM02_TO_CAM02UCS CAM02UCS_TO_CIECAM02
fprintf('Running @%s...\n',mfilename())
%
% Source: colorspacious/gold_values.py
JMh = struct('J',50,'M',20,'h',10);
Jab = [62.96296296,16.22742674,2.86133316];
K_L=1.00; c1=0.007; c2=0.0228; % UCS
%
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters(K_L,c1,c2))
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters('UCS'))
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters())
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters(K_L,c1,c2))
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters('UCS'))
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters())
%
% Source: colorspacious/gold_values.py
JMh = struct('J',10,'M',60,'h',100);
Jab = [15.88785047,-6.56546789,37.23461867];
%
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters(K_L,c1,c2))
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters('UCS'))
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters())
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters(K_L,c1,c2))
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters('UCS'))
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters())
%
% Source: colorspacious/gold_values.py
JMh = struct('J',50,'M',20,'h',10);
Jab = [81.77008177,18.72061994,3.30095039];
K_L=0.77; c1=0.007; c2=0.0053; % LCD
%
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters(K_L,c1,c2), true)
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters('LCD'),     true)
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters(K_L,c1,c2), true)
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters('LCD'),     true)
%
% Source: colorspacious/gold_values.py
JMh = struct('J',10,'M',60,'h',100);
Jab = [20.63357204,-9.04659289,51.30577777];
%
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters(K_L,c1,c2), true)
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters('LCD'),     true)
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters(K_L,c1,c2), true)
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters('LCD'),     true)
%
% Source: colorspacious/gold_values.py
JMh = struct('J',50,'M',20,'h',10);
Jab = [50.77658303,14.80756375,2.61097301];
K_L=1.24; c1=0.007; c2=0.0363; % SCD
%
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters(K_L,c1,c2), true)
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters('SCD'),     true)
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters(K_L,c1,c2), true)
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters('SCD'),     true)
%
% Source: colorspacious/gold_values.py
JMh = struct('J',10,'M',60,'h',100);
Jab = [12.81278263,-5.5311588,31.36876036];
%
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters(K_L,c1,c2), true)
test_fun(Jab, @CIECAM02_to_CAM02UCS, JMh, CAM02UCS_parameters('SCD'),     true)
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters(K_L,c1,c2), true)
test_fun(JMh, @CAM02UCS_to_CIECAM02, Jab, CAM02UCS_parameters('SCD'),     true)
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_CAM02UCS
% Copyright (c) 2017-2025 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license