function [] = met(  )
% create forcing data

R = linspace(0,2*pi,48);
R = -2*cos(R);
R(R<0) = 0;

R = 150*R.^2;

rh = 0.01*[87.1503,87.9342,88.7145,89.5901,...
    90.2816,90.9393,91.453,92.0479,92.4406,...
    92.9929,93.3707,93.9048,94.3881,94.9834,...
    89.8256,85.0322,80.3259,75.9258,72.0302,...
    68.5241,65.5139,62.9223,60.6388,58.9413,...
    57.2142,55.2759,53.8922,52.3857,51.2863,...
    50.5796,50.172,49.4482,51.3479,53.5473,...
    56.4443,60.529,63.4854,67.4536,70.3152,...
    73.4299,75.6491,78.8381,80.8116,82.7443,...
    83.6081,84.5279,85.3242,86.3791];

T = [297.51,297.35,297.22,297.09,296.99,...
    296.89,296.81,296.74,296.69,296.62,296.49,...
    296.39,296.39,296.63,297.4,298.41,299.22,...
    299.93,300.49,301.01,301.5,301.99,302.36,...
    302.68,302.98,303.29,303.56,303.82,304,304.16,...
    304.19,304.17,304,303.76,303.21,302.51,301.82,...
    301.14,300.58,300.07,299.6,299.15,298.79,298.46,...
    298.21,298,297.82,297.63];

j = 6*[zeros(1,12),...
    0.0002  ,  2.7853  ,  7.3783  , 13.1746  , 17.0185  , 19.4181,...   
   21.8493 ,  23.0120 ,  24.0017 ,  24.5521,24.8493,   25.0500];
j  = [j,j(end:-1:1)];

assignin('caller','j48',j)
assignin('caller','R48',R)
assignin('caller','rh48',rh)
assignin('caller','T48',T)
end

