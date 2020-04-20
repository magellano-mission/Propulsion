%% PROBLEM SET UP
clearvars
close all
clc

[motors] = Motor_Data();            %Load all motor data

%% FILTERING OF INPUT DATA
%Incompatible motors are filtered on basis of thrust and power constraints.
%Maximum time constraint is simply applied as a z axis limit to the time
% of burn plot

%Be careful with filtering - most motors can operate over a range of
% thrust and power levels, refer to Motor_Data for more info
max_t_burn = 100000;                 %[s]    maximum burn time allowable
min_thrust = 0;                     %[N]    minimum thrust of interest
max_thrust = 5000;                  %[N]    maximum thrust of interest
max_power = 1e5;                   %[W]    maximum power consumption allowable

i = 1;
while i <= length(motors)            %Filter out incompatible motors
    if (min_thrust <= motors(i).thrust) && (motors(i).thrust <= max_thrust) ...
            && (motors(i).power <= max_power)
            motors(i) = motors(i);
            i = i+1;
    else
        motors(i) = [];
    end
end
mass_pay = linspace(0,500,100);     %[kg] payload mass array
delta_v = linspace(0,1000,100);      %[m/s] delta V of burn array
colours = ['b','r','g','y','c','m'];    %Colours for the surface plots

%% CALCULATE SYSTEM PROPERTIES
clearvars i
for i = 1:length(motors)            %calculate mass, volume and burn time
    [motors(i).mass_sys, motors(i).vol_sys, motors(i).time_sys] = ...
            sys_eval(mass_pay,delta_v,motors(i));
end

%% PROPULSION STAGE MASS PLOT
%Plots the sum of propellant mass and motor hardware. Mass of plumbing,
% tanks, pressurant, pumps etc are not considered

subplot(2,2,1)
hold on
clearvars i
for i = 1:length(motors)
    surf(mass_pay,delta_v,motors(i).mass_sys,'LineStyle', 'none','FaceColor',colours(i))
end
xlabel('Payload Mass (kg)')
ylabel('Burn Delta V (m/s)')
zlabel('Propulsion Stage Mass (kg)')
axis vis3d
grid on
view(45,15)
hold off

%% PROPELLANT VOLUME PLOT
%Plots the volume of propellant required. Assumptions regarding density and
% pressure are stated in the Motor_Data.m input file

subplot(2,2,2)
hold on
clearvars i
for i = 1:length(motors)
    surf(mass_pay, delta_v, motors(i).vol_sys, 'LineStyle', 'none','FaceColor',colours(i))
end
xlabel('Payload Mass (kg)')
ylabel('Burn Delta V (m/s)')
zlabel('Propellant Volume (m3)')
axis vis3d
grid on
view(45,15)
hold off
%% BURN TIME PLOT
%Plots the time required to complete the burn for given delta v and
% payload mass combinations. Note that the z axis is logarithmic for
% convenience

subplot(2,2,3)
hold on
clearvars i
for i = 1:length(motors)
    surf(mass_pay, delta_v, motors(i).time_sys, 'LineStyle', 'none','FaceColor',colours(i))
end

xlabel('Payload Mass (kg)')
ylabel('Burn Delta V (m/s)')
zlabel('Burn Time (s)')
view(45,15)
zlim([0 max_t_burn])
axis vis3d
grid on
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
clearvars i
for i = 1:length(motors)
    surf(blank1, blank2, blank3, 'LineStyle', 'none','FaceColor',colours(i),'DisplayName', ...
        [motors(i).name ' - '  motors(i).class ' - ' num2str(motors(i).thrust) 'N'])
end

set(gca,'Visible','Off')
legend('Location', 'northwest')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
hold off