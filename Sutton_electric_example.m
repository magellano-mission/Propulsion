%% Example Sutton 17.4

clear all
close all
clc

g0 = 9.807;

% Deltav = 4700;
Deltav = 3000;

Deltav_vc = 0.3;

v_c = Deltav/Deltav_vc;

% Is_min = Deltav*0.2268;
% Is_max = Deltav*0.4263;

Is_min = v_c*0.57/g0; % 10% oval
Is_max = v_c*1.36/g0; % 10% oval


HALL = struct();
HALL.Is = 1983;
HALL.alpha = 366;
HALL.eff = 0.57;
HALL.phi = 0.12;

ION = struct();
ION.Is = 2800;
ION.alpha = 278;
ION.eff = 0.50;
ION.phi = 0.12;

v_eff = HALL.Is*g0;
veff_vc = v_eff/v_c;
phi = HALL.phi;
alpha = HALL.alpha;
eff = HALL.eff;


fun = @(x) Deltav_vc - veff_vc*log((1+phi + veff_vc^2)/(x + phi + veff_vc^2));

Mpl_M0 = fzero(fun,0.5);

t_p = v_c^2/(2*alpha*eff)/(60*60*24); %days