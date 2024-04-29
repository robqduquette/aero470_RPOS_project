clear
close all

% PID gains for each pid controller (x,y,z,u,v,w)
P = [10, 10, 10, 10, 10, 10];
I = [0.01, 0.01, 0.01, 0.1, 0.1, 0.1];
D = [50, 50, 40, 0, 0, 0];
N = [0.2, 0.2, 0.2, 100, 100, 100];

% transfer functions
control_tf = @(x) tf([P(x)+D(x)*N(x), P(x)*N(x)+I(x), I(x)*N(x)],[1,0,N(x)]);

% create an empty matrix of transfer functions
GC = zeros(3,6);
GC = tf(GC);

% add the controller transfer functions
GC(1,1) = control_tf(1);
GC(2,2) = control_tf(2);
GC(3,3) = control_tf(3);
GC(1,4) = control_tf(4);
GC(2,5) = control_tf(5);
GC(3,6) = control_tf(6);

% get the system transfer function matrix
load sysoltf.mat
GPLANT = zeros(6,3);
GPLANT = tf(GPLANT);
for i = 1:3
    for j = 1:6
        GPLANT(j,i) = H_ex{i,j};
    end
end

% open loop tf
GOL = GPLANT*GC; % state error -> state

% closed loop tf
GCL = GOL/(1+GOL);


% H1 = transpose(H);
% T = (H1*GC)/(1+(H1*GC))

% bode(T)

%% 3x3 bode plots
if(0)
    fig_title = {'PID pos ref \rightarrow pos', 'PID pos ref \rightarrow vel',...
                 'PID vel ref \rightarrow pos','PID vel ref \rightarrow vel'};
    filename = ["PIDpos2pos","PIDpos2vel","PIDvel2pos","PIDvel2vel"];
    pos = 1:3;
    vel = 4:6;
    
    plotBode(pos,pos,GCL,fig_title{1},filename(1))
    plotBode(pos,vel,GCL,fig_title{2},filename(2))
    plotBode(vel,pos,GCL,fig_title{3},filename(3))
    plotBode(vel,vel,GCL,fig_title{4},filename(4))
end

%% individual bode plots
inputname = ["x_{ref}","y_{ref}","z_{ref}","u_{ref}","v_{ref}","w_{ref}"];
inputfilename = ["xref","yref","zref","uref","vref","wref"];
outputname = ["x","y","z","u","v","w"];

filename = @(in,out) join(["Plots/Bode Plots/Individual PID Bode/","PID_bode_",inputfilename(in),"_to_",outputname(out)],"");
fig_title = @(in,out) join(['PID Bode Plot: ',inputname(in),' \rightarrow ',outputname(out)],"");

p = bodeoptions('cstprefs')
p.grid = 'on';

close_plots = false;
% for every reference->state pair
for in = 1:6
    for out = 1:6
        plotBode(in,out,GCL,fig_title(in,out),filename(in,out),p)
        if close_plotsclose 
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
