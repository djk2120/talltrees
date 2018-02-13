function psoil1 = bucket( psoil0,q,zr )
%bucket Simplified bucket model
%   inputs
%     psoil0, original soil water potential [MPa]
%     q     , ET                            [mm/s]
%     zr    , rooting depth                 [m]

q  = q/1e3;
dt = 1800;


b = 5;
psat  = -.003;
smsat = 0.5;

sm0   = smsat*(psoil0/psat)^(-1/b);
sm1   = sm0-q*dt/zr;

psoil1 = psat*(sm1/smsat)^-b;

end

