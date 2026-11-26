mode(2);loadXcosLibs();s=poly(0,'s');
base=get_absolute_file_path('build_models.sce');
function b=pos(b,x,y,w,h,name)
 b.graphics.orig=[x y];b.graphics.sz=[w h];b.graphics.id=name;
endfunction
function b=tfblock(num,den,x,y,w,name)
 b=CLR('define'); a=tf2ss(syslin('c',num,den));
 b.model.state=zeros(size(a.A,1),1);b.model.rpar=[a.A(:);a.B(:);a.C(:);a.D(:)];
 b.model.dep_ut=[a.D<>0 %t];b.graphics.exprs=[sci2exp(num);sci2exp(den)];
 b.graphics.style='CLR;displayedLabel=$\frac{'+sci2exp(num)+'}{'+sci2exp(den)+'}$';
 b=pos(b,x,y,w,60,name);
endfunction
function d=wire(d,a,ap,b,bp,xx,yy)
 k=length(d.objs)+1;
 d.objs(k)=scicos_link(xx=xx,yy=yy,ct=[1 1],from=[a ap 0],to=[b bp 1]);
 d.objs(a).graphics.pout(ap)=k;d.objs(b).graphics.pin(bp)=k;
endfunction
try
for variant=0:3
 d=scicos_diagram();d.props.title='Lab 4 Variant 5';d.props.tf=5;
 d.props.tol=[1d-8;1d-8;1d-10;0.1;0;5;0.001];
 d.props.context=['s=poly(0,''s'');'];
 step=STEP_FUNCTION('define');
 step.model.rpar.objs(1).model.firing=0;
 step.model.rpar.objs(1).model.rpar=[1;1];
 step.model.rpar.objs(1).graphics.exprs=['0';'0';'1'];
 d.objs(1)=pos(step,20,200,40,40,'Step v(t)');
 d.objs(2)=pos(SPLIT_f('define'),85,220,0.1,0.1,'');
 d.objs(3)=pos(SUMMATION('define'),120,200,40,40,'Delta = v - y');
 d.objs(4)=pos(SPLIT_f('define'),185,220,0.1,0.1,'');
 b=GAINBLK_f('define');b.model.rpar=25;b.graphics.exprs='25';
 d.objs(5)=pos(b,220,200,60,40,'K0');
 d.objs(6)=tfblock(1.4,1+.13*s,570,190,130,'W1');
 d.objs(7)=tfblock(2,s*(1+.025*s),750,190,160,'W2');
 d.objs(8)=pos(SPLIT_f('define'),950,220,0.1,0.1,'');
 b=MUX('define');b.model.in=[1;1;1];b.model.out=3;b.model.ipar=3;b.graphics.exprs='3';b.graphics.pin=[0;0;0];
 d.objs(9)=pos(b,1050,175,10,90,'MUX');
 d.objs(10)=pos(SPLIT_f('define'),1100,220,.1,.1,'');
 b=CSCOPE('define');b.model.evtin=[];b.graphics.pein=[];b.graphics.exprs(9)='1';b.model.rpar=[0;-1;2;5];
 b.graphics.exprs(5)='-1';b.graphics.exprs(6)='2';b.graphics.exprs(7)='5';
 d.objs(11)=pos(b,1150,200,60,40,'Scope v y Delta');
 b=TOWS_c('define');b.model.evtin=[];b.graphics.pein=[];b.model.blocktype='x';b.model.ipar=[100000;7;ascii('signals')'];b.graphics.exprs=['100000';'signals';'1'];
 d.objs(12)=pos(b,1150,80,60,40,'signals');
 d=wire(d,1,1,2,1,[60;85],[220;220]);
 d=wire(d,2,1,3,1,[85;110;110;120],[220;220;227;227]);
 d=wire(d,2,2,9,1,[85;85;1020;1020;1050],[220;330;330;242.5;242.5]);
 d=wire(d,3,1,4,1,[160;185],[220;220]);
 d=wire(d,4,1,5,1,[185;220],[220;220]);
 d=wire(d,4,2,9,3,[185;185;1020;1020;1050],[220;60;60;197.5;197.5]);
 if variant==0 then
  name='01_original';d=wire(d,5,1,6,1,[280;570],[220;220]);
 else
  gains=[.1;.05;.2]; gain=gains(variant);
  b=GAINBLK_f('define');b.model.rpar=gain;b.graphics.exprs=string(gain);
  d.objs($+1)=pos(b,330,200,55,40,'Kc');cg=length(d.objs);
  d.objs($+1)=tfblock(1+.13*s,1+.013*s,420,190,110,'Wk lead');cf=length(d.objs);
  d=wire(d,5,1,cg,1,[280;330],[220;220]);
  d=wire(d,cg,1,cf,1,[385;420],[220;220]);
  d=wire(d,cf,1,6,1,[530;570],[220;220]);
  names=['02_corrected';'03_half_gain';'04_double_gain'];name=names(variant);
 end
 d=wire(d,6,1,7,1,[700;750],[220;220]);
 d=wire(d,7,1,8,1,[910;950],[220;220]);
 d=wire(d,8,1,3,2,[950;950;105;105;120],[220;120;120;213;213]);
 d=wire(d,8,2,9,2,[950;1050],[220;220]);
 d=wire(d,9,1,10,1,[1060;1100],[220;220]);
 d=wire(d,10,1,11,1,[1100;1150],[220;220]);
 d=wire(d,10,2,12,1,[1100;1100;1150],[220;100;100]);
 if variant==0 then;yl=-450;yh=450;else;yl=-0.2;yh=1.3;end
 d.objs(11).model.rpar=[0;yl;yh;5];d.objs(11).graphics.exprs(5)=string(yl);d.objs(11).graphics.exprs(6)=string(yh);
 scs_m=d;xcosDiagramToScilab(base+name+'.zcos',scs_m);

end
catch
disp(lasterror());
end








