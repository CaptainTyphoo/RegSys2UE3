% Systemparameter
c=10;
d1=0.5;
d2=0.5;
m=1;
g=9.81;
l=0.5;
I1=1;
I2=1;

par = [c,d1,d2,m,g,l,I1,I2];

x2a = -pi/2;
x2e = pi/2;

sysPar.beta5 =  126;
sysPar.beta6 = -420;
sysPar.beta7 =  540;
sysPar.beta8 = -315;
sysPar.beta9 =   70;
sysPar.Ta = 1e-3;

% linearisiertes System um obere Ruhelage
x2R = pi/2;
A = [0 0 1 0; 0 0 0 1; -c / I1 c / I1 -d1 / I1 0; c / I2 -c / I2 + m * g * l / I2 * sin(x2R) 0 -d2 / I2];
b = [0; 0; 0.1e1 / I1; 0];
c = [0 1 0 0];
d = 0;

%%
for i=[1,10,15,20,50]
sys = ss(A,b,c,d);
sys_d = c2d(sys,sysPar.Ta);
reg = tf(1,1);
T = feedback(sys*i,1);
bode(sys*i);
grid on
hold on
end
legend('1','10','15','20','50');

%% 
cg=1;
kp=[1:1:15];
plot(kp,1000 * cg ^ 4 + 1000 * cg ^ 3 + 15340 * cg ^ 2 + 7547 * cg + 10000 * kp - 49050);