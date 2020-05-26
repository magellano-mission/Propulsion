%% Fuel selection
function [rho_fuel]=fuel_selection(fuel,Temp)
switch fuel
    case 'Hydrazine'
        rho_fuel = 1.23078 -6.2668e-4*Temp - 4.5284e-7*Temp^2; % g/cc
    case 'MMH'
        rho_fuel = 1.15034-9.3949e-4*Temp; % g/cc
    case 'LMP-103S'
        rho_fuel = 1.3*(1.23078 -6.2668e-4*Temp - 4.5284e-7*Temp^2); % g/cc
    case 'H2O2' %hydrogen peroxide (monopropellant)
        rho_fuel = 1.0479 + 2.455*10^-3 + 1.781*10^(-5) - 6.76*10^(-4)*(Temp-273.15) -2.4*10^(-7)*(Temp-273.15)^2 -3.98*10^(-6)*(Temp-273.15);
end
end