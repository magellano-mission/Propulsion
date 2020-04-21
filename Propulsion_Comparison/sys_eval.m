function [mass_sys, vol_sys, time_sys] = sys_eval(mass_pay,delta_v,motors)

% sys_eval takes the input vectors for payload mass and burn delta v and
% calculates the propulsion system mass (motor hardware + propellant),
% propellant volume and motor burn time

g0 = 9.81;  %[m/s2] 
mass_dry = mass_pay + motors.mass;    %[kg]

mass_init = zeros(length(mass_dry),length(delta_v));
mass_prop = zeros(length(mass_dry),length(delta_v));
mass_sys = zeros(length(mass_dry),length(delta_v));
time_sys = zeros(length(mass_dry),length(delta_v));
vol_sys = zeros(length(mass_dry),length(delta_v));

for i = 1:length(mass_dry)
    for j = 1:length(delta_v)
        mass_init(i,j) = mass_dry(i) .* exp(delta_v(j) ./ (motors.isp*g0));
        mass_prop(i,j) = mass_init(i,j) - mass_dry(i);
        mass_sys(i,j) = motors.mass + mass_prop(i,j);
        vol_sys(i,j) = mass_prop(i,j) / motors.prop_dens;
        motors.mdot = motors.thrust / (motors.isp*g0);
        time_sys(i,j) = mass_prop(i,j) / motors.mdot;
    end
end