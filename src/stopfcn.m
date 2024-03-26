


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
figure(1)
plot(radial_p, along_p)







