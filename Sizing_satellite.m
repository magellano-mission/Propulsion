%% Planetary secondary propulsion system sizing (chemical monoprop)

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

Temp= 293.15; %[K] tank temperature
prop = 'Hydrazine';
rho_prop=fuel_selection(prop,Temp)*1e3; %Hydrazine, MMH, H2O2 [kg/m3]

for k = 1:3
% Tsiolkovsky
        r = exp(Satellite.deltav(k)/(g0*Isp));
        M0 = r*Satellite.sat_masses(k); % satellite initial mass
        Mprop = M0*(1-1/r); %kg  propellant mass needed
        Satellite.Mprop_real(k) = Mprop*1.035; %margin of 3% of unusable propellant and 0.5 for loading uncertainty

% Tank volume estimation 

        Vprop = Satellite.Mprop_real(k)/rho_prop; 
        Vgi = Vprop/(B-1); % initial ullage volume
        Vb = 0.01*(Vprop+Vgi); % bladder volume
        Satellite.V_tank(k) = Vgi+Vprop + Vb;

% Tank mass estimation

% Tank material
        [rho_m,sigma_tum]=tankmaterial('Ti6Al4V'); %Ti6Al4V, Al2024T3, Stainless steel, Alloy steel 

% spherical
        Satellite.r_tank_S(k) = ((3/4)*(Satellite.V_tank(k)/pi))^(1/3); %m
        t_tank_S = Ptank_in*Satellite.r_tank_S(k)/sigma_tum; %m (intial pressure since worst condition)
        Satellite.Mtank_S(k) = rho_m*(4/3)*pi*((Satellite.r_tank_S(k)+t_tank_S)^3-Satellite.r_tank_S(k)^3);


% Pressurizing gas mass

        [gamma_pg,R_pg]=pressurant_selection('N'); %He, N

        Satellite.M_pressurizing(k) = Ptank_in*Vgi/(R_pg*Temp);

        %Pg_fin = Ptank_in*Vgi/(Vgi + Mprop/rho_prop);
end


