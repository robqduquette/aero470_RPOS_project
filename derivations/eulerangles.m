clear
%% Derive rotation transforms
syms psi the phi 

Rx = @(a) [1 0 0 ; 0 cos(a) -sin(a); 0 sin(a) cos(a)];
Rz = @(a) [cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1];
Ry = @(a) [ cos(a) 0 sin(a); 0 1 0; -sin(a) 0 cos(a)];

Rsat = Ry(psi)*Rz(the)*Rx(phi);

%% Euler derivatives

% euler derivatives
psi_d = [0;1;0]; % in frame 3
the_d = Ry(psi)*[0;0;1];
phi_d = Ry(psi)*Rz(the)*[1;0;0];

syms psidm thedm phidm % the magnitudes of the angular velocities
omega = psidm*psi_d + thedm*the_d + phidm*phi_d

A = [cos(psi)*cos(the) 0 sin(psi);
     sin(the) 1 0;
     -sin(psi)*cos(the) 0 cos(psi)];

omega2eulerderiv = simplify(inv(A))

%% torque to angl accel
syms tau [3,1]
syms I [3,1]
I = diag(I);
syms omega [3,1]

omega_dot = I^-1 * (tau - cross(omega,I*omega))

%% plot
close all
% % euler angles
% phi = 0.2;
% the = 1;
% psi = 0.;

% = Ry(psi)*Rz(the)*Rx(phi);
% figure
% %showFrame(eye(3),'target')
% showFrame(Rsat*2, 'Sat')
% 
% quiver3(0,0,0,psi_d(1),psi_d(2),psi_d(3),Color='k',LineWidth=2)
% text(psi_d(1),psi_d(2),psi_d(3),'\psi dot')
% quiver3(0,0,0,phi_d(1),phi_d(2),phi_d(3),Color='k',LineWidth=2)
% text(phi_d(1),phi_d(2),phi_d(3),'\phi dot')
% quiver3(0,0,0,the_d(1),the_d(2),the_d(3),Color='k',LineWidth=2)
% text(the_d(1),the_d(2),the_d(3),'\theta dot')
% grid on