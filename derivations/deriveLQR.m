clear
close all

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

sys = ss(A,B,C,D);

%% LQR
speed = [1,1,1,1,1,1];
effort = [1,1,1];
spdpriority = 0.6;

Q = diag(speed./norm(speed) * spdpriority);
R = diag(effort./norm(effort) * (1-spdpriority));

[KLQR, S, P] = lqr(A,B,Q,R);
KLQR
% then LQR control block diagram is:
%                                     
%      r    +    e       u             y  
%    -------> O -->[LQR]-->[PLANT]--+---->                               
%            -|                     |   
%             +---------------------+                       
%                                     
%     where r is 6x1, e is 6x1, u is 3x1, y is 6x1                                
%                                   

%% evaluate
% system requirements:
max_rise_time = 60 % s
max_os = 0.5; % overshoot percent
max_settle_time = 60 % s

plotPoleLims(max_rise_time, max_settle_time, max_os, P, []);
title('LQR Pole Locations')