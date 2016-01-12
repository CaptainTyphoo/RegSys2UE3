parameter;
Ta = parSys.TsID;

% linearisiertes Fehlersystem
Ae = [-dm / I_m 0.3e1 / 0.2e1 * Phi * p / I_m 0 0.2e1 * cr1 * rm / I_m 0; -0.2e1 / 0.3e1 * Phi * p / Lm -0.2e1 / 0.3e1 * Rm / Lm 0 0 0; 0 0 -0.2e1 / 0.3e1 * Rm / Lm 0 0; -rm 0 0 0 rl; 0 0 0 -0.2e1 * cr1 * rl / I_l -0.1e1 / I_l * dl;];
b = 2/(3*Lm)*[0 0;1 0;0 1;0 0;0 0];
c = [1,0,0,0,0;0,0,1,0,0];
d = zeros(2,2);

sys_c = ss(Ae,b,c,d);
sys_d = c2d(sys_c,Ta);
sys_tustin = d2c(sys_d,'tustin');
Gq = tf(sys_tustin);

% Frequenzkennlinienverfahren f?r Abtastsysteme

% ?bertragungsfktn von uq zu wm
G_uqwm = Gq(1,1);
% ?bertragungsfunktion von ud zu id
G_udid = Gq(2,2);

% PI Regler

% tr und ue direkt vorgeben
tr1 = 10e-3;
ue1 = 5;
[Rz1, R1] = PI_Entwurf(G_udid,tr1,ue1,Ta);

tr2 = 10e-3;
ue2 = 5;
[Rz2, R2] = PI_Entwurf(G_uqwm,tr2,ue2,Ta);

R1d = ss(Rz1);
R2d = ss(Rz2);

% Kontrolle
Gz = tf(sys_d);
T1 = feedback(Rz2*Gz(1,1),1);
T2 = feedback(Rz1*Gz(2,2),1);

p1=pole(T1);
p2=pole(T2);

% Pole beider geschlossenen Kreise innerhalb des Einheitskreises, 
% aber nicht phasenminimal

