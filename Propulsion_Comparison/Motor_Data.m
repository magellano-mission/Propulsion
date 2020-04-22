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
motors(2).isp = 223;        %[s] steady state 222 - 225

motors(3).name = 'NEXT';    %Aerojet Rocketdyne, flew on DART mission
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
motors(4).isp = 225;        %[s] 200 - 225

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

motors(7).name = 'T6';    %QinetiQ T6 gridded ion thruster, flew on Bepi Colombo
motors(7).class = 'ion';
motors(7).prop = 'xenon';
motors(7).prop_dens = 1598; %[kg/m3] from BepiColombo tank pressure (150 bar)
motors(7).thrust_max = 0.23;    %[N]
motors(7).thrust_min = 0.024;
motors(7).power_max = 5000; %[W]
motors(7).power_min = 500;
motors(7).mass = 8.5;       %[kg] 
motors(7).isp = 4000;        %[s]

motors(8).name = 'T5';    %QinetiQ T5 gridded ion thruster, flew on GOCE
motors(8).class = 'ion';
motors(8).prop = 'xenon';
motors(8).prop_dens = 1598; %[kg/m3] from BepiColombo tank pressure (150 bar)
motors(8).thrust_max = 0.02;    %[N]
motors(8).thrust_min = 0.001;
motors(8).power_max = 585; %[W]
motors(8).power_min = 55;
motors(8).mass = 2;       %[kg] 
motors(8).isp = 3500;        %[s]

motors(9).name = 'BHT-8000';    %Busek BHT-8000 Thruster operating @ 800V
motors(9).class = 'hall effect';
motors(9).prop = 'xenon';       %also iodine or krypton possible
motors(9).prop_dens = 1598;     %[kg/m3] from BepiColombo tank pressure (150 bar)
motors(9).thrust_max = 0.325;    %[N]
motors(9).thrust_min = 4/10 * 0.325;
motors(9).power_max = 10000; %[W]
motors(9).power_min = 4000;
motors(9).mass = 25.4;       %[kg] 
motors(9).isp = 3060;        %[s]

motors(10).name = 'BHT-1500';    %Busek BHT-1500 Thruster operating in high Isp mode
motors(10).class = 'hall effect';
motors(10).prop = 'xenon';       %also iodine or krypton possible
motors(10).prop_dens = 1598;     %[kg/m3] from BepiColombo tank pressure (150 bar)
motors(10).thrust_max = 0.154;    %[N]
motors(10).thrust_min = 0.058;
motors(10).power_max = 2700; %[W]
motors(10).power_min = 1000;
motors(10).mass = 7.1;       %[kg] 
motors(10).isp = 2030;        %[s]
