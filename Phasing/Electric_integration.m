function dY = Electric_integration(t, Y, data)
%{
ODE function to integrate the Thrusted electric arches
%}

%M = data.M0 -                         % structural mass

% States
R = Y(1:3);
V = Y(4:6);
M = Y(7);

g0 = 9.807;

% input checks
if isrow(R)
    R = R';
end
if isrow(V)
    V = V';
end

DayActual = data.InitDay + t;

% Rotation Matrix tnh
t_hat = V/norm(V);
h_hat = cross(R, V)/norm(cross(R, V));
n_hat = cross(h_hat, t_hat);
A = [t_hat, n_hat, h_hat];

T = data.T;

if data.ThrustDir == 1
    aT_tnh = [T/M*1e-3; 0; 0];                          % [km/s^2]
elseif data.ThrustDir == 2
    aT_tnh = [0; T/M*1e-3; 0];
elseif data.ThrustDir == 3
    aT_tnh = [0; 0; T/M*1e-3];
end

aT_car = A*aT_tnh;           % from tnh to car



% Derivative of the states
dY(1:3) = V;
dY(4:6) = - data.mi/norm(R)^3.*R + aT_car;
dY(7) = -abs(T)/(data.Isp*g0);

dY = dY';

end