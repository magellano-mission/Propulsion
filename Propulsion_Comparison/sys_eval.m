function [mass_sys, mass_prop, vol_sys, time_sys] = sys_eval(mass_pay,dV,motors)

% sys_eval takes the input vectors for payload mass and burn delta v and
% calculates the propulsion system mass (motor hardware + propellant),
% propellant volume and motor burn time

g0 = 9.81;  %[m/s2] 
mass_dry = mass_pay  + motors.mass;    %[kg]

mass_init = zeros(length(mass_dry),length(dV));
mass_prop = zeros(length(mass_dry),length(dV));
mass_sys = zeros(length(mass_dry),length(dV));
time_sys = zeros(length(mass_dry),length(dV));
vol_sys = zeros(length(mass_dry),length(dV));

for i = 1:length(mass_dry)
    for j = 1:length(dV)
        mass_init(i,j) = mass_dry(i) .* exp(dV(j) ./ (motors.isp*g0));
        mass_prop(i,j) = mass_init(i,j) - mass_dry(i);
        mass_sys(i,j) = mass_prop(i,j)  + motors.mass;
        vol_sys(i,j) = mass_prop(i,j) / motors.prop_dens;
        motors.mdot = motors.thrust / (motors.isp*g0);
        time_sys(i,j) = mass_prop(i,j) / motors.mdot;
    end
end