%% �bung Regelungssysteme  
% Parameterdatei und Berechnungsdatei zur Simulation des Riementriebs
%
% Ersteller:    WK, 01.11.2009
% �nderungen:   FM, 02.11.2010
%               FM, 12.07.2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;
s=tf('s');

%% Parameter des Systems Riementrieb
parSys.Il  = 4e-5;     %Tr�gheitsmoment Last
parSys.cr1 = 10;       %lineare Steifigkeit Riemen
parSys.cr3 = 1e6;      %kubische Steifigkeit Riemen (1e6)
parSys.dl  = 0.001;    %visk. D�mpfung Last
parSys.rl  = 0.05;     %Radius Riemenscheibe Last
parSys.Im  = 0.5e-5;   %Tr�gheitsmoment Motor
parSys.dm  = 0.01;     %viskose D�mpfung Motor
parSys.rm  = 0.025;    %Radius Riemenscheibe Motor
parSys.Rm  = 1.388;    %Widerstand PSM
parSys.Lm  = 1.475e-3; %Induktivit�t PSM
parSys.p   = 2.0;      %Polpaarzahl PSM
parSys.Phi = 2.715e-2; %Fluss Permanentmagnet PSM

% Abtastzeit der internen Dynamik
parSys.TsID = 0.1e-3;

%% Anfangsbedingungen des Systems Riementrieb
parSys.omegam_0  = 0;  %AB omegam
parSys.iq_0      = 0;  %AB iq
parSys.id_0      = 0;  %AB id
parSys.epsilon_0 = 0;  %AB epsilon
parSys.omegal_0  = 0;  %AB omegal

%% Anfangsbedingungen der Internen Dynamik
parSys.eta_1_0  = 0;  %AB eta_1
parSys.eta_2_0  = 0;  %AB eta_2

%% Parameter des Sollwertfilters omegam
parReg.ppSFc    = [-10,-12,-14]*10;
parReg.cpolySFc = poly(parReg.ppSFc);
parReg.AASF = [0,1,0;
               0,0,1;
               -parReg.cpolySFc(4),-parReg.cpolySFc(3),-parReg.cpolySFc(2)];
parReg.BBSF = [0;0;parReg.cpolySFc(4)];
parReg.CCSF = eye(3);
parReg.DDSF = zeros(3,1);
parReg.ssSF = ss(parReg.AASF,parReg.BBSF,parReg.CCSF,parReg.DDSF);
parReg.ratelim = 1000;     %maximale �nderung

%% Parameter des Sollwertfilters id
parReg.ppSFci    = [-10,-15];
parReg.cpolySFci = poly(parReg.ppSFci);
parReg.AASFi = [0,1;
                -parReg.cpolySFci(3),-parReg.cpolySFci(2)];
parReg.BBSFi = [0;parReg.cpolySFci(3)];
parReg.CCSFi = eye(2);
parReg.DDSFi = zeros(2,1);
parReg.ssSFi = ss(parReg.AASFi,parReg.BBSFi,parReg.CCSFi,parReg.DDSFi);

%% Parameter des Trajektorienfolgereglers
Il  = parSys.Il;     %Tr�gheitsmoment Last
cr1 = parSys.cr1;       %lineare Steifigkeit Riemen
cr3 = parSys.cr3;      %kubische Steifigkeit Riemen (1e6)
dl  = parSys.dl;    %visk. D�mpfung Last
rl  = parSys.rl;     %Radius Riemenscheibe Last
I_m = parSys.Im;   %Tr�gheitsmoment Motor
dm  = parSys.dm;     %viskose D�mpfung Motor
rm  = parSys.rm;    %Radius Riemenscheibe Motor
Rm  = parSys.Rm;    %Widerstand PSM
Lm  = parSys.Lm; %Induktivit�t PSM
p   = parSys.p;      %Polpaarzahl PSM
Phi = parSys.Phi; %Fluss Permanentmagnet PSM

A_e = [-0.1e1 / I_m * dm 0.3e1 / 0.2e1 / I_m * p * Phi 0 0.2e1 * rm * cr1 / I_m 0; -0.2e1 / 0.3e1 * p * Phi / Lm -0.2e1 / 0.3e1 * Rm / Lm 0 0 0; 0 0 -0.2e1 / 0.3e1 * Rm / Lm 0 0; -rm 0 0 0 rl; 0 0 0 -0.2e1 * rl * cr1 / Il -dl / Il;];
B_e = [0 0; 0.2e1 / 0.3e1 / Lm 0; 0 0.2e1 / 0.3e1 / Lm; 0 0; 0 0;];

sys_e = ss(A_e,B_e,diag([1,0,1,0,0]),0);

sys_e_d = c2d(sys_e,parSys.TsID);

G = tf(sys_e_d);

G1 = G(1,1)
G2 = G(3,2)

%bode(G1)
%hold on;
%bode(G2)

%d2c(G1,'tustin')

parRegomegam.Kp = 2;
parRegomegam.Ki = 1;

parRegid.Kp = 5;
parRegid.Ki = 1;
