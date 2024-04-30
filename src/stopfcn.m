%% get data
logsout = out.logsout;

indx.disturb = 1;
indx.u_LQR = 2;
indx.u_PID = 3;
indx.ref = 6;
indx.y = 7;
indx.u_des = 8;
indx.u = 9;
indx.F_pid_vel = 5;
indx.F_pid_pos = 4;

% check
output = logsout{indx.y}.Values.Data; % x y z u v w
assert("y" == logsout{indx.y}.Name)
radial_p = output(:,1);
radial_v = output(:,4);
along_p  = output(:,2);
along_v  = output(:,5);
cross_p  = output(:,3);
cross_v  = output(:,6);

input = logsout{indx.u}.Values.Data; 
assert("u" == logsout{indx.u}.Name)
ux = input(:,1);
uy = input(:,2);
uz = input(:,3);

ref = logsout{indx.ref}.Values.Data;
assert("ref" == logsout{indx.ref}.Name)
radial_pref = ref(:,1);
radial_vref = ref(:,4);
along_pref  = ref(:,2);
along_vref  = ref(:,5);
cross_pref  = ref(:,3);
cross_vref  = ref(:,6);

time = logsout{indx.y}.Values.Time;

%% Plots
close all

%% 3d plot
if(0)
    figure(1)
    plot3(radial_p, along_p, cross_p,'b')
    hold on
    plot3(pos_init(1),pos_init(2),pos_init(3),'-sb');
    xlabel('radial')
    ylabel('along track')
    plotTarget([0 8e3 0],'sr')
    grid on
    axis equal
end

%% orbit plane plot
if(0)
    figure(2)
    plotTarget([-8,0,0],'sr');
    hold on
    plot(-ref(:,2)/1e3,ref(:,1)/1e3,'--b')
    grid on
    % axis equal
    xlabel('-Along Track (km)')
    ylabel('Radial (km)')    
    
    title('Chaser Reference Trajectory')
    text(-70, 33,'Initial Position')
    plot(-along_p(1), radial_p(1),'xr')
    xlim([-75,10])
    ylim([-0.3e1, 3.5e1])
    legend('1km ahead target position','Reference Trajectory', '',...
        Location='best')
    %plot(-along_p, radial_p)
end

%% error plot
if(1)
    error = ref - output;
    % pos
    figure(3)
    plot(time,error(:,1:3));
    legend('ex','ey','ez')
    ylabel('error (m)')
    xlabel('time (s)')
    title(join([names(LQR_ON+1),' Position Error',dist(disturbance_gain+1)],""))
    grid on
    % print(join([filepath,"pos error"]," "),'-dpng')

    % vel
    figure(4)
    plot(time,error(:,4:6));
    legend('eu','ev','ew')
    ylabel('error (m/s)')
    xlabel('time (s)')
    title(join([names(LQR_ON+1),' Velocity Error',dist(disturbance_gain+1)],""))
    grid on
    % print(join([filepath,"vel error"]," "),'-dpng')

end
%% control action plot
if(1)
    figure(5)
    plot(time,input(:,1:3));
    legend('ux','uy','uz')
    ylabel('Control Effort (N)')
    xlabel('time (s)')
    title(join([names(LQR_ON+1),' Control Effort ',dist(disturbance_gain+1)],""))
    grid on
    % print(join([filepath,"effort"]," "),'-dpng')
end

%% x plot
if(0)
    figure(6)
    plot(time, radial_p,'-r')
    hold on
    plot(time, ref(:,1),'--b')
    xlabel('time')
    ylabel('radial position (m)')
    title('x position')
end
%% y plot
if(0)
    figure
    plot(time, along_p,'-r')
    hold on
    plot(time, ref(:,2),'--b')
    xlabel('time')
    ylabel('along track position (m)')
    title('y position')
end

%% 1st transfer
if (0)
    first = time < 1000;
        error = ref - output;
    % pos
    figure(3)
    plot(time(first),error(first,1:3));
    legend('ex','ey','ez')
    ylabel('error (m)')
    xlabel('time (s)')
    title('Position Error for 1st maneuver')
    grid on

    % vel
    figure(4)
    plot(time(first),error(first,4:6));
    legend('eu','ev','ew')
    ylabel('error (m/s)')
    xlabel('time (s)')
    title('Velocity Error for 1st maneuver')
    grid on
end
% [radial_p(end-10:end),out.tout(end-10:end)]z=
% 
% transfer_ref.x = radial_p;
% transfer_ref.y = along_p;
% transfer_ref.z = cross_p;
% transfer_ref.u = radial_v;
% transfer_ref.v = along_v;
% transfer_ref.w = cross_v;
% transfer_ref.t = out.tout;
% 
% %save 'transfer_ref' transfer_ref