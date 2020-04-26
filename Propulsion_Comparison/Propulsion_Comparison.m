%% PROBLEM SET UP
clearvars
close all
clc
[motors] = Motor_Data();            %Load all motor data

% Input arrays of payload masses and delta-Vs to observe trends
mass_pay = linspace(0,5000,500);     %[kg] payload mass array
dV = linspace(0,3000,500);      %[m/s] delta V of burn array

%Input a particular case to get numerical outputs
payload = 250;  %[kg]
delta_v = 200;  %[m/s]

%Input boundary conditions to filter motors
max_t_burn = 30*24*3600;            %[s]    maximum burn time allowable
min_thrust = 0;                   %[N]    minimum thrust of interest
max_thrust = inf;                  %[N]    maximum thrust of interest
min_isp = 0;                      %[s]    maximum isp of interest
max_isp = inf;                      %[s]    minimum isp of interest
max_power = 5000;                   %[W]    maximum power consumption allowable
classes = ["chemical solid"];
% all    - "chemical monoprop", "chemical biprop", "ion", "chemical solid", "hall effect", "electro-thermal"
%% FILTERING OF INPUT DATA
%Incompatible motors are filtered by thrust and power constraints.
%Thrust is throttled down if the motor maximum thrust is too high or the
% power draw is too high.
%Maximum time constraint is simply applied as a reference surface in the
%burn time plot

i = 1;
while i <= length(motors)   
    %removing motor classes that aren't acceptable
    if ismember(motors(i).class, classes) == 0
        motors(i) = [];  
        continue
    end    
        
    %removing motor if isp doesn't fall within acceptable range
    if (min_isp > motors(i).isp) || (motors(i).isp > max_isp)
        motors(i) = [];  
        continue
    end    
    
    %removing motor if thrust doesn't fall within acceptable range
    if (min_thrust > motors(i).thrust_max) || (motors(i).thrust_min > max_thrust)
        motors(i) = [];  
        continue
    end    
    
    %removing motor if minimum power is greater than available power
    if motors(i).power_min > max_power
        motors(i) = []; 
        continue
    end
    
    %throttling down motor if max thrust is greater than requested max thrust
    % AND power draw is not an issue
    thrust_a = inf;
    if motors(i).thrust_max > max_thrust && motors(i).power_max <= max_power
        thrust_a = max_thrust;
    end
    
    %throttling down motor if available power is less than motor max thrust draw
    % ANS motor max thrust is less than
    thrust_b = inf;
    if motors(i).power_max > max_power && motors(i).thrust_max <= max_thrust
        grad = (motors(i).thrust_max - motors(i).thrust_min) ...
                /(motors(i).power_max - motors(i).power_min);
        thrust_b =  grad*(max_power-motors(i).power_min) ...
                + motors(i).thrust_min;
    end
    
    %If throttling is required, the minimum thrust from the two previous
    % IF cases is selected.
    if thrust_a < inf || thrust_b < inf
        motors(i).thrust = min(thrust_a,thrust_b);
        motors(i).state = 'throttled';
        i = i+1;
    else %otherwise motor maximum thrust is taken as default thrust
        motors(i).thrust = motors(i).thrust_max;
        motors(i).state = 'max thrust';
        i = i+1;
    end
 
end
% Creating an array of default MATLAB colours for the surface plots to use
% Need to add more or use random colours if large number of motors will be
% plotted at one time
colours = [1 0 0; 1 0 1; 0 1 1; 1 1 0; 0 1 0; 0 0 1; 0, 0.4470, 0.7410; ...
    0.4940, 0.1840, 0.5560; 0.4660, 0.6740, 0.1880; 0.6350, 0.0780, 0.1840; 0.25, 0.25, 0.25; ...
    rand(), rand(), rand(); rand() rand() rand(); rand() rand() rand()];
%% CALCULATE SYSTEM PROPERTIES
clearvars i
for i = 1:length(motors)  %calculate mass, volume and burn time ARRAYS
    [motors(i).mass_sys, motors(i).mass_prop, motors(i).vol_prop, motors(i).time_sys] = ...
            sys_eval(mass_pay,dV,motors(i));
end

for i = 1:length(motors)  %calculate mass, volume, and burn time PARTICULAR CASE VALUES
    [motors(i).case.mass_sys, motors(i).case.prop_mass, motors(i).case.prop_vol, motors(i).case.burn_time_sec] = sys_eval(payload,delta_v,motors(i));
    motors(i).case.burn_time_hrs = motors(i).case.burn_time_sec/3600;
    motors(i).case.burn_time_day = motors(i).case.burn_time_hrs/24;
    disp(motors(i).name)
    disp(motors(i).case)
end
%% PROPULSION STAGE MASS PLOT
%Plots the sum of propellant mass and motor hardware. Mass of plumbing,
% tanks, pressurant, pumps etc are not considered
subplot(2,2,1)
hold on
clearvars i
for i = 1:length(motors)
    surf(mass_pay,dV,motors(i).mass_sys,'LineStyle', 'none','FaceColor',colours(i,:))
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
    surf(mass_pay, dV, motors(i).vol_prop, 'LineStyle', 'none','FaceColor',colours(i,:))
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
    surf(mass_pay, dV, motors(i).time_sys, 'LineStyle', 'none','FaceColor',colours(i,:),'HandleVisibility','off')
end
max_time = max_t_burn*ones(length(mass_pay),length(dV));
surf(mass_pay, dV, max_time, 'LineStyle', 'none','FaceColor',[0 0 0],'DisplayName','Maneuver Time Limit' )
legend()
xlabel('Payload Mass (kg)')
ylabel('Burn Delta V (m/s)')
zlabel('Burn Time (s)')
view(45,15)
zlim([0 max_t_burn*2])
axis vis3d
grid on
set(gca,'ZScale','log')
hold off
%% DUMMY PLOT
% Shitty workaround in order to display the legend separate to figures
blank1 = NaN(1,length(mass_pay));
blank2 = NaN(1,length(dV));
blank3 = NaN (length(mass_pay),length(dV));

subplot(2,2,4)
hold on
clearvars i
for i = 1:length(motors)
    surf(blank1, blank2, blank3, 'LineStyle', 'none','FaceColor',colours(i,:),'DisplayName', ...
        [motors(i).name ' - '  motors(i).class ' - ' num2str(motors(i).thrust,5) ' N' ' (' motors(i).state ')'])
end

set(gca,'Visible','Off')
legend('Location', 'northwest')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
hold off