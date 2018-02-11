clear
close all


kmax  = 3e-3;
z     = 20;
zr    = 3;
p1    = -1;
p2    = -5;
p50   = -2;
a     = 7;
param = [kmax,z,p1,p2,p50,a];

psoil = -0.3;
x=[];
for i=1:60
[out,psoil] = oneday(psoil,param,zr);
x = [x;out];
end


subplot(1,2,1)
plot(x(:,1))
hold on
plot(x(:,2))
subplot(1,2,2)
plot(x(:,4))