function Nulldynamik_S(block)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beschreibung: Simulationsmodell eines RRP-Robotors.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs:   u1(1)... M1       ( Drehmoment f�r Stab 1 )
%           u1(2)... M2       ( Drehmoment f�r Stab 2 )
%           u1(3)... F        ( Kraft      f�r Stab 3 )
%
%
% states:   x(1)... phi1      ( Winkel Stab 1  )
%           x(2)... phi2      ( Winkel Stab 2  )     
%           x(3)... s         ( Weg    Stab 3  )     
%           x(4)... phi1p     ( Winkelgeschwindigkeit Stab 1 )
%           x(5)... phi2p     ( Winkelgeschwindigkeit Stab 2 )
%           x(6)... sp        ( Geschwindigkeit       Stab 3 )
%
% outputs:  y1(1..3)...q      ( generalisierte Koordinaten )
%           y2(1..3)...qp     ( generalisierte Geschwindigkeiten )
%           y3.........det(D) ( Determinante der Massenmatrix )
%
% parameters:
%           p(1)... m1        ( Masse Stab 1 )
%           p(2)... m2        ( Masse Stab 2 )
%           p(3)... m3        ( Masse Stab 3 )
%           p(4)... mL        ( Last )
%           p(5)... l1        ( L�nge Stab 1 )
%           p(6)... l2        ( L�nge Stab 2 )
%           p(7)... l3        ( L�nge Stab 3 )
%           p(8)... Ixx1      ( Tr�gheitsmoment x Stab 1 )
%           p(9)... Iyy1      ( Tr�gheitsmoment y Stab 1 )
%           p(10)...Izz1      ( Tr�gheitsmoment z Stab 1 )
%           p(11)...Ixx2      ( Tr�gheitsmoment x Stab 2 )
%           p(12)...Iyy2      ( Tr�gheitsmoment y Stab 2 )
%           p(13)...Izz2      ( Tr�gheitsmoment z Stab 2 )
%           p(14)...Ixx3      ( Tr�gheitsmoment x Stab 3 )
%           p(15)...Iyy3      ( Tr�gheitsmoment y Stab 3 )
%           p(16)...Izz3      ( Tr�gheitsmoment z Stab 3 )
%           p(17)...d1        ( D�mpferkonstante Stab 1 )
%           p(18)...d2        ( D�mpferkonstante Stab 2 )
%           p(19)...d3        ( D�mpferkonstante Stab 3 )
%           p(20)...phi10     ( Anfangswinkel Stab 1 )  
%           p(21)...phi20     ( Anfangswinkel Stab 2 )  
%           p(22)...s0        ( Anfangsweg    Stab 3 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sample Time: Continuous
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% created:  Kam, 29.10.2008
% changed:  Kam, 09.11.2009, y3 erstellt 
%           BM, 10.10.2011: L�schen der Berechnung der Systemmatrizen und
%           Beschleunigungen in mdlOutput, da sie nicht ben�tigt werden
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           

setup(block);


function setup(block)
  
  % Register number of input and output ports
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 2;
  
  % Register number of continuous states
  block.NumContStates = 2;
  
  % Register dialog parameter
  block.NumDialogPrms = 1; 
  
  % Port dimensions
  block.InputPort(1).Dimensions        = 1;
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(1).DirectFeedthrough = false;
  block.InputPort(2).Dimensions        = 1;
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(2).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = 1;
  block.OutputPort(1).SamplingMode = 'Sample';  
  block.OutputPort(2).Dimensions       = 1;
  block.OutputPort(2).SamplingMode = 'Sample';  
    
  % Set block sample time to continuous time
  block.SampleTimes = [0 0];
  
  % Register methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions); 
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Derivatives',             @Derivatives);
  block.RegBlockMethod('Terminate',               @Terminate);


function InitConditions(block)
  eta_1_0 = block.DialogPrm(1).Data.eta_1_0;  
  eta_2_0 = block.DialogPrm(1).Data.eta_2_0;  
  
  x0(1) = eta_1_0;
  x0(2) = eta_2_0;
  
  block.ContStates.Data=x0;
  
function Output(block)
  x = block.ContStates.Data;
 
  % Ausgangsgr��en:
  y1(1) = x(1);

  y2(1) = x(2);
  
  block.OutputPort(1).Data = y1;
  block.OutputPort(2).Data = y2;
  



function Derivatives(block)

  x = block.ContStates.Data;
  u1 = block.InputPort(1).Data;
  u2 = block.InputPort(2).Data;

  % Variablen definieren f�r bessrer Code-Lesbarkeit
  Ml   = u1(1);
  omegam = u2(1);
   
  epsilon  = x(1);
  omegal   = x(2);
  
  Il  = block.DialogPrm(1).Data.Il;
  cr1 = block.DialogPrm(1).Data.cr1;
  cr3 = block.DialogPrm(1).Data.cr3;
  dl  = block.DialogPrm(1).Data.dl;
  rl  = block.DialogPrm(1).Data.rl;
  Im  = block.DialogPrm(1).Data.Im;
  dm  = block.DialogPrm(1).Data.dm;
  rm  = block.DialogPrm(1).Data.rm;
  Rm  = block.DialogPrm(1).Data.Rm;
  Lm  = block.DialogPrm(1).Data.Lm;
  p   = block.DialogPrm(1).Data.p;
  Phi = block.DialogPrm(1).Data.Phi;

  
  etap = [omegal * rl - omegam * rm 1 / Il * (-2 * (cr3 * epsilon ^ 3 + cr1 * epsilon) * rl - dl * omegal + Ml)];

  % Differentialgleichungen:
  dx(1) = etap(1);
  dx(2) = etap(2);
   
  block.Derivatives.Data=dx;          

function Terminate(block)

