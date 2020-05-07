%% MONOPROPELLANT SIZING

clear; close all; clc

% Figure Initialization
set(0,'DefaultFigureUnits', 'normalized');
set(0,'DefaultFigurePosition',[0 0 1 1]);
set(0,'DefaultTextFontSize',18);
set(0,'DefaultAxesFontSize',18);
set(0,'DefaultAxesXGrid','on')
set(0,'DefaultAxesYGrid','on')
set(0,'defaultLegendInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');

%% Engine data (111G Aerojet Rocketdyne) https://rocket.com/sites/default/files/documents/In-Space%20Data%20Sheets%204.8.20.pdf

Isp = 224;
g0 = 9.807;

% Initial and final feed pressure
Pfeed_in = 24.1e5; %[Pa]
Pfeed_fin = 6.7e5; %[Pa]

%% Tank Pressures
%Taking into account losses

Ptank_in = Pfeed_in + 0.3*Pfeed_in + 50e3;
Ptank_fin = Pfeed_fin + 0.3*Pfeed_fin + 50e3;

B = Ptank_in/Ptank_fin; % blowdown ratio

%% Propellant mass

% Delta v
deltav_oraising = 0; %done by the stack
deltav_phasing = 15; %[m/s]
deltav_SK = 50*10; %[m/s]
deltav_EoL = 200; %[m/s] CHECK
deltav = (deltav_oraising + deltav_phasing + deltav_SK + deltav_EoL)*1.3; % 30% margin

Msat = 300; %[kg] satellite dry mass (without propellant)
Temp= 293.15; %[K] tank temperature
prop = 'Hydrazine';
rho_prop=fuel_selection(prop,Temp)*1e3; %Hydrazine, MMH, H2O2 [kg/m3]

% Tsiolkovsky
r = exp(deltav/(g0*Isp));
M0 = r*Msat; % satellite initial mass
Mprop = M0*(1-1/r); %kg  propellant mass needed

Mprop_real = Mprop*1.035; %margin of 3% of unusable propellant and 0.5 for loading uncertainty

%% Tank volume estimation 

Vprop = Mprop_real/rho_prop; 

Vgi = Vprop/(B-1); % initial ullage volume
Vb = 0.01*(Vprop+Vgi); % bladder volume
V_tank = Vgi+Vprop + Vb;

%% Tank mass estimation

% Tank material
[rho_m,sigma_tum]=tankmaterial('Ti6Al4V'); %Ti6Al4V, Al2024T3, Stainless steel, Alloy steel 

% spherical
r_tank_S = ((3/4)*(V_tank/pi))^(1/3); %m
t_tank_S = Ptank_in*r_tank_S/sigma_tum; %m (intial pressure since worst condition)
Mtank_S = rho_m*(4/3)*pi*((r_tank_S+t_tank_S)^3-r_tank_S^3);


%% Pressurizing gas mass

[gamma_pg,R_pg]=pressurant_selection('N'); %He, N

M_pressurizing = Ptank_in*Vgi/(R_pg*Temp);

Pg_fin = Ptank_in*Vgi/(Vgi + Mprop/rho_prop);
