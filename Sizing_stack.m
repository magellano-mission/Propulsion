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
Stack = struct();
% dv needed (capture+TCM+margin 30%)
dv_capture = 1800; %m/s
dv_TCMs = 100; %m/s
dv_oraisingNS = 290; %m/s
dv_oraisingECS = 150; %m/s (TBD)
%%% LAUNCH STRATEGY:
%    L1: 12 NS
%    L2: 6 NS, 5 RS, 2 ECS
dv = 1.3*[dv_capture+dv_TCMs+dv_oraisingNS;
          dv_capture+dv_TCMs+dv_oraisingNS;
          dv_capture+dv_TCMs;
          dv_capture+dv_TCMs+dv_oraisingECS];
% Stack properties (30% mass margin)
mNS = 200; mRS = 200; mECS = 600; mstack = 0; %TBD
Stack.Mstack = [12*mNS + mstack; 
                6*mNS + mstack;
                5*mRS + mstack;
                2*mECS + mstack]*1.3;
Stack.dv = dv;
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

%% Propellant
r = exp(dv/(g0*Isp));
% Ullage (3%) considered
for k=1:4
    Mst = Stack.Mstack(k);         Stack.mass(k) = Mst;
    M0 = r(k)*Mst;
    Mprop = M0*(1-1/r(k));
    OF = rho_ox/rho_fuel;
    Mfuel = Mprop/(1+OF);    
    Mox = Mprop-Mfuel;
    Vox = 1.03*Mox/rho_ox; %m3
    Vfuel = 1.03*Mfuel/rho_fuel; %m3
    Stack.Mfuel(k) = Mfuel; Stack.Mox(k) = Mox;
    Stack.Vfuel(k) = Vfuel; Stack.Vox(k) = Vox;
end

%% Propellant tank sizing

DP_inj = 0.3*Pc; %(worst value)
DP_feed = 50e3; % worst value (depends on cross section of feeding lines)
P_tank = Pc + DP_feed + DP_inj; %Pa

% Tank material
tankmat = 'CFRP+Al';
[rho_m,sigma_tum]=tankmaterial(tankmat); %Ti6Al4V, Al2024T3, Stainless steel, Alloy steel, CFRP+Al

% Tanks
Stack.tankprop = struct(); Stack.tankprop.geometry = 'Cylinder'; %'Sphere' or 'Cylinder'
Stack.tankprop.material = tankmat; Stack.tankprop.P = P_tank;
% Bladder considered (1%)
for k=1:4
    switch Stack.tankprop.geometry
        case 'Sphere'
            Stack.tankprop.V(k) = 1.01*max(Stack.Vox(k),Stack.Vfuel(k));
            Stack.tankprop.r(k) = ((3/4)*(Stack.tankprop.V(k)/pi))^(1/3); %m
            Stack.tankprop.t(k) = P_tank*r/sigma_tum; %m
            Stack.tankprop.m(k) = rho_m*(4/3)*pi*((Stack.tankprop.r(k)+Stack.tankprop.t(k))^3-Stack.tankprop.r(k)^3);%kg
        case 'Cylinder'    
            Stack.tankprop.V(k) = 1.01*max(Stack.Vox(k),Stack.Vfuel(k));
            Stack.tankprop.r(k) = (Stack.tankprop.V(k)/(3*pi))^(1/3); %m
            Stack.tankprop.h(k) = 3*Stack.tankprop.r(k); %m
            Stack.tankprop.t(k) = P_tank*Stack.tankprop.r(k)/(2*sigma_tum); %m
            Stack.tankprop.m(k) = rho_m*pi*((Stack.tankprop.h(k)+Stack.tankprop.t(k))*(Stack.tankprop.r(k)+Stack.tankprop.t(k))^2-Stack.tankprop.h(k)*Stack.tankprop.r(k)^2); %kg
    end
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
    Stack.pressurant.ttank(k) = P_tank*r(k)/sigma_tum; %m
    Stack.pressurant.mtank(k) = 3*rho_mpg*Pi_pg*Stack.pressurant.V(k)/(2*sigma_tumpg);
end