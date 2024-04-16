function [] = showFrame(rotMat, postfix)
    arguments
        rotMat (3,3) double
        postfix (1,1) string = ""
    end
    txt = {"x","y","z"};
    clr = {'r','g','b'};
    plot3(0,0,0);
    hold on
    for i = 1:3
        %quiver3(zeros(3,1),zeros(3,1),zeros(3,1),rotMat(:,1),rotMat(:,2),rotMat(:,3),Color=clr);
        x = rotMat(1,i);
        y = rotMat(2,i);
        z = rotMat(3,i);
        quiver3(0,0,0,x,y,z,Color=clr{i});
        text(x,y,z,strjoin([txt{i},"_{",postfix,"}"]));
    end
    xlabel('x');
    ylabel('y');
    zlabel('z');
    lim = [-2,2];
    xlim(lim)
    ylim(lim)
    zlim(lim)
end
