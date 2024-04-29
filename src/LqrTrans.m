clear
close all

%% Create the plots of the LQR controller system

n = 0.00110851126424986; %2*pi/(60); % Hz
m = 100; % kg
max_thrust = 25; %N

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

speed = [1,1,1,1,1,1];
effort = [1,1,1];
spdpriority = 0.6;

Q = diag(speed./norm(speed) * spdpriority);
R = diag(effort./norm(effort) * (1-spdpriority));

K = lqr(A,B,Q,R);

% Construct the closed-loop system
Ac = A - B*K;
Bc = B;
Cc = C;
Dc = D;

% Create state-space model of the closed-loop system
sys_cl  = ss(Ac, Bc, Cc, Dc);

% Convert state-space model to transfer function
GCL = tf(sys_cl);

% Display the transfer function
% disp('Transfer Function of the Closed-Loop System with LQR Controller:');
% sys_tf

% display all bode plots on one plot
%bode(sys_tf) 

% individual bode plots
for in = 1
    for out = 1
        % make plot
        figure
        bode(GCL(out,in))
        grid on
        fig_title = ['Bode plot for input = ' ]
        
    end
end


