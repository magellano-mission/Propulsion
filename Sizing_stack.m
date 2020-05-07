%%% Interplanetary primary propulsion system sizing (chemical monoprop)
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
%% Data
g0 = 9.807;
% dv needed (capture+TCM+margin 30%)
dv_capture = 1800; %m/s
dv_TCMs = 100; %m/s
dv = 1.3*(dv_capture+dv_TCMs);
% Engine S-400-15 (Ariane)
Isp = 318; %s
T = 420; %N
Pc = 10e5; %Pa
%MMH+N2O4
mdot = T/(Isp*g0);
% Propellant
Temp= 293.15; %[K]
rho_fuel=fuel_selection('Hydrazine',Temp)*1e3; %[kg/m3]
rho_ox=ox_selection('N2O4',Temp)*1e3; %[kg/m3]
% Stack properties (30% mass margin)
Stack = struct();
mNS = 200; mRS = 200; mECS = 600; mstack = 200;
Stack.Mstack = [4*mRS*1.3 + mstack; 
                10*mNS*1.3 + mstack;
                5*mNS*1.3 + mstack;
                3*mECS*1.3 + mstack];

%% Propellant
r = exp(dv/(g0*Isp));
for k=1:4
    Mst = Stack.Mstack(k);         Stack.mass(k) = Mst;
    M0 = r*Mst;
    Mprop = M0*(1-1/r);      
    OF = rho_ox/rho_fuel;
    Mfuel = Mprop/(1+OF);    
    Mox = Mprop-Mfuel;
    Vox = 1.03*Mox/rho_ox; %m3 (margined 3%)
    Vfuel = 1.03*Mfuel/rho_fuel; %m3 (margined 3%)
    Stack.Mfuel(k) = Mfuel; Stack.Mox(k) = Mox;
    Stack.Vfuel(k) = Vfuel; Stack.Vox(k) = Vox;
end

%% Propellant tank sizinf

DP_inj = 0.3*Pc; %(worst value)
DP_feed = 50e3; % worst value (depends on cross section of feeding lines)
P_tank = Pc + DP_feed + DP_inj; %Pa

% Tank material
tankmat = 'Ti6Al4V';
[rho_m,sigma_tum]=tankmaterial(tankmat); %Ti6Al4V, Al2024T3, Stainless steel, Alloy steel 

% Spherical tanks
Stack.tankprop = struct(); Stack.tankprop.material = tankmat; Stack.tankprop.P = P_tank;
for k=1:4
    Stack.tankprop.r(k) = ((3/4)*(Stack.Vox(k)/pi))^(1/3); %m
    Stack.tankprop.t(k) = P_tank*r/sigma_tum; %m
    Stack.tankprop.m(k) = rho_m*(4/3)*pi*((Stack.tankprop.r(k)+Stack.tankprop.t(k))^3-Stack.tankprop.r(k)^3); %kg
end

%% Pressurisation system
pressurant = 'He';
[gamma_pg,R_pg] = pressurant_selection(pressurant); %He, N
[rho_mpg,sigma_tumpg] = tankmaterial('Ti6Al4V');
% Assume:
Pi_pg = 10*P_tank;
T_pg = 300; %K
Pf_pg = P_tank;
Stack.pressurant = struct();   Stack.pressurant.type = pressurant;
Stack.pressurant.R = R_pg;     Stack.pressurant.gamma = gamma_pg;
Stack.pressurant.Pi = Pi_pg;   Stack.pressurant.T = T_pg;
for k=1:4
    Stack.pressurant.m(k) = gamma_pg*P_tank*(Stack.Vfuel(k)+Stack.Vox(k))/(R_pg*T_pg*(1-Pf_pg/Pi_pg));
    Stack.pressurant.V(k) = Stack.pressurant.m(k)*R_pg*T_pg/Pi_pg;
    Stack.pressurant.rtank(k) = ((3/4)*(Stack.Vox(k)/pi))^(1/3); %m
    Stack.pressurant.ttank(k) = P_tank*r/sigma_tum; %m
    Stack.pressurant.mtank(k) = 3*rho_mpg*Pi_pg*Stack.pressurant.V(k)/(2*sigma_tumpg);
end

%% Useful functions
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