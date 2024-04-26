


%% get data
logsout = out.logsout;

% indices
indx.radial_p = 4;
indx.radial_v = 1;
indx.along_p = 5;
indx.along_v = 2;
indx.cross_p = 6;
indx.cross_v = 3;

% check
radial_p = logsout{indx.radial_p}.Values.Data;
assert("x" == logsout{indx.radial_p}.Name)
radial_v = logsout{indx.radial_v}.Values.Data;
assert("u" == logsout{indx.radial_v}.Name)

along_p = logsout{indx.along_p}.Values.Data;
assert("y" == logsout{indx.along_p}.Name)
along_v = logsout{indx.along_v}.Values.Data;
assert("v" == logsout{indx.along_v}.Name)

cross_p = logsout{indx.cross_p}.Values.Data;
assert("z" == logsout{indx.cross_p}.Name)
cross_v = logsout{indx.cross_v}.Values.Data;
assert("w" == logsout{indx.cross_v}.Name)

%% Plots
close all
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

if(1)
    figure(2)
    plotTarget([-8e3,0,0],'sr');
    hold on
    comet(-along_p, radial_p)
    grid on
    axis equal
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