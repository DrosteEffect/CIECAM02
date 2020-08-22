function test_fun(out, fnh, varargin)
% Support function for comparing function output against expected output.
%
% (c) 2017-2020 Stephen Cobeldick
%
% See also TEST_CIECAM02 TEST_JAB

if nargin==1
	fprintf('Running @%s...\n',out);
	return
end
%
tuo = fnh(varargin{:});
%
if isnumeric(out)
	inm = inputname(1);
elseif isstruct(out)
	fld = fieldnames(out);
	inm = [fld{:}];
	out = structfun(@(n)n,out);
	tuo = structfun(@(n)n,orderfields(tuo,fld));
else
	error('This output class is not supported')
end
%
out = reshape(out,1,[]);
tuo = reshape(tuo,1,[]);
%
dbs = dbstack(1);
sgf = min(ceil(-log10(abs(out-tuo)./max(abs(out),abs(tuo)))));
fmt = ' %+#.15g(%c)';
str = sprintf('@%s  line:%d',func2str(fnh),dbs(1).line);
fprintf('%s  sgf:%d  expect:%s\n', str, sgf, sprintf(fmt,[out;+inm]))
fprintf('%s  sgf:%d  output:%s\n', str, sgf, sprintf(fmt,[tuo;+inm]))
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_fun
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
