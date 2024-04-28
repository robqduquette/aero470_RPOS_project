function [] = plotPoleLims(tr, ts, os, p, z)
    % plotPoleLims takes a desired rise time, settling time, and overshoot
    % percentage and plots the pole locations that satisfy the
    % requirements. The poles and zeros of the function are also plotted.

    % reqs -> dominant pole locations
    rise_rad = 2/tr; % dominant poles must be outside this circle
    settle_lim = -4/ts; % dominant poles must be left of re = settle_lim
    damp_slope = 5/(3*(os-1));
    theta = linspace(0,2*pi,360);
    
    % polygon vertices
    bound_points = [settle_lim-1, damp_slope*(settle_lim-1);
                    settle_lim, damp_slope*settle_lim;
                    settle_lim, -damp_slope*settle_lim;
                    settle_lim-1, -damp_slope*(settle_lim-1)];
    
    bad_points = [1, - damp_slope*(settle_lim-1);
                       1, damp_slope*(settle_lim-1);
                       bound_points];
    
    % good_points = [-4, -damp_slope*(settle_lim-1);
    %                  -4,  damp_slope*(settle_lim-1);
    %                  bound_points];
    
    %% plot poles, zeros, requirements
    figure
    % requirements
    %fill(good_points(:,1), good_points(:,2),'green','FaceAlpha',0.1,'EdgeAlpha',0);
    hold on
    fill(bad_points(:,1), bad_points(:,2),'red','FaceAlpha',0.1,'EdgeAlpha',0.5,'EdgeColor','red');
    hold on
    fill(rise_rad*sin(theta), rise_rad*cos(theta),'red','FaceAlpha',0.1,'EdgeAlpha',0.5,'EdgeColor','red');
    plot([0,0],[damp_slope*(settle_lim-1),-damp_slope*(settle_lim-1)],'-k')
    % poles and zeros
    scatter(real(p),imag(p), 'rx')
    scatter(real(z),imag(z), 'bo')
    grid on
    xlabel('Real Axis')
    ylabel('Imaginary Axis')
    title(['Valid Pole Locations'])
    
    
    legend('Invalid','','',['Poles (',num2str(length(p)),')'],['Zeros (',num2str(length(z)),')'],'Location','northeast')
    
    % min and max bounds
    poi = [p(:); z(:); 0; bound_points(2:3,1)+bound_points(2:3,2)*1i];
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