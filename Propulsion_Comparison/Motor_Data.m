function[motors] = Motor_Data()
%Enter data about the motor using the same format as previous examples -
% .class and .prop information will be used for filtering so be sure to copy
% exactly the strings from previous similar motors
g0 = 9.81;

motors(1).name = 'MR-103G';  %Aerojet Rocketdyne
motors(1).class = 'chemical monoprop';
motors(1).prop = 'hydrazine';
motors(1).prop_dens = 1005; %[kg/m3]
motors(1).thrust = 1.13;    %[N] 0.19 - 1.13
motors(1).power = 8.25 + 1.54 + 6.32; %[W] valve + valve heater + cat bed heater
motors(1).mass = 0.33;       %[kg] engine + valve + heaters
motors(1).isp = 224;        %[s] steady state 202 - 224
motors(1).mdot = motors(1).thrust / (g0 * motors(1).isp);

motors(2).name = 'MR-107T';  %Aerojet Rocketdyne
motors(2).class = 'chemical monoprop';
motors(2).prop = 'hydrazine';
motors(2).prop_dens = 1005; %[kg/m3]
motors(2).thrust = 125;    %[N] 54 - 125
motors(2).power = 34.8 + 4 + 13.2; %[W] valve + valve heater + cat bed heater
motors(2).mass = 1.01;       %[kg] engine + valve + heaters
motors(2).isp = 225;        %[s] steady state 222 - 225
motors(2).mdot = motors(2).thrust / (g0 * motors(2).isp);

motors(3).name = 'NEXT (Max Thrust)';    %Aerojet Rocketdyne
motors(3).class = 'ion';
motors(3).prop = 'xenon';
motors(3).prop_dens = 1598; %[kg/m3] from BepiColombo tank pressure (150 bar)
motors(3).thrust = 0.235;    %[N] 54 - 125
motors(3).power = 6900; %[W] 600 - 6900
motors(3).mass = 13.3;       %[kg] 
motors(3).isp = 4100;        %[s] steady state 222 - 225
motors(3).mdot = motors(3).thrust / (g0 * motors(3).isp);

motors(4).name = 'MR-80B';    %Aerojet Rocketdyne
motors(4).class = 'chemical monoprop';
motors(4).prop = 'hydrazine';
motors(4).prop_dens = 1005; %[kg/m3]
motors(4).thrust = 3100;    %[N] 31 - 3603
motors(4).power = 8+9.45+6.3; %[W] 
motors(4).mass = 8.51;       %[kg] engine + valve + heaters
motors(4).isp = 225;        %[s] 200 - 225
motors(4).mdot = motors(4).thrust / (g0 * motors(4).isp);

motors(5).name = 'R-40B';    %Aerojet Rocketdyne
motors(5).class = 'chemical biprop';
motors(5).prop = 'MMH/NTO';
motors(5).prop_dens = 950; %[kg/m3] NEED TO CHECK
motors(5).thrust = 4000;    %[N]
motors(5).power = 70; %[W] Valve Power
motors(5).mass = 10.5;       %[kg] engine + valve + heaters
motors(5).isp = 293;        %[s] 200 - 225
motors(5).mdot = motors(5).thrust / (g0 * motors(5).isp);