%% PROBLEM SET UP
clearvars
close all
clc

[motors] = Motor_Data();            %Load motor data
mass_pay = linspace(0,200,100);     %[kg] payload mass array
delta_v = linspace(0,500,100);      %[m/s] delta V of burn array
colours = ['b','r','g','y','c','m'];    %Colours for the surface plots

%% CALCULATE SYSTEM PROPERTIES
for i = 1:length(motors)            %calculate mass, volume and burn time
    [motors(i).mass_sys, motors(i).vol_sys, motors(i).time_sys] = ...
            sys_eval(mass_pay,delta_v,motors(i));
end

%% PROPULSION STAGE MASS PLOT
%Plots the sum of propellant mass and motor hardware. Mass of plumbing,
% tanks, pressurant, pumps etc are not considered

subplot(2,2,1)
hold on
for j = 1:length(motors)
    surf(mass_pay,delta_v,motors(j).mass_sys,'LineStyle', 'none','FaceColor',colours(j))
end
xlabel('Payload Mass (kg)')
ylabel('Burn Delta V (m/s)')
zlabel('Propulsion Stage Mass (kg)')
view(45,15)
hold off

%% PROPELLANT VOLUME PLOT
%Plots the volume of propellant required. Assumptions regarding density and
% pressure are stated in the Motor_Data.m input file

subplot(2,2,2)
hold on
for k = 1:length(motors)
    surf(mass_pay, delta_v, motors(k).vol_sys, 'LineStyle', 'none','FaceColor',colours(k))
end
xlabel('Payload Mass (kg)')
ylabel('Burn Delta V (m/s)')
zlabel('Propellant Volume (m3)')
view(45,15)
hold off
%% BURN TIME PLOT
%Plots the time required to complete the burn for given delta v and
% payload mass combinations. Note that the z axis is logarithmic for
% convenience

subplot(2,2,3)
hold on
for l = 1:length(motors)
    surf(mass_pay, delta_v, motors(l).time_sys, 'LineStyle', 'none','FaceColor',colours(l))
end

xlabel('Payload Mass (kg)')
ylabel('Burn Delta V (m/s)')
zlabel('Burn Time (s)')
view(45,15)
zlim([0 inf])
set(gca,'ZScale','log')
hold off

%% DUMMY PLOT
% This is just a shitty workaround in order to display the legend
% separately in the display window

blank1 = NaN(1,length(mass_pay));
blank2 = NaN(1,length(delta_v));
blank3 = NaN (length(mass_pay),length(delta_v));

subplot(2,2,4)
hold on
for l = 1:length(motors)
    surf(blank1, blank2, blank3, 'LineStyle', 'none','FaceColor',colours(l),'DisplayName', ...
        [motors(l).name ' - '  motors(l).class ' - ' num2str(motors(l).thrust) 'N'])
end

set(gca,'Visible','Off')
legend('Location', 'northwest')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
hold off