function [rho_m,sigma_tum]=tankmaterial(material)
% Material properties for the tank:
%   Al 2024 T3
%   Stainless steel
%   Alloy steel
%   Ti6Al4V

switch material
    case 'Al2024T3' 
        rho_m = 2780; %kg/m3
        sigma_tum = 345e6; %Pa
    case 'Stainless steel'
        rho_m = 7850;
        sigma_tum = 673e6;
    case 'Alloy steel'
        rho_m = 7850;
        sigma_tum = 745e6;
    case 'Ti6Al4V'
        rho_m = 4430; %kg/m3
        sigma_tum = 950e6; %Pa
end
end