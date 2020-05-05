%%% Planetary primary propulsion system sizing (chemical monoprop)
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

%% Input data
% Delta v
deltav_oraising = 0; %done by the stack
deltav_phasing = 15; %[m/s]
deltav_SK = 50*10; %[m/s]
deltav_EoL = 200; %[m/s] CHECK
deltav = (deltav_oraising + deltav_phasing + deltav_SK + deltav_EoL)*1.3; % 30% margin
% Engine data (111G Aerojet Rocketdyne) https://rocket.com/sites/default/files/documents/In-Space%20Data%20Sheets%204.8.20.pdf
g0 = 9.807;
Isp = 224; %[s]
Itot = 262000;
T = 3; %[N] (nominal), thrust range: 4.9-1.8
m_dot = T/(Isp*g0);
P_ch = 10e5; %[Pa]
% Satellite properties
Msat = 300; %[kg]
% Propellant
Temp= 293.15; %[K]
prop = 'Hydrazine';
rho_prop=ox_selection(prop,Temp)*1e3; %N2O4, MON-1, MON-2, MON-3, Hydrazine [kg/m3]

%% Propellant mass and volume
% Tsiolkovsky
r = exp(deltav/(g0*Isp));
M0 = r*Msat;
Mprop = M0*(1-1/r); %kg
Vprop = Mprop/rho_prop;


%% Tanks sizing
% Pressure losses
DP_inj = 0.3*P_ch; %(worst value)
DP_feed = 50e3; % worst value (depends on cross section of feeding lines)
% Tank pressure
P_tank = P_ch + DP_feed + DP_inj; %Pa
% Tank material
[rho_m,sigma_tum]=tankmaterial('Ti6Al4V'); %Ti6Al4V, Al2024T3, Stainless steel, Alloy steel 
% Pressurant properties
[gamma_pg,R_pg]=pressurant_selection('N'); %He, N
Pi_pg = 10*P_tank;
%%%
Ntank = 1; %1: prop+press together, 2: prop, press
switch Ntank
    case 1
        Pf_pg = P_tank;
        Mpressurant = gamma_pg*P_tank*(Vprop)/(R_pg*Temp*(1-Pf_pg/Pi_pg));
        Vpressurant = Mpressurant*R_pg*Temp/Pi_pg;
        Vtot = Vpressurant + 1.03*Vprop;
        r_tank_S = ((3/4)*(1.03*Vprop/pi))^(1/3); %m
        t_tank_S = P_tank*r_tank_S/sigma_tum; %m
        Mtank_S = rho_m*(4/3)*pi*((r_tank_S+t_tank_S)^3-r_tank_S^3);
        Msys = Msat+Mprop+Mpressurant+Mtank_S
    case 2
        T_pg = 300; %K
        Pf_pg = P_tank;
        Mpressurant = gamma_pg*P_tank*(Vprop)/(R_pg*T_pg*(1-Pf_pg/Pi_pg));
        Vpressurant = Mpressurant*R_pg*T_pg/Pi_pg;
        % Spherical tanks
        r_tank_S = ((3/4)*(1.03*Vprop/pi))^(1/3); %m
        t_tank_S = P_tank*r_tank_S/sigma_tum; %m
        Mtank_S = rho_m*(4/3)*pi*((r_tank_S+t_tank_S)^3-r_tank_S^3); %kg
        Mtankpressurant = 3*rho_m*Pi_pg*Vpressurant/(2*sigma_tum);
        Msys = Msat+Mprop+Mpressurant+Mtank_S+Mtankpressurant
end
%% Useful functions
% Tank materials
function [rho_m,sigma_tum]=tankmaterial(material)
switch material
    case 'Al2024T3' 
        rho_m = 2780; %kg/m3
        sigma_tum = 345e6; %Pa
    case 'Stainless steel'
        rho_m = 7850;
        sigma_tum = 673e6;
    case 'Alloy steel'
        rho_m = 7850;
        sigma_tum = 745e6;
    case 'Ti6Al4V'
        rho_m = 4430; %kg/m3
        sigma_tum = 950e6; %Pa
end
end

% Oxidizer
function [rho_ox]=ox_selection(oxidizer,Temp)
switch oxidizer
    case 'N2O4' 
        rho_ox = 2.066 - 1.979e-3*Temp -4.826e-7*Temp^2; % g/cc
    case 'MON-1'
        rho_ox = 2.066 - 1.979e-3*Temp -4.826e-7*Temp^2; % g/cc
    case 'MON-2'
        rho_ox = 2.066 - 1.979e-3*Temp -4.826e-7*Temp^2; % g/cc
    case 'MON-3'
        rho_ox = 2.066 - 1.979e-3*Temp -4.826e-7*Temp^2; % g/cc
    case 'Hydrazine'
        rho_ox = 1.23078 -6.2668e-4*Temp - 4.5284e-7*Temp^2; % g/cc
end
end

% Fuel
function [rho_fuel]=fuel_selection(fuel,Temp)
switch fuel
    case 'Hydrazine'
        rho_fuel = 1.23078 -6.2668e-4*Temp - 4.5284e-7*Temp^2; % g/cc
    case 'MMH'
        rho_fuel = 1.15034-9.3949e-4*Temp; % g/cc
end
end

% Pressurant
function [gamma_pg,R_pg]=pressurant_selection(pressurant)
switch pressurant
    case 'He'
        gamma_pg = 1.667;
        R_pg = 2.08e3; %J/kgK
    case 'N'
        gamma_pg = 1.4;
        R_pg = 0.297e3;
end
end