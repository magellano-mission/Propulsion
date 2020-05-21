%% CHANGE ORBIT

%% Matlab Initialization
clear; close all; clc

%% Figure Initialization
set(0,'DefaultFigureUnits', 'normalized');
set(0,'DefaultFigurePosition',[0 0 1 1]);
set(0,'DefaultTextFontSize',18);
set(0,'DefaultAxesFontSize',18);
set(0,'DefaultAxesXGrid','on')
set(0,'DefaultAxesYGrid','on')
set(0,'defaultLegendInterpreter','latex');
set(0,'defaultAxesTickLabelInterpreter','latex');

%%
a_target = 10500;
e_GNSS = 0;
i_GNSS = 55;
mi = 42828.3;                        % mars gravity constant [km^2/s^3]
v_target = sqrt(mi/a_target);            % linear velocity of the GNSS constellation [km/s]
n = sqrt(mi/a_target^3);               % mars angular velocity [rad/s]


g0 = 9.81;

a_lower = 8000:500:10000; %semi-major axis where we change RAAN

N = length(a_lower);

%% Homhann transfer (stack)

dv_h = zeros(N, 1);
Mprop = zeros(N, 1);

M_end = 6*300+1*800; % mass of a stack
Isp = 320; %biprop

for i = 1:N
    ra_h = a_lower(i);
    rp_h = a_target;
    a_h = (ra_h + rp_h)/2;
    v_ECS = sqrt(mi/ra_h);
    vp_h = sqrt(2*mi*(1/rp_h - 1/(2*a_h)));
    va_h = sqrt(2*mi*(1/ra_h - 1/(2*a_h)));
    dv_h(i) = abs(v_ECS - va_h) + abs(v_target - vp_h);
    r = exp(dv_h(i)*1000/(g0*Isp));
    M0 = r*M_end;
    Mprop(i) = M0*(1-1/r);
end

figure; subplot(1,2,1)
plot(a_lower, dv_h, 'LineWidth', 2)
xlabel('radius of lower orbit [km]'), ylabel('\Delta_v [km/s]');
title('Hohmann DeltaV')
subplot(1,2,2)
plot(a_lower, Mprop, 'LineWidth', 2)
xlabel('radius of lower orbit [km]'), ylabel('Required prop mass [kg]');
title('Hohmann prop mass required')

%% Homhann transfer (single satellite)

a_lower = 8000:500:11000; %semi-major axis where we change RAAN

N = length(a_lower);

dv_h = zeros(N, 1);
Mprop = zeros(N, 1);
M_end = 300; % mass of single satellite
Isp = 230; %hydrazine

for i = 1:N
    ra_h = a_lower(i);
    rp_h = a_target;
    a_h = (ra_h + rp_h)/2;
    v_ECS = sqrt(mi/ra_h);
    vp_h = sqrt(2*mi*(1/rp_h - 1/(2*a_h)));
    va_h = sqrt(2*mi*(1/ra_h - 1/(2*a_h)));
    dv_h(i) = abs(v_ECS - va_h) + abs(v_target - vp_h);
    r = exp(dv_h(i)*1000/(g0*Isp));
    M0 = r*M_end;
    Mprop(i) = M0*(1-1/r);
end

figure; subplot(1,2,1)
plot(a_lower, dv_h, 'LineWidth', 2)
xlabel('radius of lower orbit [km]'), ylabel('\Delta_v [km/s]');
title('Hohmann DeltaV')
subplot(1,2,2)
plot(a_lower, Mprop, 'LineWidth', 2)
xlabel('radius of lower orbit [km]'), ylabel('Required prop mass [kg]');
title('Hohmann prop mass required')


%% LT Eletric transfer (single satellite)

mass = 300;                  % mass [kg]
T = 0.1:0.05:1;             % thrust [N]
at = T/mass*1e-3;             % transversal acceleration [km/s^2]

figure; 
subplot(1,2,1);
hold on
for i = 1:N
    t = 2*(a_target - a_lower(i))./(at*a_lower(i)*sqrt(a_target/mi))/86400/30; %doubled for eclipse
    plot(t, T, 'LineWidth', 2)
end
ylabel('Electric continuous thrust [N]'), xlabel('tof [months]');
title('Thrust vs time to reach target orbit')
legend(horzcat(strcat('a = ', " ", string(a_lower))))


T = 0.01:0.005:0.1;             % thrust [N]
at = T/mass*1e-3;             % transversal acceleration [km/s^2]

subplot(1,2,2); hold on
for i = 1:N
    t = 2*(a_target - a_lower(i))./(at*a_lower(i)*sqrt(a_target/mi))/86400/30; %doubled for eclipse
    plot(t, T, 'LineWidth', 2)
end
ylabel('Electric continuous thrust [N]'), xlabel('tof [months]');
title('Thrust vs time to reach target orbit')
legend(horzcat(strcat('a = ', " ", string(a_lower))))

%% LT Eletric transfer (stack)

mass = 300*6+1000;                  % mass [kg]
T = 0.1:0.005:1;             % thrust [N]
at = T/mass*1e-3;             % transversal acceleration [km/s^2]

a_lower = [10000 12300];
N = length(a_lower);

figure; 
subplot(1,2,1);
hold on
for i = 1:N
    t = 2*(a_target - a_lower(i))./(at*a_lower(i)*sqrt(a_target/mi))/86400/30; %doubled for eclipse
    plot(t, T, 'LineWidth', 2)
end
ylabel('Electric continuous thrust [N]'), xlabel('tof [months]');
title('Thrust vs time to reach target orbit')
legend(horzcat(strcat('a = ', " ", string(a_lower))))


mass = 1000+600*2;
a_target = 7400;
a_lower = [6400];
N = length(a_lower);

figure; 
subplot(1,2,1);
hold on
for i = 1:N
    t = 2*(a_target - a_lower(i))./(at*a_lower(i)*sqrt(a_target/mi))/86400/30; %doubled for eclipse
    plot(t, T, 'LineWidth', 2)
end
ylabel('Electric continuous thrust [N]'), xlabel('tof [months]');
title('Thrust vs time to reach target orbit')
legend(horzcat(strcat('a = ', " ", string(a_lower))))


%% PHASING

T = 2*pi/n;                         % GNSS period [s]
K = 360;

dv_phas = NaN(K, K/2);
for i = 1:K                               % i: phasing angle
    for j = 3:K/2                         % j: number of revolutions
        dT_tot = (i*pi/180)/n;
        dT_rev = dT_tot/j;          
        T_phas = T - dT_rev;
        a_phas  = (T_phas*sqrt(mi)/(2*pi))^(2/3);
        ra_phas = a_target;
        rp_phas = 2*a_phas - ra_phas;
        e_phas = (ra_phas - rp_phas)/(ra_phas + rp_phas);
        v_phas = sqrt(mi/a_phas)*(1 - e_phas);
        dv_phas(i, j) = 2*abs(v_target - v_phas);
    end
end

surf(1:K, 1:K/2, dv_phas', 'EdgeColor', 'none')
colorbar; xlabel('phasing angle [deg]'), ylabel('number of revolutions');
zlabel('\Delta_v [km/s]'), title('phasing maneuver')


% Additional plot to check deltaV with minimum number of revolutions

Nmin = 120;
Time_min = Nmin*T/(60*60*24*30); %minimum time of the maneuver (correspondent to Nmin)
surf(1:K, Nmin:K/2, dv_phas(:,Nmin:180)', 'EdgeColor', 'none')
colorbar; xlabel('phasing angle [deg]'), ylabel('number of revolutions');
zlabel('\Delta_v [km/s]'), title('phasing maneuver')


