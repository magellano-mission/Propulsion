%% Oxidizer selection
function [rho_ox]=ox_selection(oxidizer,Temp)
switch oxidizer
    case 'N2O4' 
        rho_ox = 2.066 - 1.979e-3*Temp -4.826e-7*Temp^2; % g/cc
    case 'MON-1'
        rho_ox = 2.066 - 1.979e-3*Temp -4.826e-7*Temp^2; % g/cc
    case 'MON-2'
        rho_ox = 2.066 - 1.979e-3*Temp -4.826e-7*Temp^2; % g/cc
    case 'MON-3'
        rho_ox = 2.066 - 1.979e-3*Temp -4.826e-7*Temp^2; % g/cc
    case 'Hydrazine'
        rho_ox = 1.23078 -6.2668e-4*Temp - 4.5284e-7*Temp^2; % g/cc
end
end