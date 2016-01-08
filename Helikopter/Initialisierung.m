%% Parameterdatei Helikopter
%  Übung Regelungssysteme
%
%  Ersteller: T.Glück
%  Erstellt:  03.11.2009
%  Änderungen: Boeck, Okt. 2010
%
%%
clear all;
close all;
clc

s=tf('s');

%% Setzen der Systemparameter des vereinfachten und des vollständigen Modells

%Abtastzeit
Ta = 1e-3;
sysPar.Ta=Ta;

% Systemparameter des vereinfachten Modells
sysPar.a1 = -1.1713;
sysPar.a2 =  0.3946;
sysPar.a3 = -0.5326;

sysPar.b1 = -0.6354;
sysPar.b2 = -0.6523;
sysPar.b3 =  4.6276;

%Ruhelage des vereinfachten Modells
q10e = 0;
q20e=0.319187912478128;  %0.3249487013 laut unserem Maple;
sysPar.xR = [q10e,0,q20e,0,0,0];

%% Parameter für Trajektorienplanung

%Anfangswerte = Ruhelagen

%Endwerte
q1d=2*pi;
q2d=0;

%Startzeitpunkt
sysPar.Tq1_s=10;
sysPar.Tq2_s=0;

% Dauer
sysPar.Tq1_d=10;
sysPar.Tq2_d=5;

% Vorsteuerungs-Polynom
sysPar.beta5 =  126;
sysPar.beta6 = -420;
sysPar.beta7 =  540;
sysPar.beta8 = -315;
sysPar.beta9 =   70;



%% Systemparameter des vollständigen Modells
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