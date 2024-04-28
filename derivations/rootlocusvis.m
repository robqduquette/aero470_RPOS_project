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

%% reqs -> dominant pole locations
rise_rad = 2/max_rise_time; % dominant poles must be outside this circle
settle_lim = -4/max_settle_time; % dominant poles must be left of re = settle_lim
damp_slope = 5/(3*(max_os-1));
theta = linspace(0,2*pi,360);

% polygon vertices
bound_points = [settle_lim-1, damp_slope*(settle_lim-1);
                settle_lim, damp_slope*settle_lim;
                settle_lim, -damp_slope*settle_lim;
                settle_lim-1, -damp_slope*(settle_lim-1)];

bad_points = [1, - damp_slope*(settle_lim-1);
                   1, damp_slope*(settle_lim-1);
                   bound_points];

good_points = [-4, -damp_slope*(settle_lim-1);
                 -4,  damp_slope*(settle_lim-1);
                 bound_points];

%% plot poles, zeros, requirements
figure
% requirements
%fill(good_points(:,1), good_points(:,2),'green','FaceAlpha',0.1,'EdgeAlpha',0);
hold on
%fill(rise_rad*sin(theta), rise_rad*cos(theta),'white','FaceAlpha',1,'EdgeAlpha',0); % cover up green in circle
fill(bad_points(:,1), bad_points(:,2),'red','FaceAlpha',0.1,'EdgeAlpha',0.5,'EdgeColor','red');
hold on
fill(rise_rad*sin(theta), rise_rad*cos(theta),'red','FaceAlpha',0.1,'EdgeAlpha',0.5,'EdgeColor','red');
plot([0,0],[damp_slope*(settle_lim-1),-damp_slope*(settle_lim-1)],'-k')
% poles and zeros
scatter(real(poles),imag(poles), 'rx')
scatter(real(zeros),imag(zeros), 'bo')
grid on
xlabel('Real Axis')
ylabel('Imaginary Axis')
title(['Poles and Zeros of OL tf (in,out) = (',num2str(in),', ',num2str(out),')'])


legend('Bad','','','Poles','Zeros','Location','northeast')

figure
rlocus(G_OL)