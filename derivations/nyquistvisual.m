clear
close all
load sysoltf.mat
%% nyqist
% choose transfer function
in = 2;
out = 2;
radius = 1e-1; % set to 0 if no radius desired
boxneg1 = false;

controltf = tf([1],[1]);
tf = H_ex{in,out} * controltf;

% get poles and zeros
zeros = roots(tf.Numerator{1})
poles = roots(tf.Denominator{1})

% number of open loop poles in RHP
% Need this number of CCW loops around -1 in nyquist plot
num_ol_poles_RHP = sum(real(poles) > 0)

%% evaluate tf
num = tf.Numerator{1};
den = tf.Denominator{1};

% note - tf explodes when 0.1 of origin in real, need to circumvent it
w_circ = [];
if (radius ~= 0) % make the round part
    theta = linspace(0,pi/2);
    w_circ = radius*(cos(theta) + i*sin(theta));
end
w_vert = logspace(log10(radius),20,1000)*1i;

w = [w_circ, w_vert];

%% plot poles, zeros, input w
w_plot = w(1:1:end);

figure
%plot(real(w_plot),imag(w_plot),'.-m')
hold on
scatter(real(poles),imag(poles), 'rx')
scatter(real(zeros),imag(zeros), 'bo')
grid on
xlabel('Real Axis')
ylabel('Imaginary Axis')
% xlim([-1,1]*1e-14)
% ylim([-1,1]*0.005)
title(['Poles and Zeros of OL tf (in,out) = (',num2str(in),', ',num2str(out),')'])


%% make nyquist plot
tfout = polyval(num,w)./polyval(den,w);

figure
plot(real(tfout),-imag(tfout), '.-c')% -inf -> 0
hold on
plot(real(tfout),imag(tfout), '.-b')% 0->inf

plot(real(tfout(1)),imag(tfout(1)), 'gx')
plot(real(tfout(end)),imag(tfout(end)), 'rx')
text(real(tfout(1)),imag(tfout(1)),'zero*','Color','g')
text(real(tfout(end)),imag(tfout(end)),'+inf','Color','r')
grid on
scatter(-1,0,'r+')
text(-1,0,'-1')
title({['Nyquist Plot for (in,out) = (',num2str(in),', ',num2str(out),')'],['Stable if number CCW loops = ',num2str(num_ol_poles_RHP)]})
xlabel('Real Axis')
ylabel('Imaginary Axis')
if boxneg1
    xlim([-11,9])
    ylim([-10,10])
end
if radius
    legend('',[num2str(radius),' circle around 0 \rightarrow +\infty'])
else 
    legend('',['0 \rightarrow +\infty'])
end