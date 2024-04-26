clear
close all

%% system parameters
n = 0.00110851126424986; %2*pi/(60); % Hz
m = 100; % kg

%% State space model
% state is (x,y,z,u,v,w)
A = zeros(6,6);
A(1:3,4:6) = eye(3);
A(4,1) = 3*n^2;
A(6,3) = -n^2;
A(5,4) = -2*n;
A(4,5) = 2*n;

B = [zeros(3,3);eye(3)/m];
C = eye(6);
D = zeros(6,3);

%% get transfer functions
tol = 1e-500; % what tolerance to cutoff
for i = 1:size(B, 2) % Loop over each input
    [num_ex, den_ex] = ss2tf(A, B, C, D, i);
    num = (abs(num_ex)>tol).*num_ex;
    den = (abs(den_ex)>tol).*den_ex;
    % Loop over each output
    for j = 1:size(C, 1) % Assuming output size matches C's row count
        % Store each transfer function in the cell array
        H{i, j} = tf(num(j, :), den);
        H_ex{i,j} = tf(num_ex(j,:),den_ex);
    end
end
% where H{input, output} is the tf of input to output

%% look at bode plot
makeplots = false;
showtf = true;
verbose = false;
save_figs = false;
in = 1;
out =1;
skip = [1, 3;
        1, 6;
        2, 3;
        2, 6;
        3, 1;
        3, 2;
        3, 4;
        3, 5];
if makeplots
    for i = 1:3
        for j = 1:6
            if any(sum((skip == [i,j])')==2) % if is in skip list
                if verbose 
                    disp(['Skipping (',num2str([i,j]),')' ])
                end
                continue
            end
            in = i;
            out = j;
            f = figure;
            tf = H{in,out};
            poles = roots(tf.Denominator{1});
            zeros = roots(tf.Numerator{1});
            bode(tf)
            title({'Bode Plot',['input = ',num2str(in),', output = ',num2str(out)]})
            grid on
            if showtf
                annotation('textbox',[0.7 0.68 0.2 0.2],'String',{'Poles:',num2str(poles')},'EdgeColor','None','FontName','Consolas','HorizontalAlignment','right')
                annotation('textbox',[0.16 0.68 0.2 0.2],'String',{'Zeros:',num2str(zeros')},'EdgeColor','None','FontName','Consolas','HorizontalAlignment','left')
            end
            % save figures
            if save_figs
                name = ['bode_',num2str(i),'_',num2str(j)];
                print(name, '-dpng')
            end
        end
    end
end
% % exact
% f_ex = figure;
% f_ex.Position(1) = f.Position(1);
% f_ex.Position(2) = f.Position(2)-480;
% 
% tf_ex = H_ex{in,out};
% poles_ex = roots(tf_ex.Denominator{1});
% bode(tf_ex)
% title('exact')

%%
figure
nyquist(H_ex{1,1},'-r')
grid on
xlim([-10,10])
ylim([-2,2])

%%
figure 
pzmap(H_ex{1,1})