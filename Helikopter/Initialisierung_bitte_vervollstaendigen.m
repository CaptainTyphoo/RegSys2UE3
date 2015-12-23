%% Parameterdatei Helikopter
%  �bung Regelungssysteme
%
%  Ersteller: T.Gl�ck
%  Erstellt:  03.11.2009
%  �nderungen: Boeck, Okt. 2010
%
%%
clear all;
close all;
clc

s=tf('s');

%% Setzen der Systemparameter des vereinfachten und des vollst�ndigen Modells

%Abtastzeit
Ta = 1e-3;
% Systemparameter des vereinfachten Modells
sysPar.a1 = -1.1713;
sysPar.a2 =  0.3946;
sysPar.a3 = -0.5326;

sysPar.b1 = -0.6354;
sysPar.b2 = -0.6523;
sysPar.b3 =  4.6276;

% Systemparameter des vollst�ndigen Modells
set_parameter_vollstaendigesModell;

%% Setzen der Reglerparameter - Bitte anpassen!

% Reglerparameter q1
lambda = -1;
p=poly(lambda * eye(6));
regPar.k13 = p(2);
regPar.k12 = p(3);
regPar.k11 = p(4);
regPar.k10 = p(5);
regPar.k1I = p(6);

% Reglerparameter q2
lambda = -1;
p=poly(lambda * eye(4));
regPar.k21 = p(2);
regPar.k20 = p(3);
regPar.k2I = p(4);

%% Parameter für Trajektorienplanung
trajPar.beta1 = 0;
trajPar.beta2 = 0;
trajPar.beta3 = 0;
trajPar.beta4 = 0;
trajPar.beta5 = 126;
trajPar.beta6 = -420;
trajPar.beta7 = 540;
trajPar.beta8 = -315;
trajPar.beta9 = 70;

q20       = q20;
q2T       = 0;
Tq2_start = 0;
Tq2_ende  = 5;

q10       = 0;
q1T       = 2*pi;
Tq1_start = 5;
Tq1_ende  = 15;



