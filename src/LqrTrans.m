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
Bc = B*K;
Cc = C;
Dc = D*K;

% Create state-space model of the closed-loop system
sys_cl  = ss(Ac, Bc, Cc, Dc);

% Convert state-space model to transfer function
GCL = tf(sys_cl);

% Display the transfer function
% disp('Transfer Function of the Closed-Loop System with LQR Controller:');
% sys_tf

% % get the system transfer function matrix
% load sysoltf.mat
% GPLANT = zeros(6,3);
% GPLANT = tf(GPLANT);
% for i = 1:3
%     for j = 1:6
%         GPLANT(j,i) = H_ex{i,j};
%     end
% end
% 
% % open loop tf
% GOL = GPLANT*GC; % state error -> state
% 
% % closed loop tf
% GCL = GOL/(1+GOL);


% H1 = transpose(H);
% T = (H1*GC)/(1+(H1*GC))

% bode(T)


%% individual bode plots
inputname = ["x_{ref}","y_{ref}","z_{ref}","u_{ref}","v_{ref}","w_{ref}"];
inputfilename = ["xref","yref","zref","uref","vref","wref"];
outputname = ["x","y","z","u","v","w"];

filename = @(in,out) join(["Plots/Bode Plots/Individual LQR Bode/","LQR_bode_",inputfilename(in),"_to_",outputname(out)],"");
fig_title = @(in,out) join(['LQR Bode Plot: ',inputname(in),' \rightarrow ',outputname(out)],"");

p = bodeoptions('cstprefs')
p.grid = 'on';

close_plots = true;
% for every reference->state pair
for in = 1:6
    for out = 1:6
        plotBode(in,out,GCL,fig_title(in,out),filename(in,out),p)
        if close_plots
            close gcf
        end
    end
end


%% functions
% plots and saves as png
function [] = plotBode(in,out,tf,plot_title,filename,opt)
    figure
    freq = {1e-6, 1e4}; % periods between of 72 days to 0.06 seconds
    bodeplot(tf(in,out),opt,freq)
    title(plot_title)
    print(filename,'-dpng')
    % print(filename,'-dpdf','-fillpage')
    %saveas(gcf, filename)
end

