function test_fun(exp, fnh, varargin)
% Support function for comparing function output against expected output.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
%
% See also TEST_CAM02UCS TEST_CIECAM02 TEST_CAM16UCS TEST_CIECAM16
act = fnh(varargin{:});
%
if isnumeric(exp)
	inm = double(inputname(1));
elseif isstruct(exp)
	fld = fieldnames(exp);
	inm = double([fld{:}]);
	exp = structfun(@(n)n,exp); % scalar struct only!
	act = structfun(@(n)n,orderfields(act,fld));
else
	error('Output class "%s" is not supported.',class(exp))
end
assert(numel(inm)==numel(exp),'Only single-character field/column names.')
assert(numel(act)==numel(exp),'Actual and expected must be same length.')
%
exp = reshape(double(exp),1,[]);
act = reshape(double(act),1,[]);
%
dbs = dbstack(1);
sgf = min(ceil(-log10(abs(exp-act)./max(abs(exp),abs(act)))));
%
if feature('hotlinks')
	fm0 = '<a href="matlab:opentoline(''%1$s'',%2$d)">@%3$s  line:%2$d</a>';
else
	fm0 = '@%3$s  line:%2$d';
end
str = sprintf(fm0, dbs(1).file, dbs(1).line, func2str(fnh));
fm1 = '  \x394sgf:%2d  ';
fm2 = ' %+#.15g(%c)';
fprintf(str); fprintf(2,fm1,sgf); fprintf('expect:%s\n',sprintf(fm2,[exp;inm]))
fprintf(str); fprintf(2,fm1,sgf); fprintf('actual:%s\n',sprintf(fm2,[act;inm]))
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test_fun
% Copyright (c) 2017-2026 Stephen Cobeldick
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%license