function test_fun(out, fnh, varargin)
% Support function for comparing function output against expected output.
%
% (c) 2019 Stephen Cobeldick
%
% See also TEST_CIECAM02 TEST_JAB

persistent sgf fmt
%
if isnumeric(fnh) && ischar(out)
	sgf = fnh;
	fmt = sprintf('  %%+#.%dg(%%c)',sgf+1);
	fprintf('Running @%s...\n',out);
	return
end
%
tmp = fnh(varargin{:});
%
if isnumeric(out)
	inm = inputname(1);
elseif isstruct(out)
	fld = fieldnames(out);
	inm = [fld{:}];
	out = structfun(@(n)n,out);
	tmp = structfun(@(n)n,orderfields(tmp,fld));
else
	error('This output class is not supported')
end
%
out = reshape(out,1,[]);
tmp = reshape(tmp,1,[]);
%
mat = [out;tmp];
pwr = 10.^(sgf-1-max(fix(log10(abs(mat))),[],1));
nok = char(32+56*any(abs(diff(bsxfun(@times,mat,pwr),1,1))>1));
%
dbs = dbstack(1);
str = sprintf('@%s %3d',func2str(fnh),dbs(1).line);
fprintf('%s  %s  Expect:%s\n', str, ' ', sprintf(fmt,[out;+inm]))
fprintf('%s  %s  Output:%s\n', str, nok, sprintf(fmt,[tmp;+inm]))
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_fun
%
% Copyright (c) 2019 Stephen Cobeldick
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