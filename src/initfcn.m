clear
%close all

LQR_ON = true;
disturbance_gain = 0;

names = ["PID","LQR"];
dist = [" no disturbances"," with disturbances"];
control_name = join([names(LQR_ON + 1),dist(disturbance_gain+1)],"");

filepath = join(["Plots/SimFigs/",control_name]);

%% Initial Conditions
% x - radial
% y - along track
% z - cross track
pos_init = [29983, 70724, 10]; % x, y, z
vel_init = [0, -60, 0];%[0,-58.2,0];


%% system parameters
n = 0.00110851126424986; %2*pi/(60); % Hz
m = 100; % kg
max_thrust = 25; %N

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

%% transfer fxns

tfux = ss2tf(A,B,C,D,1);
tfuy = ss2tf(A,B,C,D,2);
tfuz = ss2tf(A,B,C,D,3);

for i = 1:size(B, 2) % Loop over each input
    [num, den] = ss2tf(A, B, C, D, i);
    % Loop over each output
    for j = 1:size(C, 1) % Assuming output size matches C's row count
        % Store each transfer function in the cell array
        H{i, j} = tf(num(j, :), den);
        % H{i,j}
    end
end
H;
% where H{input, output}

%% Spacecraft attitude model
Ix = 1000;
Iy = 1000;
Iz = 1000;

A_att = zeros(6,6);
A_att(1:3,4:6) = eye(3);
B_att = [zeros(3,3);diag([1/Ix, 1/Iy, 1/Iz])];
C_att = eye(6);
D_att = zeros(6,3);

attitude = ss(A_att, B_att, C_att, D_att);

