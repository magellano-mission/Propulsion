%% Chemical phasing
clear all
close all
clc

%% Phasing orbit

data.mi = astroConstants(14);
%data.InitDay = date2mjd2000([2026,1,1,0,0,0]);
data.InitDay = 0;
data.ThrustDir = 1; % tangential thrust

kep0 = [12300, 0 , deg2rad(30), 0, 0, 0]; % a, e, i, OM, om, theta
[rr,vv] = kep2car(kep0,data.mi);

data.M0 = 300; % [kg] initial mass 
data.Isp = 228 % [s] specific impulse
data.T = -22; % [N] thrust


n = sqrt(data.mi/kep0(1)^3);               % angular velocity [rad/s]
v_orbit = sqrt(data.mi/kep0(1));            % linear velocity of the GNSS constellation [km/s]

T_period = 2*pi/n;                         % GNSS period [s]
angle = 180; % [deg] phasing angle
Nrev = 180;

dT_tot = (angle*pi/180)/n;
dT_rev = dT_tot/Nrev;          
T_phas = T_period - dT_rev;
a_phas  = (T_phas*sqrt(data.mi)/(2*pi))^(2/3);
ra_phas = kep0(1);
rp_phas = 2*a_phas - ra_phas;
e_phas = (ra_phas - rp_phas)/(ra_phas + rp_phas);
v_phas = sqrt(data.mi/a_phas)*(1 - e_phas)   ;
dv_phas= 2*abs(v_orbit - v_phas);


%% Phasing maneuver

acc = abs(data.T)/data.M0;
T_maneuver = floor(0.5*dv_phas*1000/acc);


data.Y0 = [rr; vv; data.M0];
data.opt = odeset('RelTol', 1e-12, 'AbsTol', 1e-12);

[~, Y1] = ode113(@Electric_integration, [0, T_maneuver], data.Y0, data.opt, data);

cart_end = Y1(end,1:6);
kep_end = car2kep(cart_end(1:3),cart_end(4:6),data.mi);

error_a = kep_end(1) - a_phas;
error_e = kep_end(2) - e_phas;


