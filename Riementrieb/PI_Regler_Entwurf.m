tr = 1;
Ue = 30;

%s = tf('s','tustin',parSys.TsID)

Omegac = 1.2 / tr
Omega0 = 2 / parSys.TsID

Phi = 70 - Ue

[Gm,Pm,Wgm,Wpm] = margin(G1) 

TI = 1/Omegac * atan(Pm - Phi)

Rtemp = tf([1, TI],[1],'tustin',parSys.TsID)