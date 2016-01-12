
parameter;
Ta = parSys.TsID;

Ae = [-dm / I_m 0.3e1 / 0.2e1 * Phi * p / I_m 0 0.2e1 * cr1 * rm / I_m 0; -0.2e1 / 0.3e1 * Phi * p / Lm -0.2e1 / 0.3e1 * Rm / Lm 0 0 0; 0 0 -0.2e1 / 0.3e1 * Rm / Lm 0 0; -rm 0 0 0 rl; 0 0 0 -0.2e1 * cr1 * rl / I_l -0.1e1 / I_l * dl;];

b = 2/(3*Lm)*[0 0;1 0;0 1;0 0;0 0];

c = [1,0,0,0,0;0,0,1,0,0];
d = zeros(2,2);

sys_c = ss(Ae,b,c,d);
sys_d = c2d(sys_c,Ta);

sys_tustin = d2c(sys_d,'tustin');
Gq = tf(sys_tustin);

% Frequenzkennlinienverfahren


%?bertragungsfktn von uq zu wm
G_uqwm = Gq(1,1);
%?bertragungsfunktion von ud zu id
G_udid = Gq(2,2);

%erster PI Regler
omega_0 = 2/Ta;
%omega_c = 0.2*omega_0; %muss kleiner als 0.2*omega_0 sein
%tr = 1.2/omega_c;

tr1 = 10e-3;
ue1 = 5;
[Rz1, R1] = PI_Entwurf(G_udid,tr1,ue1,Ta);

tr2 = 10e-3;
ue2 = 5;
[Rz2, R2] = PI_Entwurf(G_uqwm,tr2,ue2,Ta);

Gz = tf(sys_d);

%geht nicht!
%Tz2 = Rz2*Gz(1,1)/(1+Rz2*Gz(1,1));
%Tz1 = Rz1*Gz(3,2)/(1+Rz1*Gz(3,2));



T1 = R1*G_udid/(1+R1*G_udid);

%die beiden Funktionen liefern (zum Gl?ck) das gleiche :)
T2 = minreal((R2*G_uqwm)/(1+R2*G_uqwm));
%T2 = feedback(R2*G_uqwm,1);


Tz1 = c2d(T1,Ta,'tustin');
Tz2 = c2d(T2,Ta,'tustin');
%Tz2 = feedback(Rz2*Gz(1,1),1);
 

%step(feedback(R2*G_uqwm,1));

R1d = ss(Rz1);
R2d = ss(Rz2);
