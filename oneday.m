function [out,psoil] = oneday( psoil,param,zr )
%oneday Generates a one day simulation 
%   returns half hourly data
%    (:,1) psoil   [MPa]        psi soil
%    (:,2) pleaf   [MPa]        psi leaf
%    (:,3) q       [mm/s]       evapotranspiration
%    (:,4) A       [umol/m2/s]  gross photosynthesis
%   inputs are
%     psoil [MPa]
%     param [parameter vector]
%     zr    [m]   root depth (for bucket)
met()
z   = param(2);
out = zeros(48,4);
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
    
out(i,1) = psoil;
out(i,2) = pleaf;
out(i,3) = q;
out(i,4) = A;
psoil = bucket(psoil,q,zr);

end
end

