function [rho_m,sigma_tum]=tankmaterial(material)
% Material properties for the tank:
%   Al 2024 T3
%   Stainless steel
%   Alloy steel
%   Ti6Al4V
%   Ti15-3

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
    case 'Ti15-13'
        rho_m = 4760; %kg/m3
        sigma_tum = 703e6; %Pa
    case 'CFRP+Al' %"Mechanical properties of carbon fibre reinforced aluminium laminates using two different layering pattern for aero engine application", October 2018, DOI: 10.1080/2374068X.2018.1530427, Ibrahim Mohammed, Abd Rahim Abu Talib
        rho_m = 2174.18;%7Al+17CFRP
        sigma_tum = 350e6;

end
end