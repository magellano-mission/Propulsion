%% Electric propulsive system dimensioning

clear all, close all, clc

%% Propellant mass
g0 = 9.087;

% Delta v
deltav_phasing_NS = 1.4*3; %[m/s]
deltav_phasing_RS = 1.1*2; %[m/s]
deltav_SK_NS = 3*10; %[m/s]
deltav_SK_RS = 5*10; %[m/s]
deltav_EoL = 200; %[m/s] CHECK
deltav_NS = (deltav_phasing_NS + deltav_SK_NS + deltav_EoL)*1.3; % 30% margin
deltav_RS = (deltav_phasing_RS + deltav_SK_RS + deltav_EoL)*1.3; % 30% margin

mNS = 250; mRS = 150; mECS = 600; %TBD dry mass (no propellant)

Satellite = struct();
Satellite.sat_masses = [mNS, mRS, mECS];
Satellite.deltav = [deltav_NS, deltav_RS, deltav_RS];

% engine - UK-10
T = 10e-3; % [N] thrust
P = 0.27e3; % [W] power
Is = 3000; % [s] specific impulse
m_engine = 1.8; % [kg] mass of engine (also with PPU?)
m_PPU = 7; % [kg] weight of the proposed PPU
% https://www2.l3t.com/edd/pdfs/datasheets/EP_Thrusters-XIPS_PPU%20Overview%20datasheet.pdf

for k = 1:3

    MR = exp(Satellite.deltav(k)/(Is*g0));
    Satellite.mprop(k) = Satellite.sat_masses(k)-Satellite.sat_masses(k)/MR; % [kg]

    % tank sizing (Xe)

    R_Xe = 63.33;
    Press = 19e6; % [Pa] MEOP
    Temp = 273.15+55; %[K];
    rho = Press/(R_Xe*Temp);
    V_Xe = Satellite.mprop(k)/rho; % [m^3] volume of xenon
    [rho_tank,sigma_tank]=tankmaterial('Ti6Al4V');
    Satellite.r_tank_Xe(k) = ((3/4)*(1.03*V_Xe/pi))^(1/3); % m
    t_tank_Xe = Press*Satellite.r_tank_Xe(k)/sigma_tank; % m
    Satellite.m_tank_Xe(k) = rho_tank*(4/3)*pi*((Satellite.r_tank_Xe(k)+t_tank_Xe)^3-Satellite.r_tank_Xe(k)^3); %kg
    Satellite.m_electrictot(k) = Satellite.m_tank_Xe(k) + Satellite.mprop(k) + m_PPU + m_engine;
end


