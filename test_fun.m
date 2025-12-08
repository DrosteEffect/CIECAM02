function test_fun(out, fnh, varargin)
% Support function for comparing function output against expected output.
%
%% Dependencies %%
%
% * MATLAB R2009a or later.
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
fm1 = '  \x394sgf:%2d  ';
fm2 = ' %+#.15g(%c)';
fprintf(str);fprintf(2,fm1,sgf);fprintf('expect:%s\n',sprintf(fm2,[out;+inm]))
fprintf(str);fprintf(2,fm1,sgf);fprintf('output:%s\n',sprintf(fm2,[tuo;+inm]))
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_fun
% Copyright (c) 2017-2025 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license