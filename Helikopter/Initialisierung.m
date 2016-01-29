%% Parameterdatei Helikopter
%  ?bung Regelungssysteme
%
%  Ersteller: T.Gl?ck
%  Erstellt:  03.11.2009
%  ?nderungen: Boeck, Okt. 2010
%
%%
clear all;
close all;
clc

s=tf('s');

%% Setzen der Systemparameter des vereinfachten und des vollst?ndigen Modells

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

%% Parameter f?r Trajektorienplanung

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



%% Systemparameter des vollst?ndigen Modells
set_parameter_vollstaendigesModell;

%% Setzen der Reglerparameter - Bitte anpassen!

% Reglerparameter q1

p1 = poly([-1.8,-0.1,-3.6,-0.8,-0.4]);
%p1 = poly([-1.5,-1.5,-1.5,-1.5,-1.5]);

regPar.k13 = p1(2);
regPar.k12 = p1(3);
regPar.k11 = p1(4);
regPar.k10 = p1(5);
regPar.k1I = p1(6);

p2 = poly([-1.3,-1.9,-0.5]);
%p2 = poly([-1.5,-1.5,-1.5]);

% Reglerparameter q2
regPar.k21 = p2(2);
regPar.k20 = p2(3);
regPar.k2I = p2(4);