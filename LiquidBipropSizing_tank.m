%% LIQUID BIPROP SIZING
clear all; close all; clc

%% Initial data

% MOOG - Leros 1b

g0 = 9.807;
%OF = 0.85;
Isp = 317;
T = 635;
m_dot = T/(Isp*g0);
P_ch = 1.62e6; %235 psia

Mfin = 6*300+1*800; % mass of a stack

rho_ox = 1.44246e-3; %kg/cm^3 (should check MON: Mixed Oxides of Nitrogen)
rho_fuel = 1.01e-3; %kg/cm^3:(N2H4)

% 400 N bi-propellantAIRBUS thruster

%rho_fuel = 0.780e-3; % kg/cm^3 (MMH)
%rho_ox = 1.45e-3; % kg/cm^3 (N2O4)


%% Pressure losses

DP_inj = 0.3*P_ch; %(worst value)
DP_feed = 50e3; % worst value (depends on cross section of feeding lines)

%% Computations

DeltaV = 1800;
r = exp(DeltaV/(g0*Isp));
M0 = r*Mfin;
Mprop = M0*(1-1/r);

OF = rho_ox/rho_fuel;

Mfuel = Mprop/(1+OF);
Mox = Mprop-Mfuel;

Vox = Mox/rho_ox*10^-6; %m3
Vfuel = Mfuel/rho_fuel*10^-6;

%% Tanks sizing

P_tank = P_ch + DP_feed + DP_inj; %Pa

% Tank material
[rho_m,sigma_tum]=tankmaterial('Ti6Al4V'); %Ti6Al4V, Al2024T3, Stainless steel, Alloy steel 

% Spherical tanks
r_tank_S = ((3/4)*(Vox/pi))^(1/3); %m
t_tank_S = P_tank*r_tank_S/sigma_tum; %m
m_tank_S = rho_m*(4/3)*pi*((r_tank_S+t_tank_S)^3-r_tank_S^3); %kg

% Cylindrical tanks - consider r/h=1/3
r_tank_C = (Vox/(3*pi))^(1/3); %m
h_tank_C = 3*r_tank_C; %m
t_tank_C = P_tank*r_tank_C/(2*sigma_tum); %m
m_tank_C = rho_m*pi*((h_tank_C+t_tank_C)*(r_tank_C+t_tank_C)^2-h_tank_C*r_tank_C^2); %kg



% Tank materials
function [rho_m,sigma_tum]=tankmaterial(material)
switch material
    case 'Al2024T3' 
        rho_m = 2780; %kg/cc
        sigma_tum = 345e6; %Pa
    case 'Stainless steel'
        rho_m = 7850;
        sigma_tum = 673e6;
    case 'Alloy steel'
        rho_m = 7850;
        sigma_tum = 745e6;
    case 'Ti6Al4V'
        rho_m = 4433; %kg/cc
        sigma_tum = 950e6; %Pa
end
end