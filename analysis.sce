// Laboratory 4, variant 5. Standalone Scilab calculations.
// Run with exec('analysis.sce', -1) from Scilab.
clear; clc;
s = poly(0, 's');
K0=25; K1=1.4; T1=0.13; K2=2; T2=0.025;
W1=syslin('c',K1/(1+T1*s));
W2=syslin('c',K2/(s*(1+T2*s)));
W0=K0*W1*W2;
Wk=syslin('c',0.1*(1+0.13*s)/(1+0.013*s));
L=Wk*W0;
t=0:0.001:5;
v=ones(t); w=logspace(-2,4,3000);
g0=70 ./ (%i*w.*(1+0.13*%i*w).*(1+0.025*%i*w));
gc=0.1*(1+0.13*%i*w)./(1+0.013*%i*w);
gl=g0.*gc;
scf(1); clf();
plot2d(w',[20*log10(abs(g0))' 20*log10(abs(gl))' 20*log10(abs(gc))'],logflag='ln');
xgrid();xtitle('Open-loop frequency responses','omega, rad/s','L, dB');
legend('Original','Desired = corrected','Corrector');
names=['Original','Corrected','Half gain','Double gain'];
gains=[1,1,0.5,2];
for j=1:4
 if j==1 then
  H=syslin('c',70/(0.00325*s^3+0.155*s^2+s+70));
 else
  k=7*gains(j);
  H=syslin('c',k/(0.000325*s^3+0.038*s^2+s+k));
 end
 y=csim('step',t,H); e=v-y;
 scf(j+1);clf();plot(t',[v' y' e']);xgrid();
 xtitle(names(j),'t, s','Amplitude');legend('v(t)','y(t)','Delta(t)');
 if j>1 then
  bad=find(abs(y-1)>0.05);
  tp=t(bad($)+1); sigma=max(0,100*(max(y)-1));
  mprintf('%s: settling time (5%%) = %.3f s, overshoot = %.3f %%\n',names(j),tp,sigma);
  if tp>1.6 | sigma>30 then error('Quality requirements failed');end
 else
  mprintf('Original closed-loop poles:\n');disp(roots(H.den));
 end
end
scf(6);clf();
plot2d(w',[20*log10(abs(gl/2))' 20*log10(abs(gl))' 20*log10(abs(2*gl))'],logflag='ln');
xgrid();xtitle('Corrector gain comparison','omega, rad/s','L, dB');
legend('Kc = 0.05','Kc = 0.10','Kc = 0.20');
