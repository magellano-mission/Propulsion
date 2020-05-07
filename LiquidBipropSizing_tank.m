%% LIQUID BIPROP SIZING

clear all; close all; clc

%% Initial data
% MOOG - Leros 1b
g0 = 9.807;
Isp = 318; %s
T = 420; %N
m_dot = T/(Isp*g0);
P_ch = 1.62e6; %235 psia

Mfin = 6*300+1*800; % mass of a stack

%% Storage temperature
Temp= 293.15;

% Fuel
rho_fuel=fuel_selection('MMH',Temp)*1e3; %MMH, Hydrazine [kg/m3]

% Oxidizer
rho_ox=ox_selection('N2O4',Temp)*1e3; %N2O4, MON-1, MON-2, MON-3, Hydrazine [kg/m3]

%% Computations

DeltaV = 1800;
r = exp(DeltaV/(g0*Isp));
M0 = r*Mfin;
Mprop = M0*(1-1/r); %kg

OF = rho_ox/rho_fuel;

Mfuel = Mprop/(1+OF);
Mox = Mprop-Mfuel;

Vox = Mox/rho_ox; %m3 (margined 3%)
Vfuel = Mfuel/rho_fuel; %m3 (margined 3%)

%% Pressure losses

DP_inj = 0.3*P_ch; %(worst value)
DP_feed = 50e3; % worst value (depends on cross section of feeding lines)

%% Tanks sizing

P_tank = P_ch + DP_feed + DP_inj; %Pa

% Tank material
[rho_m,sigma_tum]=tankmaterial('Ti6Al4V'); %Ti6Al4V, Al2024T3, Stainless steel, Alloy steel 

% Spherical tanks
r_tank_S = ((3/4)*(1.03*Vox/pi))^(1/3); %m
t_tank_S = P_tank*r_tank_S/sigma_tum; %m
m_tank_S = rho_m*(4/3)*pi*((r_tank_S+t_tank_S)^3-r_tank_S^3); %kg

% Cylindrical tanks - consider r/h=1/3
r_tank_C = (1.03*Vox/(3*pi))^(1/3); %m
h_tank_C = 3*r_tank_C; %m
t_tank_C = P_tank*r_tank_C/(2*sigma_tum); %m
m_tank_C = rho_m*pi*((h_tank_C+t_tank_C)*(r_tank_C+t_tank_C)^2-h_tank_C*r_tank_C^2); %kg

%% Pressurisation system
[gamma_pg,R_pg]=pressurant_selection('He'); %He, N
[rho_mpg,sigma_tumpg]=tankmaterial('Ti6Al4V');
% Assume:
Pi_pg = 10*P_tank;
T_pg = 300; %K
Pf_pg = P_tank;

m_pg = gamma_pg*P_tank*1.03*(Vfuel+Vox)/(R_pg*T_pg*(1-Pf_pg/Pi_pg));
V_pg = m_pg*R_pg*T_pg/Pi_pg;
m_tankpg = 3*rho_mpg*Pi_pg*V_pg/(2*sigma_tumpg);

% ITERATIVE PROCEDURE: 1 TANK CASE
% Pi_pg = 10*P_tank; Pf_pg = P_tank;
% Ti_pg = 300; %K
% Vt = Vox+Vfuel;
% Tf_pg = Ti_pg*(Pf_pg/Pi_pg)^((gamma_pg-1)/gamma_pg);
% Vi_pg = 0; toll = 0.01; err = toll + 1;
% while err > toll
%     Vf_pg = Vi_pg + Vt;
%     m_pg = Pf_pg*Vf_pg/(R_pg*Tf_pg);
%     Vi_pgnew = m_pg*R_pg*Ti_pg/Pi_pg;
%     err = abs(Vi_pgnew-Vi_pg)/Vi_pg;
%     Vi_pg = Vi_pgnew;
% end
% Mpressurant = 1.05*m_pg; %safety factor
% Vpressurant = Mpressurant*R_pg*Ti_pg/Pi_pg;

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