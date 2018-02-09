
R = 400;
rh = 0.8;
T = 300;
gs = 1/30;
ga = -1;


p_atm    = 1e5;
r_gas    = 8.314;
x        = 1.6*r_gas*T/p_atm;

gsc_max = medlyn(get_vpd(rh,T)/1000);
gsw_max = gsc_max*x;

A2=get_A(gsc_max)
q=penman(R,rh,T,gsw_max,-1)