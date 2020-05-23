clear all
close all
clc

J2 = 1.955e-3;                      % mars J2 gravity coefficient
V = 1.6318e11;                      % mars volume [km^3]
a = 4900;
inc = -25;
e = 0;
mi = 42828.3;                       % mars gravity constant [km^2/s^3]
R = nthroot(3*V/(4*pi), 3);         % mars equivalent radius [km]
RAAN_dot = rad2deg(-3*J2*sqrt(mi)*R^2./(2*a.^(7/2)*(1-e^2)^2)*cosd(inc));

RAAN_y =(RAAN_dot*(60*60*24*365));
RAAN_d =(RAAN_dot*(60*60*24));

a = 7400;
RAAN_dot = rad2deg(-3*J2*sqrt(mi)*R^2./(2*a.^(7/2)*(1-e^2)^2)*cosd(inc));

RAAN_d2 =(RAAN_dot*(60*60*24));





 
fun = @(x) RAAN_dot + rad2deg(3*J2*sqrt(mi)*R^2./(2*x.^(7/2)*(1-e^2)^2)*cosd(89));
% 
SMA =fzero(fun,5000)

