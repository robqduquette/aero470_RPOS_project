%%
clear
%close all

%% define transfer
r_earth = 6371e3;
m_earth = 5.9722e24;
G = 6.67430e-11;
mu = m_earth*G;
r1 = r_earth + 530e3;
r2 = r_earth + 500e3;
delta_r = r2-r1;

%% evlliptical transfer
a = r1 + delta_r/2;
e = 1 - r2/a; % eccentricity
n = sqrt(mu/a^3); % mean motion

% speeds
vperiapse = sqrt(mu*(1+e)/(a-a*e));
vapoapse = sqrt(mu*(1-e)/(a+a*e));
vcirc1 = sqrt(mu/r1);
vcirc2 = sqrt(mu/r2);

%% transfer speed(t)
f_test = linspace(0,pi);
t = timeFromAnomaly(f_test,mu,a,e);
%figure(1)
%plot(t, f_test)
%xlabel('time')
%yleabel('true anomaly')
% this is basically linear
f_lin = @(t) pi/timeFromAnomaly(pi,mu,a,e) .* t;
% = @(t) 0.00110489105111839*t + 0.00274575411458287;

% radius and tangent velocity as fxn of time
transfer_time = timeFromAnomaly(pi,mu,a,e);
radius = @(t) a*(1-e^2)./(1+e*cos(f_lin(transfer_time-t))); % transfer_time-t bc starting at apoapse
tang_vel = @(t) sqrt(mu*(2./radius(t) - 1/a));



%% Trajectory
dt = 1; %s
t_fire1 = 100; 
t_fire2 = t_fire1+transfer_time;

v0  = @(t) vcirc1 .* (t < t_fire1);
vf  = @(t) vcirc2 .* (t >= t_fire2);
vtf = @(t) tang_vel(t-t_fire1) .* (t >= t_fire1) .* (t < t_fire2);
vel_inertial = @(t) v0(t) + vf(t) + vtf(t);

r_inertial = @(t) radius(t-t_fire1).*(t>=t_fire1).*(t<t_fire2) + r1*(t<t_fire1) + r2*(t>=t_fire2);

%% plot
t = linspace(0,t_fire2 + 100,10000);
r = r_inertial(t);
v = vel_inertial(t);
y_disp = integral(@(t)(vel_inertial(t)-vcirc2),t_fire2,t_fire1) 
energy = (0.5*v.^2 - mu./r)./1e18;


figure(2)
subplot(2,1,1)
plot(t,v)
hold on
% plot(t,v0(t),'--co')
% plot(t,vf(t),'--go')
% plot(t,vtf(t),'--ms')
xlabel('time (s)')
ylabel('reference velocity (m/s)')
grid on
subplot(2,1,2)
plot(t,r/1000)
ylabel('reference orbit radius (km)')
xlabel('time (s)')
grid on

sgtitle({'Hohmann Transfer Reference Trajectory','Inertial Frame'})

figure(3)
plot(t,energy)

%% Convert to target frame
r_target = r-r2;
v_target = v-vcirc2;

figure(4)
plot(t,r_target)

figure(5)
plot(t,v_target)
xlabel('time (s)')
ylabel('y_(dot) (m/s)')
title('reference velocity in the target frame')
grid on


%% Functions
function [t] = timeFromAnomaly(f,mu,a,e)
    E = 2*atan(sqrt((1-e)./(1+e)).*tan(f/2));
    M = E - e*sin(E);
    t = M/sqrt(mu/a^3);
end
