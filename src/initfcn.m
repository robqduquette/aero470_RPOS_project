clear
close all

%% Initial Conditions
% x - radial
% y - along track
% z - cross track
pos_init = [0,0,0]; % x, y, z
vel_init = [1,0,1];

%% system parameters
n = 2*pi/(60); % Hz
m = 100; % kg

%% simulation settings
time_step_max = (1 * pi/180)/n;