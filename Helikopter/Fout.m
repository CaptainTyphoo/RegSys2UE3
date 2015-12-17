function out = Fout(u1,u2,u3,u4,u5,u6,u7,u8,u9,p)

%**************************************************************************
% Auslesen der Parameterwerte
m_Mast = p.m_Mast;m_Arm = p.m_Arm;m_AH = p.m_AH;m_RR = p.m_RR;m_RL = p.m_RL;
a01x = p.a01x; a01y = p.a01y; a01z = p.a01z;
a12x=p.a12x;a12y=p.a12y;a12z=p.a12z;a23x=p.a23x;a23y=p.a23y;a23z=p.a23z;
a34x=p.a34x;a34y=p.a34y;a34z=p.a34z;a35x=p.a35x;a35y=p.a35y;a35z=p.a35z;
I_Mast = p.I_Mast; I_Arm = p.I_Arm; I_AH = p.I_AH; I_RR = p.I_RR; I_RL = p.I_RL;
x_Mast=p.x_Mast;y_Mast=p.y_Mast;z_Mast=p.z_Mast;x_Arm=p.x_Arm;y_Arm=p.y_Arm;
z_Arm=p.z_Arm;x_AH=p.x_AH;y_AH=p.y_AH;z_AH=p.z_AH;x_RR=p.x_RR;y_RR=p.y_RR;
z_RR=p.z_RR;x_RL=p.x_RL;y_RL=p.y_RL;z_RL=p.z_RL;
R_RR = p.R_RR;R_RL = p.R_RL;L_RR = p.L_RR;L_RL = p.L_RL;kM_RR = p.kM_RR;
kM_RL = p.kM_RL;ku_RR = p.ku_RR;ku_RL = p.ku_RL;
da_RR=p.da_RR;da_RL=p.da_RL;dL_RR=p.dL_RR;dL_RL=p.dL_RL;
da_Mast=p.da_Mast;rC_Mast=p.rC_Mast;rH_Mast=p.rH_Mast;v0_Mast=p.v0_Mast;
da_Arm=p.da_Arm;rC_Arm=p.rC_Arm;rH_Arm=p.rH_Arm;v0_Arm=p.v0_Arm;da_AH=p.da_AH;
rC_AH=p.rC_AH;rH_AH=p.rH_AH;v0_AH=p.v0_AH;g = p.g;
kF_RL_up=p.kF_RL_up;kF_RR_up=p.kF_RR_up;kF_RL_down=p.kF_RL_down;kF_RR_down=p.kF_RR_down;

if u1 > 0 
    kF_RR = kF_RR_up;
else
    kF_RR = kF_RR_down;
end

if u2 > 0 
    kF_RL = kF_RL_up;
else
    kF_RL = kF_RL_down;
end
        
         
% Die beiden eingeprägten Rotorkräfte 
% (F_RR = kF_RR*q4p^2, F_RL = kF_RL*q5p^2) führen auf einen Vektor 
% psi der generalisierten Kräfte mit 5 Einträgen (entsprechend den 
% 5 mech. Freiheitsgraden). FM_Mast bezeichnet den ersten Eintrag 
% (q1 zugeordnet), FM_Arm den zweiten (q2 zugeordnet) und FM_AH den
% dritten Eintrag von psi. 

FM_Mast   = kF_RR*u8^2*(-a34x*sin(u3)-sin(u4)*cos(u3)*a23x+sin(u4)*sin(u3)*a23y)+kF_RL*u9^2*(a35x*sin(u3)-sin(u4)*...
             cos(u3)*a23x+sin(u4)*sin(u3)*a23y);
FM_Arm    = -kF_RR*u8^2*cos(u4)*a23x-kF_RL*u9^2*cos(u4)*a23x;
FM_AH     = kF_RR*u8^2*a34x-kF_RL*u9^2*a35x;

% Die nachfolgenden Größen Fg_Mast, Fg_Arm und Fg_AH bezeichnen die
% erste bis dritte Komponente der Ableitung der potentiellen
% Energie nach den generalisierten Koordinaten. 
Fg_Mast   = 0;
Fg_Arm    = m_Arm*g*(cos(u3)*x_Arm-sin(u3)*y_Arm)+m_AH*g*(-sin(u3)*sin(u4)*x_AH-sin(u3)*cos(u4)*y_AH-cos(u3)*z_AH-cos(u3)*a23x+sin(u3)*a23y)+m_RR*g*(-sin(u3)*cos(u4)*z_RR-sin(u3)*sin(u4)*a34x-1*cos(u3)*a23x+sin(u3)*a23y)+m_RL*g*(-1*sin(u3)*cos(u4)*z_RL+sin(u3)*sin(u4)*a35x-cos(u3)*a23x+sin(u3)*a23y);
Fg_AH     = m_AH*g*(cos(u3)*cos(u4)*x_AH-cos(u3)*sin(u4)*y_AH)+m_RR*g*(-cos(u3)*sin(u4)*z_RR+cos(u3)*cos(u4)*a34x)+m_RL*g*(-cos(u3)*sin(u4)*z_RL-cos(u3)*cos(u4)*a35x);


% out(2) bezeichnet die generalisierte Kraft auf q1, out(4)
% diejenige auf q2 und out(6) diejenige auf q3, jeweils zufolge der
% Rotor- und Gewichtskräfte. 
out(1)=u5;
out(2)=FM_Mast-Fg_Mast;
out(3)=u6;
out(4)=FM_Arm-Fg_Arm;
out(5)=u7;
out(6)=FM_AH-Fg_AH;

% Die entstehenden Kräfte werden als Maß herangezogen, ob die
% jeweilige Achse den Bereich der Haftreibung verlässt bzw. in
% diesen eintritt. Dabei werden jedoch andere Effekte wie z.B.
% Zentrifugalkräfte vernachlässigt (beispielsweise kann eine
% schnelle Drehung des Mastes einen nicht exakt horizontal
% ausgerichteten Arm aus der Haftreibung reißen). 

