function Nulldynamik(block)
% Kommentare

setup(block);


function setup(block)
  
  % Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 2;
  
  % Register number of continuous states
  block.NumContStates = 2;
  
  % Register dialog parameter
  block.NumDialogPrms = 3; 
  
  % Port dimensions
  block.InputPort(1).Dimensions        = 3;
  block.InputPort(1).SamplingMode = 'Sample';
  block.InputPort(1).DirectFeedthrough = false;
  
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
  x10 = block.DialogPrm(1).Data;  
  x20 = block.DialogPrm(2).Data;  
  
  x0(1) = x10;
  x0(2) = x20;

  block.ContStates.Data=x0;
  
function Output(block)
  x = block.ContStates.Data;
  %u1 = block.InputPort(1).Data;
 
  % Variablen definieren f?r bessere Code-Lesbarkeit
  %u   = u1(1);

  x1  = x(1);
  x2  = x(2);
  
  % Ausgangsgr??en:
  %x1 = epsilon
  y1(1) = x1;
  %x2 = wl
  y1(2) = x2;
 
  
  
  block.OutputPort(1).Data = y1(1);
  block.OutputPort(2).Data = y1(2);
%   block.OutputPort(3).Data = y3;
  



function Derivatives(block)

  x = block.ContStates.Data;
  u1 = block.InputPort(1).Data;
  Ml = 0;
  params = block.DialogPrm(3).Data;
  
  u   = u1(1);
   
  x1  = x(1);
  x2  = x(2);
  
  cr1 = params(1);
  cr3 = params(2);
  rl = params(3);
  rm = params(4);
  dl = params(5);
  Il = params(6);
  

  % Differentialgleichungen:
  dx(1) = rl*x2 - rm*u;
  Fr = cr1*x1 + cr3*x1^3;
  dx(2) = 1/Il*(-2*Fr*rl-dl*x2 + Ml);

   
  block.Derivatives.Data=dx;          

function Terminate(block)