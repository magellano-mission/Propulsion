function[motors] = Motor_Data()
%Enter data about the motor using the same format as previous examples -
% .class and .prop information will be used for filtering so be sure to copy
% exactly the strings from previous similar motors

motors(1).name = 'MR-103G';  %Aerojet Rocketdyne
motors(1).class = 'chemical monoprop';
motors(1).prop = 'hydrazine';
motors(1).prop_dens = 1005; %[kg/m3]
motors(1).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(2).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(3).prop_load = 274;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(4).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(5).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(6).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(7).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(8).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(9).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
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
motors(10).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(10).thrust_max = 0.154;    %[N]
motors(10).thrust_min = 0.058;
motors(10).power_max = 2700; %[W]
motors(10).power_min = 1000;
motors(10).mass = 7.1;       %[kg] 
motors(10).isp = 2030;        %[s]

motors(11).name = 'MR-502A';    %Rocketdyne arcjet motor
motors(11).class = 'electro-thermal';
motors(11).prop = 'hydrazine';       %
motors(11).prop_dens = 1005;     %[kg/m3] 
motors(11).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(11).thrust_max = 0.8;    %[N]
motors(11).thrust_min = 0.36;
motors(11).power_max = 8.25 + 1.54 + 3.93 + 885; %[W] Valve + valve heater + cat bed heater + augmentation heater
motors(11).power_min = 8.25 + 1.54 + 3.93 + 610;
motors(11).mass = 0.87;       %[kg] 
motors(11).isp = 303;        %[s]

motors(12).name = 'MR-509';    %Rocketdyne arcjet motor
motors(12).class = 'electro-thermal';
motors(12).prop = 'hydrazine';       %
motors(12).prop_dens = 1005;     %[kg/m3]
motors(12).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(12).thrust_max = 0.254;    %[N]
motors(12).thrust_min = 0.213;
motors(12).power_max = 1780; %[W] Valve + valve heater + cat bed heater + augmentation heater
motors(12).power_min = 1780;
motors(12).mass = 1.4 + 6.2;       %[kg] Motor + PCU
motors(12).isp = 502;        %[s]

motors(13).name = 'PRS-101';    %Rocketdyne arcjet motor
motors(13).class = 'pulsed plasma';
motors(13).prop = 'PTFE';       %
motors(13).prop_dens = 1005;     %[kg/m3] 
motors(13).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(13).thrust_max = 0.00124;    %[N]
motors(13).thrust_min = 0;
motors(13).power_max = 100; %[W] Valve + valve heater + cat bed heater + augmentation heater
motors(13).power_min = 0;
motors(13).mass = 4.74;       %[kg] Motor + PCU
motors(13).isp = 1350;        %[s]

motors(14).name = 'PRS-101';    %Rocketdyne arcjet motor
motors(14).class = 'pulsed plasma';
motors(14).prop = 'PTFE';       %
motors(14).prop_dens = 1005;     %[kg/m3] 
motors(14).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(14).thrust_max = 0.00124;    %[N]
motors(14).thrust_min = 0;
motors(14).power_max = 100; %[W] Valve + valve heater + cat bed heater + augmentation heater
motors(14).power_min = 0;
motors(14).mass = 4.74;       %[kg] Motor + PCU
motors(14).isp = 1350;        %[s]

motors(15).name = 'STAR 48V';    %Orbital ATK SRM
motors(15).class = 'chemical solid';
motors(15).prop = 'solid';       %
motors(15).prop_dens = 1500;     %[kg/m3] NEED TO CHECK 
motors(15).prop_load = 2011;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(15).thrust_max = 77800;    %[N]
motors(15).thrust_min = 0;
motors(15).power_max = 0; %[W] Valve + valve heater + cat bed heater + augmentation heater
motors(15).power_min = 0;
motors(15).mass = 154;       %[kg] whole motor including combustion chamber
motors(15).isp = 292;        %[s]

motors(16).name = 'STAR 37GV';    %Orbital ATK SRM
motors(16).class = 'chemical solid';
motors(16).prop = 'solid';       %
motors(16).prop_dens = 1500;     %[kg/m3] NEED TO CHECK 
motors(16).prop_load = 975;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(16).thrust_max = 67800;    %[N]
motors(16).thrust_min = 0;
motors(16).power_max = 0; %[W] Valve + valve heater + cat bed heater + augmentation heater
motors(16).power_min = 0;
motors(16).mass = 110;       %[kg] whole motor including combustion chamber
motors(16).isp = 290;        %[s]

motors(17).name = 'STAR 30E';    %Orbital ATK SRM
motors(17).class = 'chemical solid';
motors(17).prop = 'solid';       %
motors(17).prop_dens = 1500;     %[kg/m3] NEED TO CHECK 
motors(17).prop_load = 632;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(17).thrust_max = 39400;    %[N]
motors(17).thrust_min = 0;
motors(17).power_max = 0; %[W] Valve + valve heater + cat bed heater + augmentation heater
motors(17).power_min = 0;
motors(17).mass = 42;       %[kg] whole motor including combustion chamber
motors(17).isp = 288;        %[s]

motors(18).name = 'STAR 20';    %Orbital ATK SRM
motors(18).class = 'chemical solid';
motors(18).prop = 'solid';       %
motors(18).prop_dens = 1500;     %[kg/m3] NEED TO CHECK 
motors(18).prop_load = 272;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(18).thrust_max = 29900;    %[N]
motors(18).thrust_min = 0;
motors(18).power_max = 0; %[W] Valve + valve heater + cat bed heater + augmentation heater
motors(18).power_min = 0;
motors(18).mass = 28;       %[kg] whole motor including combustion chamber
motors(18).isp = 286;        %[s]

motors(19).name = 'R-40B';    %Aerojet Rocketdyne
motors(19).class = 'chemical biprop';
motors(19).prop = 'MMH/NTO';
motors(19).prop_dens = 950; %[kg/m3] NEED TO CHECK
motors(19).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(19).thrust_max = 556;    %[N]
motors(19).thrust_min = 489;
motors(19).power_max = 70; %[W] Valve Power
motors(19).power_min = motors(19).power_max;
motors(19).mass = 4.9;       %[kg] engine + valve
motors(19).isp = 329;        %[s]

motors(20).name = 'AJ10-190';    %Aerojet Rocketdyne
motors(20).class = 'chemical biprop';
motors(20).prop = 'MMH/NTO';
motors(20).prop_dens = 950; %[kg/m3] NEED TO CHECK
motors(20).prop_load = NaN;  %[kg] fuel load for solid motors or max rated throughput for motor
motors(20).thrust_max = 26700;    %[N]
motors(20).thrust_min = 26700;
motors(20).power_max = 125; %[W] Valve Power
motors(20).power_min = motors(20).power_max;
motors(20).mass = 118;       %[kg] engine + valve
motors(20).isp = 316;        %[s]

