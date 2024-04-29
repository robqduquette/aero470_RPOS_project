% clear
% clc

P = [10, 10, 10, 10, 10, 10];
I = [0.01, 0.01, 0.01, 0.1, 0.1, 0.1];
D = [50, 50, 40, 0, 0, 0];
N = [0.2, 0.2, 0.2, 100, 100, 100];

for x = 1:1:6
    sys(x) = tf([P(x)+D(x)*N(x), P(x)*N(x)+I(x), I(x)*N(x)],[1,0,N(x)]);
end

sys_tf = zeros(3,6);
sys_tf = tf(sys_tf);

sys_tf(1,1) = sys(1);
sys_tf(2,2) = sys(2);
sys_tf(3,3) = sys(3);
sys_tf(1,4) = sys(4);
sys_tf(2,5) = sys(5);
sys_tf(3,6) = sys(6);

H1 = transpose(H);
T = (H1*sys_tf)/(1+(H1*sys_tf))

bode(T)