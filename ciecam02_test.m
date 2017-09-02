function ciecam02_test()

ctSubFun() % reset counter
%
% Test value source (apparently taken from CIE 159:2004 Section 9):
% https://github.com/igd-geo/pcolor/blob/master/de.fhg.igd.pcolor.test/src/de/fhg/igd/pcolor/test/CAMWorkedExample.java
wp  = [98.88,90,32.03]; L_A = 200; Y_b = 18; F=1.0; c=0.69; N_c=1.0;
XYZ = [19.31,23.93,10.14];
h=191.0452; J=48.0314; Q=183.1240; s=46.0177; C=38.7789; M=38.7789; H=240.8885;
S = ciecam02_parameters(wp,Y_b,L_A,[F,c,N_c]);
ctSubFun([J,Q,C,M,s,H,h], @XYZ_2_ciecam02, XYZ, S)
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,C,h], S, 'JCh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,C,h], S, 'QCh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,M,h], S, 'JMh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,M,h], S, 'QMh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,s,h], S, 'Jsh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,s,h], S, 'Qsh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,C,H], S, 'JCH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,C,H], S, 'QCH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,M,H], S, 'JMH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,M,H], S, 'QMH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,s,H], S, 'JsH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,s,H], S, 'QsH')
% ditto
L_A = 20; % <- different from above.
h=185.3445; J=47.6856; Q=113.8401; s=51.1275; C=36.0527; M=29.7580; H=232.6630;
S = ciecam02_parameters(wp,Y_b,L_A,[F,c,N_c]);
ctSubFun([J,Q,C,M,s,H,h], @XYZ_2_ciecam02, XYZ, S)
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,C,h], S, 'JCh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,C,h], S, 'QCh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,M,h], S, 'JMh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,M,h], S, 'QMh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,s,h], S, 'Jsh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,s,h], S, 'Qsh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,C,H], S, 'JCH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,C,H], S, 'QCH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,M,H], S, 'JMH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,M,H], S, 'QMH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,s,H], S, 'JsH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,s,H], S, 'QsH')
%
% Test values from Mark Fairchild's spreadsheet at
% <http://rit-mcsl.org/fairchild//files/AppModEx.xls>
wp  = [95.05,100.0,108.88]; Y_b = 20.0; L_A = 318.30988618379; F=1.0; c=0.69; N_c=1.0;
XYZ = [19.01,20.00,21.78];
h=219.04841; J=41.73109; Q=195.37131; s=2.36031; C=0.10471; M=0.10884; H=278.06070;
S = ciecam02_parameters(wp,Y_b,L_A,[F,c,N_c]);
ctSubFun([J,Q,C,M,s,H,h], @XYZ_2_ciecam02, XYZ, S)
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,C,h], S, 'JCh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,C,h], S, 'QCh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,M,h], S, 'JMh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,M,h], S, 'QMh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,s,h], S, 'Jsh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,s,h], S, 'Qsh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,C,H], S, 'JCH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,C,H], S, 'QCH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,M,H], S, 'JMH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,M,H], S, 'QMH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,s,H], S, 'JsH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,s,H], S, 'QsH')
% ditto
wp  = [95.05,100.0,108.88]; L_A = 31.830988618379; Y_b = 20.0; F=1.0; c=0.69; N_c=1.0;
XYZ = [57.06,43.06,31.96];
h=19.55739; J=65.95523; Q=152.67220; s=52.24549; C=48.57050; M=41.67327; H=399.38837;
S = ciecam02_parameters(wp,Y_b,L_A,[F,c,N_c]);
ctSubFun([J,Q,C,M,s,H,h], @XYZ_2_ciecam02, XYZ, S)
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,C,h], S, 'JCh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,C,h], S, 'QCh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,M,h], S, 'JMh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,M,h], S, 'QMh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,s,h], S, 'Jsh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,s,h], S, 'Qsh')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,C,H], S, 'JCH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,C,H], S, 'QCH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,M,H], S, 'JMH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,M,H], S, 'QMH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [J,s,H], S, 'JsH')
ctSubFun(XYZ, @ciecam02_2_XYZ, [Q,s,H], S, 'QsH')
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ciecam02_test
function ctSubFun(out, fnh, varargin)
%
persistent itr
if nargin==0
	itr = 0;
	return
end
itr = 1+itr;
%
tmp = fnh(varargin{:});
%
sgf = 6;
mat = [out;tmp];
pwr = 10.^(sgf-1-max(fix(log10(abs(mat))),[],1));
nok = 32+56*any(diff(bsxfun(@times,mat,pwr),1,1)>1);
%
fmt = '%10.4f';
str = sprintf('%2d @%s',itr,func2str(fnh));
fprintf('%s %s Expect:%s\n', str, ' ', sprintf(fmt,out))
fprintf('%s %s Output:%s\n', str, nok, sprintf(fmt,tmp))
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ctSubFun