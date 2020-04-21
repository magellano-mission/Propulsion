function[motors] = Motor_Data()
%Enter data about the motor using the same format as previous examples -
% .class and .prop information will be used for filtering so be sure to copy
% exactly the strings from previous similar motors

motors(1).name = 'MR-103G';  %Aerojet Rocketdyne
motors(1).class = 'chemical monoprop';
motors(1).prop = 'hydrazine';
motors(1).prop_dens = 1005; %[kg/m3]
motors(1).thrust_max = 1.13;    %[N]
motors(1).thrust_min = 0.19;    %[N]
motors(1).power_max = 8.25 + 1.54 + 6.32; %[W] valve + valve heater + cat bed heater
motors(1).power_min = motors(1).power_max;
motors(1).mass = 0.33;       %[kg] engine + valve + heaters
motors(1).isp = 215;        %[s] steady state 202 - 224

motors(2).name = 'MR-107T';  %Aerojet Rocketdyne
motors(2).class = 'chemical monoprop';
motors(2).prop = 'hydrazine';
motors(2).prop_dens = 1005; %[kg/m3]
motors(2).thrust_max = 125;    %[N]
motors(2).thrust_min = 54;    %[N]
motors(2).power_max = 34.8 + 4 + 13.2; %[W] valve + valve heater + cat bed heater
motors(2).power_min = motors(2).power_max;
motors(2).mass = 1.01;       %[kg] engine + valve + heaters
motors(2).isp = 224;        %[s] steady state 222 - 225

motors(3).name = 'NEXT';    %Aerojet Rocketdyne
motors(3).class = 'ion';
motors(3).prop = 'xenon';
motors(3).prop_dens = 1598; %[kg/m3] from BepiColombo tank pressure (150 bar)
motors(3).thrust_max = 0.235;    %[N]
motors(3).thrust_min = 600/6900 * 0.235;
motors(3).power_max = 6900; %[W] 600 - 6900
motors(3).power_min = 600;
motors(3).mass = 13.3;       %[kg] 
motors(3).isp = 4100;        %[s]

motors(4).name = 'MR-80B';    %Aerojet Rocketdyne
motors(4).class = 'chemical monoprop';
motors(4).prop = 'hydrazine';
motors(4).prop_dens = 1005; %[kg/m3]
motors(4).thrust_max = 3603;    %[N]
motors(4).thrust_min = 31;
motors(4).power_max = 8+9.45+6.3; %[W]
motors(4).power_min = motors(4).power_max;
motors(4).mass = 8.51;       %[kg] engine + valve + heaters
motors(4).isp = 215;        %[s] 200 - 225

motors(5).name = 'R-40B';    %Aerojet Rocketdyne
motors(5).class = 'chemical biprop';
motors(5).prop = 'MMH/NTO';
motors(5).prop_dens = 950; %[kg/m3] NEED TO CHECK
motors(5).thrust_max = 4000;    %[N]
motors(5).thrust_min = 4000;
motors(5).power_max = 70; %[W] Valve Power
motors(5).power_min = motors(5).power_max;
motors(5).mass = 10.5;       %[kg] engine + valve
motors(5).isp = 293;        %[s]

motors(6).name = 'Custom';  %Lyle
motors(6).class = 'nuclear thermal';
motors(6).prop = 'liquid H2';
motors(6).prop_dens = 70; %[kg/m3] NEED TO CHECK
motors(6).thrust_max = 5000;    %[N]
motors(6).thrust_min = 1000;
motors(6).power_max = 500; %[W] Power
motors(6).power_min = motors(5).power_max;
motors(6).mass = 100;       %[kg] engine excl 
motors(6).isp = 900;        %[s]