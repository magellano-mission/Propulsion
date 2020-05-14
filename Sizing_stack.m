%% Interplanetary primary propulsion system sizing (chemical biprop)
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
dv_captureSM1 = 1730; %m/s
dv_captureSM2 = 1710; %m/s
dv_captureSM3 = 1820; %m/s
dv_captureSM4 = 1890; %m/s
dv_TCMs = 315; %m/s
dv_oraisingNS1 = 50; dv_oraisingNS2 = 150; 
dv_oraisingECS = 180; %m/s (TBD)
dv_EoLstack = 200; %m/s
%%% LAUNCH STRATEGY:
%    L1: 6 NS + 6 NS
%    L2: 6 NS + 5 RS, 2 ECS
% 30% margin on dv
dv = 1.3*[dv_captureSM1+dv_TCMs+dv_oraisingNS1;
          dv_captureSM2+dv_TCMs+dv_oraisingNS2;
          dv_captureSM3+dv_TCMs;
          dv_captureSM4+dv_TCMs];
% Stack properties (30% mass margin)
mNS = 250; mRS = 150; mECS = 600; m_servmod = 800; %TBD
Stack.Mdry = [6*mNS + m_servmod;
              6*mNS + m_servmod; 
              6*mNS + m_servmod;
              5*mRS + 2*mECS + m_servmod];
Stack.dv = dv;
% Engine 
Isp = 320; %s
T = 890; %N
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
MpropEOL=zeros(1,4); MfuelEOL=zeros(1,4); MoxEOL=zeros(1,4); VfuelEOL=zeros(1,4); VoxEOL=zeros(1,4);
for k=1:4
    Mst = Stack.Mdry(k);         Stack.mass(k) = Mst;
    M0 = r(k)*Mst;
    Mprop = M0*(1-1/r(k));
    OF = rho_ox/rho_fuel;
    Mfuel = Mprop/(1+OF);    
    Mox   = Mprop-Mfuel;
    Vox   = 1.035*Mox/rho_ox; %m3
    Vfuel = 1.035*Mfuel/rho_fuel; %m3
    Stack.Mfuel(k) = Vfuel*rho_fuel; Stack.Mox(k) = Vox*rho_ox;
    Stack.Vfuel(k) = Vfuel; Stack.Vox(k) = Vox;
    if k==4
        r4 = exp((dv_oraisingECS)/(g0*Isp));
        M4 = r4*(2*mECS+m_servmod);
        Mprop = M4*(1-1/r4);
        OF = rho_ox/rho_fuel;
        Mfuel = Mprop/(1+OF);    
        Mox = Mprop-Mfuel;
        Vox = 1.035*Mox/rho_ox; %m3
        Vfuel = 1.035*Mfuel/rho_fuel; %m3
        Stack.Mfuel(k) = Vfuel*rho_fuel+Stack.Mfuel(k); 
        Stack.Mox(k) = Vox*rho_ox+Stack.Mox(k);
        Stack.Vfuel(k) = Vfuel+Stack.Vfuel(k); 
        Stack.Vox(k) = Vox+Stack.Vox(k);
    end
    rEOL = exp((dv_EoLstack)/(g0*Isp));
    MEOL = rEOL*(m_servmod);
    OFEOL = rho_ox/rho_fuel;
    MpropEOL(k) = MEOL*(1-1/rEOL);
    MfuelEOL(k) = MpropEOL(k)/(1+OFEOL);    
    MoxEOL(k)   = MpropEOL(k)-MfuelEOL(k);
    VoxEOL(k)   = 1.035*MoxEOL(k)/rho_ox; %m3
    VfuelEOL(k) = 1.035*MfuelEOL(k)/rho_fuel; %m3
    Stack.Mfuel(k) = VfuelEOL(k)*rho_fuel + Stack.Mfuel(k); 
    Stack.Mox(k)   = VoxEOL(k)*rho_ox + Stack.Mox(k);
    Stack.Vfuel(k) = VfuelEOL(k) + Stack.Vfuel(k); 
    Stack.Vox(k)   = VoxEOL(k) + Stack.Vox(k);
    Stack.Mprop(k) = Stack.Mfuel(k) + Stack.Mox(k);
end

Stack.Mstack = Stack.Mdry + Stack.Mfuel' + Stack.Mox'; % initial mass stack
Stack.Mlaunch = 1.2*Stack.Mstack; % margin for launcher

%% Propellant tank sizing

DP_inj = 0.3*Pc; %(worst value)
DP_feed = 50e3; % worst value (depends on cross section of feeding lines)
P_tank = Pc + DP_feed + DP_inj; %Pa

% Tank material
tankmat = 'Ti6Al4V';
[rho_m,sigma_tum]=tankmaterial(tankmat); %Ti6Al4V, Al2024T3, Stainless steel, Alloy steel, CFRP+Al

% Tanks
Stack.tankprop = struct(); Stack.tankprop.geometry = 'Sphere'; %'Sphere' or 'Cylinder'
Stack.tankprop.material = tankmat; Stack.tankprop.P = P_tank;
% Bladder considered (1%)
for k=1:4
    switch Stack.tankprop.geometry
        case 'Sphere'
            Stack.tankprop.V(k) = max(Stack.Vox(k),Stack.Vfuel(k));
            Stack.tankprop.r(k) = ((3/4)*(Stack.tankprop.V(k)/pi))^(1/3); %m
            Stack.tankprop.t(k) = P_tank*Stack.tankprop.r(k)/sigma_tum; %m
            Stack.tankprop.m(k) = rho_m*(4/3)*pi*((Stack.tankprop.r(k)+Stack.tankprop.t(k))^3-Stack.tankprop.r(k)^3);%kg
        case 'Cylinder'    
            Stack.tankprop.V(k) = max(Stack.Vox(k),Stack.Vfuel(k));
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
    Stack.pressurant.rtank(k) = ((3/4)*(Stack.pressurant.V(k)/pi))^(1/3); %m
    Stack.pressurant.ttank(k) = P_tank*Stack.pressurant.rtank(k)/sigma_tum; %m
    Stack.pressurant.mtank(k) = rho_mpg*(4/3)*pi*((Stack.pressurant.rtank(k)+Stack.pressurant.ttank(k))^3-Stack.pressurant.rtank(k)^3);
end
%% Launch masses
Stack.launch = struct();
    Stack.launch.mass(1) = Stack.Mstack(1)+Stack.Mstack(2);
    Stack.launch.mass(2) = Stack.Mstack(3)+Stack.Mstack(4);
% Launch Vehicle Adapter (LVA)
Stack.launch.MLVA = 0.0755.*Stack.launch.mass + 50.252;

Stack.launch.Mlaunch = 1.2.*(Stack.launch.mass+Stack.launch.MLVA);