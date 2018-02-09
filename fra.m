clear
close all

psoil = -0.3;

kmax  = 5e-3;
z     = 20;
p1    = -1;
p2    = -5;
p50   = -2;
a     = 7;
param = [kmax,z,p1,p2,p50,a];


met()

out = zeros(480,1);
for dd = 1:10
for i=1:48
R     = R48(i);
j     = j48(i);
rh    = rh48(i);
T     = T48(i);
ga    = -1;


p_atm    = 1e5;
r_gas    = 8.314;
x        = 1.6*r_gas*T/p_atm;
gsc_max = medlyn(get_vpd(rh,T)/1000,j);
gsw_max = gsc_max*x;

if j>0
    pen = [R,rh,T,gsw_max,ga];
    [q,pleaf,gsw] = get_vwp(psoil,param,pen);
    A             = get_A(j,gsw/x);
else
    A = 0;
    pleaf = psoil - z*9.8e-3;
    q = penman(R,rh,T,gsw_max,-1);
end
    
out(i+(dd-1)*48) = pleaf;
psoil = bucket(psoil,q);

end
end

plot(out)


