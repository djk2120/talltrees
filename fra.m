
psoil = -0.5;

kmax  = 5e-3;
z     = 20;
p1    = -1;
p2    = -3;
p50   = -2.5;
a     = 6;
param = [kmax,z,p1,p2,p50,a];

R     = 400;
rh    = 0.7;
T     = 300;
ga    = -1;


p_atm    = 1e5;
r_gas    = 8.314;
x        = 1.6*r_gas*T/p_atm;
gsc_max = medlyn(get_vpd(rh,T)/1000);
gsw_max = gsc_max*x;

pen = [R,rh,T,gsw_max,ga];

[q,pleaf,gsw] = get_vwp(psoil,param,pen)