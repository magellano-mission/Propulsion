%% Pressurant selection

function [gamma_pg,R_pg]=pressurant_selection(pressurant)
switch pressurant
    case 'He'
        gamma_pg = 1.667;
        R_pg = 2.08e3; %J/kgK
    case 'N'
        gamma_pg = 1.4;
        R_pg = 0.297e3;
end
end