clear
load reftrajWIP.mat
close all

u_ref = logsout{1}.Values;
v_ref = logsout{2}.Values;
w_ref = logsout{3}.Values;
x_ref = logsout{4}.Values;
y_ref = logsout{5}.Values;
z_ref = logsout{6}.Values;

%% interpolate to constant time step
dt = 1; %s
tspan = [0,6000];
[x_intp, time] = datsetInterpolate(dt, tspan, x_ref.Data, x_ref.Time);
[y_intp] = datsetInterpolate(dt, tspan, y_ref.Data, y_ref.Time);
[z_intp] = datsetInterpolate(dt, tspan, z_ref.Data, z_ref.Time);
[u_intp] = datsetInterpolate(dt, tspan, u_ref.Data, u_ref.Time);
[v_intp] = datsetInterpolate(dt, tspan, v_ref.Data, v_ref.Time);
[w_intp] = datsetInterpolate(dt, tspan, w_ref.Data, w_ref.Time);


%% moving avg filter
% get previous from extrapolate
window = 150;
tpast = [-window*dt:dt:0];

x_past = getPast(x_intp(1:window), time(1:window), tpast);
y_past = getPast(y_intp(1:window), time(1:window), tpast);
z_past = getPast(z_intp(1:window), time(1:window), tpast);

%% filter
[x_filter, u_filter, t_filter] = smoothfilter(x_intp,time,window,x_past);
[y_filter, v_filter] = smoothfilter(y_intp,time,window,y_past);
[z_filter, w_filter] = smoothfilter(z_intp,time,window,z_past);

%% plot
if(0)
figure
plot(time, x_intp)
hold on
plot(t_filter, x_filter)
legend('intp','filter')

figure
plot(time, u_intp)
hold on
plot(t_filter, u_filter)
legend('intp','filter')

figure
plot(time, y_intp)
hold on
plot(t_filter, y_filter)
legend('intp','filter')

figure
plot(time, v_intp)
hold on
plot(t_filter, v_filter)
legend('intp','filter')


% figure
% plot(time, z_intp)
% hold on
% plot(t_filter, z_filter)
% legend('intp','filter')
% 
% figure
% plot(time, w_intp)
% hold on
% plot(t_filter, w_filter)
% legend('intp','filter')
end

%% save to log
logsmooth = logsout;
logsmooth.Name = 'logsmooth'
logsmooth{4}.Values = timeseries(x_filter, t_filter,'Name','x_ref');
logsmooth{5}.Values = timeseries(y_filter, t_filter,'Name','y_ref');
logsmooth{6}.Values = timeseries(z_filter, t_filter,'Name','z_ref');
logsmooth{1}.Values = timeseries(u_filter, t_filter,'Name','u_ref');
logsmooth{2}.Values = timeseries(v_filter, t_filter,'Name','v_ref');
logsmooth{3}.Values = timeseries(w_filter, t_filter,'Name','w_ref');

save('ref_smooth_v1','logsmooth')

%% functions
function [past] = getPast(data,time,tpast) 
    f = fit(time(:),data(:),'poly2');
    p = [f.p1, f.p2, f.p3];
    past = polyval(p, tpast);
end

function [x_filter, dx_filter,t_filter] = smoothfilter(data, time, window, prev_data)
    b = ones(window,1)/window;
    [~, zf] = filter(b,1,prev_data);
    x_filter = filter(b,1,data,zf);
    dx_filter = diff(x_filter);

    x_filter = x_filter(window/2:end);
    dx_filter = dx_filter(window/2-1:end);
    t_filter = time(1:end - window/2 + 1);
end
   
function [y] = interp(t0,t1,y0,y1,t)
    y = y0 + (t-t0).*(y1 - y0)./(t1-t0);
end

function [data2, time2] = datsetInterpolate(dt, tspan, data, time)
    % checks
    assert(length(tspan) == 2)
    assert(dt > 0)
    assert(all(size(data) == size(time)))

    % create time vector
    time2 = tspan(1):dt:tspan(2);

    % set initial condition the same
    data2 = zeros(size(time2));
    data2(1) = data(1);

    % interpolate
    indx = 1; % of old data
    for i = 2:length(time2)
        t = time2(i);
        % find closest time
        while time(indx) < t;
            indx = indx + 1; % indx is 
        end
        data2(i) = interp(time(indx-1),time(indx),data(indx-1),data(indx),t);
        
        % disp([num2str(time(indx)),' for ', num2str(t)])
    end

end