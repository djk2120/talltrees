function psoil1 = bucket( psoil0,q )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

q  = q/1e3;
dt = 1800;
z  = 2;

b = 5;
psat  = -.003;
smsat = 0.5;

sm0   = smsat*(psoil0/psat)^(-1/b);
sm1   = sm0-q*dt/z;

psoil1 = psat*(sm1/smsat)^-b;

end

