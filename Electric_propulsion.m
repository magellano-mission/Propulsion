%% ELECTRIC PROPULSION

clear all
close all
clc

%%
 
eff = 0.5; % efficiency of the thruter
t_p = 30000; % [s] propulsive time of the thruster
alpha = 300; % [W/kg] specific power (Electricsl Power / Power plant mass)
Deltav = 100; % m/s
 
g0 = 9.807; % m/s^2
Is = 3000; % s
v_eff = Is*g0; % m/s
 
v_char = sqrt(2*alpha*eff*t_p); % [m/s] characteristic speed 
 
T_P = 2*eff/(g0*Is); %Thrust to power ratio
 
M0_Mpl = exp(Deltav/v_eff)/(1-(exp(Deltav/v_eff)-1)*(v_eff)^2/(2*alpha*eff*t_p));
 
% optimum_veff = @(
 
%% Optimum flight performance

clear all

Mpl = 150; %kg mass of the structure without propellant and power plant

Deltav = 9000; % m/s
g0 = 9.81;

Mpl_M0 = 0.55;
Deltav_vchar = 0.25;
veff_vchar = 0.86;

v_char = Deltav/Deltav_vchar;
v_eff = veff_vchar*v_char;
Is = v_eff/g0;

alpha = 300; % [W/kg] specific power (Electricsl Power / Power plant mass)
eff = 0.5; % efficiency of the thruter

t_p = v_char^2/(2*alpha*eff); % [s] propulsive time

MR = exp(Deltav/v_eff); % initial mass / final mass
Mprop = (MR-1)*Mpl/(Mpl_M0);% propellant mass

Mpp = Mprop*v_eff^2/(v_char^2); % [kg] power plant mass

Pe = alpha*Mpp; % [W] electric power

M0 = Mpp + Mprop + Mpl; % initial mass




 
 
 