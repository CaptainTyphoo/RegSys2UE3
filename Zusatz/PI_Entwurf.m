function [ Rz, R ] = PI_Entwurf( G, tr, ue, Ta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

phi = 70 - ue;
omega_c = 1.2/tr;

s = tf('s');

L1 = 1/s*G;
L1_c = evalfr(L1,1i*omega_c);
%absL1 = abs(L1_c);
argL1 = angle(L1_c)*180/pi;
if (argL1 > 180)
    argL1 = argL1 - 360;
end

argsoll = -180+phi;
delta_arg = argsoll - argL1;

Ti = tan(delta_arg*pi/180)/omega_c;

L2 = L1*(1+Ti*s);
L2_c = evalfr(L2,1i*omega_c);
V = 1/abs(L2_c);

R = V*(1+Ti*s)/s;

Rz = c2d(R,Ta,'tustin');

end

