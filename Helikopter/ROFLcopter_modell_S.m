function ROFLcopter_modell_S(block)
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
  block.NumOutputPorts = 1;
  
  % Register number of continuous states
  block.NumContStates = 6;
  
  % Register dialog parameter
  block.NumDialogPrms = 2; 
  
  % Port dimensions
  block.InputPort(1).Dimensions        = 1;
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(1).DirectFeedthrough = false;
  block.InputPort(2).Dimensions        = 1;
  block.InputPort(2).SamplingMode = 'Sample';
  block.InputPort(2).DirectFeedthrough = false;
  
  block.OutputPort(1).Dimensions       = 6;
  block.OutputPort(1).SamplingMode = 'Sample';  
    
  % Set block sample time to continuous time
  block.SampleTimes = [0 0];
  
  % Register methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions); 
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Derivatives',             @Derivatives);
  block.RegBlockMethod('Terminate',               @Terminate);


function InitConditions(block)
  initCond = block.DialogPrm(2).Data;  
  
  x0 = initCond(1:6);
  
  block.ContStates.Data=x0;
  
function Output(block)
  x = block.ContStates.Data;
 
  % Ausgangsgr��en:
  y1 = x;
  
  block.OutputPort(1).Data = y1;
  



function Derivatives(block)

  x = block.ContStates.Data;
  v1 = block.InputPort(1).Data;
  v2 = block.InputPort(2).Data;
  sysPar = block.DialogPrm(1).Data;  
  a1 = sysPar.a1;
  a2 = sysPar.a2;
  a3 = sysPar.a3;
  b1 = sysPar.b1;
  b2 = sysPar.b2;
  b3 = sysPar.b3;

  % Variablen definieren f�r bessrer Code-Lesbarkeit
  q1 = x(1);
  q2 = x(3);
  q3 = x(5);
  omega1 = x(2);
  omega2 = x(4);
  omega3 = x(6);
  
  x1p = omega1;
  x2p = v1 * b1 * cos(q2) * sin(q3);
  x3p = omega2;
  x4p = v1 * b2 * cos(q3) + a1 * sin(q2) + a2 * cos(q2);
  x5p = omega3;
  x6p = v2 * b3 + a3 * cos(q2) * sin(q3);

  % Differentialgleichungen:
  dx(1) = x1p;
  dx(2) = x2p;
  dx(3) = x3p;
  dx(4) = x4p;
  dx(5) = x5p;
  dx(6) = x6p;
   
  block.Derivatives.Data=dx;          

function Terminate(block)

