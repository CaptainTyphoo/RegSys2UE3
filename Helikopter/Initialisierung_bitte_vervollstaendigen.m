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

%Ruhelage des vereinfachten Modells
q1 = 0;
sysPar.xR = [q1,0,0.3249487013,0,0,0];

% Systemparameter des vollst�ndigen Modells
set_parameter_vollstaendigesModell;

%% Setzen der Reglerparameter - Bitte anpassen!

% Reglerparameter q1
regPar.k13 = 1;
regPar.k12 = 1;
regPar.k11 = 1;
regPar.k10 = 1;
regPar.k1I = 1;
% Reglerparameter q2
regPar.k21 = 1;
regPar.k20 = 1;
regPar.k2I = 1;