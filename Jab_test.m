function Jab_test()

jtSubFun() % reset counter
%
KL = 1.00; c1 = 0.007; c2 = 0.0228; % UCS
JMh = [50,20,10]; Jab = [62.96296296,16.22742674,2.86133316];
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters(KL,c1,c2))
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters('UCS'))
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters())
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters(KL,c1,c2))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters('UCS'))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters())
JMh = [10,60,100]; Jab = [15.88785047,-6.56546789,37.23461867];
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters(KL,c1,c2))
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters('UCS'))
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters())
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters(KL,c1,c2))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters('UCS'))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters())
%
KL = 0.77; c1 = 0.007; c2 = 0.0053; % LCD
JMh = [50,20,10]; Jab = [81.77008177,18.72061994,3.30095039];
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters(KL,c1,c2))
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters('LCD'))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters(KL,c1,c2))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters('LCD'))
JMh = [10,60,100]; Jab = [20.63357204,-9.04659289,51.30577777];
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters(KL,c1,c2))
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters('LCD'))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters(KL,c1,c2))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters('LCD'))
%
KL = 1.24; c1 = 0.007; c2 = 0.0363; % SCD
JMh = [50,20,10]; Jab = [50.77658303,14.80756375,2.61097301];
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters(KL,c1,c2))
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters('SCD'))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters(KL,c1,c2))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters('SCD'))
JMh = [10,60,100]; Jab = [12.81278263,-5.5311588,31.36876036];
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters(KL,c1,c2))
jtSubFun(Jab, @JMh_2_Jab, JMh, Jab_parameters('SCD'))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters(KL,c1,c2))
jtSubFun(JMh, @Jab_2_JMh, Jab, Jab_parameters('SCD'))
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Jab_test
function jtSubFun(out, fnh, varargin)
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
sgf = 8;
mat = [out;tmp];
pwr = 10.^(sgf-1-max(fix(log10(abs(mat))),[],1));
nok = 32+56*any(diff(bsxfun(@times,mat,pwr),1,1)>1);
%
fmt = '%11.4f';
str = sprintf('%2d @%s',itr,func2str(fnh));
fprintf('%s %s Expect:%s\n', str, ' ', sprintf(fmt,out))
fprintf('%s %s Output:%s\n', str, nok, sprintf(fmt,tmp))
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%jtSubFun