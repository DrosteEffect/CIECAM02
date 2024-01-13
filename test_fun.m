function test_fun(out, fnh, varargin)
% Support function for comparing function output against expected output.
%
% (c) 2017-2024 Stephen Cobeldick
%
% See also TEST_CAM02UCS TEST_CIECAM02

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
	error('Output class "%s" is not supported',class(out))
end
%
out = reshape(out,1,[]);
tuo = reshape(tuo,1,[]);
%
dbs = dbstack(1);
sgf = min(ceil(-log10(abs(out-tuo)./max(abs(out),abs(tuo)))));
%
if feature('hotlinks')
	fm0 = '<a href="matlab:opentoline(''%1$s'',%2$d)">@%3$s  line:%2$d</a>';
else
	fm0 = '@%3$s  line:%2$d';
end
str = sprintf(fm0,dbs(1).file,dbs(1).line,func2str(fnh));
fm1 = '  \x394sgf:%d  ';
fm2 = ' %+#.15g(%c)';
fprintf(str);fprintf(2,fm1,sgf);fprintf('expect:%s\n',sprintf(fm2,[out;+inm]))
fprintf(str);fprintf(2,fm1,sgf);fprintf('output:%s\n',sprintf(fm2,[tuo;+inm]))
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_fun
%
% Copyright (c) 2017-2024 Stephen Cobeldick
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