function [] = plotTarget(dir,spec)
%PLOTTARGET Summary of this function goes here
%   Detailed explanation goes here
    hold on;
    quiver3(0,0,0,dir(1),dir(2),dir(3),2,spec,LineWidth=2,ShowArrowHead="on");
end

