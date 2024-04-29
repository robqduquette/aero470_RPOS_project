function [] = plotPoleLims(tr, ts, os, p, z)
    % plotPoleLims takes a desired rise time, settling time, and overshoot
    % percentage and plots the pole locations that satisfy the
    % requirements. The poles and zeros of the function are also plotted.

    % reqs -> dominant pole locations
    rise_rad = 2/tr; % dominant poles must be outside this circle
    settle_lim = -4/ts; % dominant poles must be left of re = settle_lim
    damp_slope = (os ~= 1)*5/(3*(os*(os ~= 1)-1)); 
    theta = linspace(0,2*pi,360);
    
    % polygon vertices
    ospoints = [settle_lim-100, damp_slope*(settle_lim-100);
                    0,0;
                    settle_lim-100, -damp_slope*(settle_lim-100)];

    tspoints = [settle_lim, -1e10;
                settle_lim, 1e10];
    
    bad_os_points = [100, - damp_slope*(settle_lim-100);
                       100, damp_slope*(settle_lim-100);
                       ospoints];

    bad_ts_points = [1, -1e10;   
                     tspoints;
                     1, 1e10;];
    
    % good_points = [-4, -damp_slope*(settle_lim-1);
    %                  -4,  damp_slope*(settle_lim-1);
    %                  bound_points];
    
    %% plot poles, zeros, requirements
    figure  
    fill(rise_rad*sin(theta), rise_rad*cos(theta),'red','FaceAlpha',0.1,'EdgeAlpha',0.5,'EdgeColor','red');   
    hold on
    fill(bad_os_points(:,1), bad_os_points(:,2),'red','FaceAlpha',0.1,'EdgeAlpha',0.5,'EdgeColor','red');
    fill(bad_ts_points(:,1), bad_ts_points(:,2),'red','FaceAlpha',0.1,'EdgeAlpha',0.5,'EdgeColor','red');
    plot([0,0],[1e10,-1e10],'-k') % im axis
    plot([-1e10,1e10],[0,0],'-k') % re axis
    % poles and zeros
    scatter(real(p),imag(p), 'rx')
    scatter(real(z),imag(z), 'bo')
    grid on
    xlabel('Real Axis')
    ylabel('Imaginary Axis')
    title(['Valid Pole Locations'])
    
    
    legend('Invalid','','','','',['Poles (',num2str(length(p)),')'],['Zeros (',num2str(length(z)),')'],'Location','northeast')
    
    % min and max bounds
    poi = [p(:); z(:); 0]; % bound_points(2:3,1)+bound_points(2:3,2)*1i
    if (length(poi) < 2)
        poi = [poi; ; -1+1i; 1-1i];
    end
    minx = min(real(poi));
    maxx = max(real(poi));
    rangex = maxx - minx;
    miny = min(imag(poi));
    maxy = max(imag(poi));
    rangey = maxy - miny;
    margin = 0.5;
    xlim([minx-margin*rangex,maxx+margin*rangex])
    ylim([miny-margin*rangey, maxy+margin*rangey])
end 