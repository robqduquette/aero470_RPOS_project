clear
close all
load sysoltf.mat
%% root locus
% system requirements:
max_rise_time = 1000000000; % s
max_os = 50e-2; % overshoot percent
max_settle_time = 90*60 * 0.01; % s

% choose transfer function
in = 1;
out = 1;

n = 0.00110851126424986; %2*pi/(60); % Hz
m = 100; % kg

planttf = H_ex{in,out};
controltf = tf(poly([-2,-3]),[1]);%@(kd)tf(poly([0,0,0,n*1i,-n*1i]),poly([0,0,0,n*1i,-n*1i,-100/kd]));;
G_OL = planttf * controltf;

% get poles and zeros
zeros = roots(G_OL.Numerator{1})
poles = roots(G_OL.Denominator{1})

%% evaluate tf
num = G_OL.Numerator{1};
den = G_OL.Denominator{1};

plotPoleLims(max_rise_time, max_settle_time, max_os, poles, zeros)

figure
rlocus(G_OL)