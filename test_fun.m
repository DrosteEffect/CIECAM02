function test_fun(xpa, fnh, varargin)
% Support function for comparing function output against expected output.
%
%% Dependencies %%
%
% * MATLAB R2009b or later.
%
% See also TEST_CAM02UCS TEST_CIECAM02 TEST_CAM16UCS TEST_CIECAM16
opa = fnh(varargin{:});
%
if isnumeric(xpa)
	inm = double(inputname(1));
elseif isstruct(xpa)
	fld = fieldnames(xpa);
	inm = double([fld{:}]);
	xpa = structfun(@(n)n,xpa); % scalar struct only!
	opa = structfun(@(n)n,orderfields(opa,fld));
else
	error('Output class "%s" is not supported.',class(xpa))
end
assert(numel(inm)==numel(xpa),'Only single-character field/column names.')
assert(numel(opa)==numel(xpa),'Actual and expected must be same length.')
%
xpa = reshape(double(xpa),1,[]);
opa = reshape(double(opa),1,[]);
%
dbs = dbstack(1);
err = abs(xpa(:)-opa(:));
scf = max(1,max(abs(xpa(:)),abs(opa(:))));
dgt = min(-log10(err./scf));
%
if feature('hotlinks')
	fm0 = '<a href="matlab:opentoline(''%1$s'',%2$d)">@%3$s  line:%2$d</a>';
else
	fm0 = '@%3$s  line:%2$d';
end
str = sprintf(fm0, dbs(1).file, dbs(1).line, func2str(fnh));
fm1 = ' \x394:%3.2g ';
fm2 = ' %+#.15g(%c)';
fprintf(str); fprintf(2,fm1,dgt); fprintf('expect:%s\n',sprintf(fm2,[xpa;inm]))
fprintf(str); fprintf(2,fm1,dgt); fprintf('actual:%s\n',sprintf(fm2,[opa;inm]))
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