clear
%close all

%% Initial Conditions
% x - radial
% y - along track
% z - cross track
pos_init = [30e3,70720,0]; % x, y, z
vel_init = [0,-58.2,0];


%% system parameters
n = 0.00110851126424986; %2*pi/(60); % Hz
m = 100; % kg

%% simulation settings
time_step_max = (1 * pi/180)/n;

%% State space model
% state is (x,y,z,u,v,w)
A = zeros(6,6);
A(1:3,4:6) = eye(3);
A(4,1) = 3*n^2;
A(6,3) = -n^2;
A(5,4) = -2*n;
A(4,5) = 2*n;

B = [zeros(3,3);eye(3)/m];
C = eye(6);
D = zeros(6,3);