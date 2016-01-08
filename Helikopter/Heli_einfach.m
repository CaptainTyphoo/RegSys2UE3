function Heli_einfach(block)

% Kontinuierliches Modell des vereinfachten Helikopters
% Eingang: u = [v1,v2]
% Zustand: x = [q1,q1p,q2,q2p,q3,q3p]
% Ausgang: y = x

% Wichtig: ode113 verwenden (ode45 ist instabil)

setup(block);


function setup(block)
  
  % Register number of input and output ports
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 6;
  
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
  
  block.OutputPort(1).Dimensions       = 1;
  block.OutputPort(1).SamplingMode = 'Sample';  
  block.OutputPort(2).Dimensions       = 1;
  block.OutputPort(2).SamplingMode = 'Sample';
  block.OutputPort(3).Dimensions       = 1;
  block.OutputPort(3).SamplingMode = 'Sample';  
  block.OutputPort(4).Dimensions       = 1;
  block.OutputPort(4).SamplingMode = 'Sample'; 
  block.OutputPort(5).Dimensions       = 1;
  block.OutputPort(5).SamplingMode = 'Sample';  
  block.OutputPort(6).Dimensions       = 1;
  block.OutputPort(6).SamplingMode = 'Sample'; 
    
  % Set block sample time to continuous time
  block.SampleTimes = [0 0];
  
  % Register methods
  block.RegBlockMethod('InitializeConditions',    @InitConditions); 
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Derivatives',             @Derivatives);
  block.RegBlockMethod('Terminate',               @Terminate);


function InitConditions(block)
  
  % Startwerte definieren
  x_0 = block.DialogPrm(1).Data;   
  
  x0(1) = x_0(1);
  x0(2) = x_0(2);
  x0(3) = x_0(3);
  x0(4) = x_0(4);
  x0(5) = x_0(5);
  x0(6) = x_0(6);

  block.ContStates.Data=x0;
 
  
  
function Output(block)
  
% Ausgang = Zustand

  x = block.ContStates.Data;
  
  block.OutputPort(1).Data = x(1);
  block.OutputPort(2).Data = x(2);
  block.OutputPort(3).Data = x(3);
  block.OutputPort(4).Data = x(4);
  block.OutputPort(5).Data = x(5);
  block.OutputPort(6).Data = x(6); 




function Derivatives(block)

  % Zustände, Eingänge, Parameter laden
  x = block.ContStates.Data; 
  x1  = x(1);
  x2  = x(2);
  x3  = x(3);
  x4  = x(4);
  x5  = x(5);
  x6  = x(6);
  
  params =  block.DialogPrm(2).Data; 
  a1 = params(1);
  a2 = params(2);
  a3 = params(3);
  b1 = params(4);
  b2 = params(5);
  b3 = params(6);
  
  v1 = block.InputPort(1).Data;
  v2 = block.InputPort(2).Data;
  

  % Differentialgleichungen:
  dx(1) = x2;
  dx(2) = b1 * cos(x3) * sin(x5) * v1;
  dx(3) = x4;
  dx(4) = a1 * sin(x3) + a2 * cos(x3) + b2 * cos(x5) * v1;
  dx(5) = x6;
  dx(6) = a3 * cos(x3) * sin(x5) + b3 * v2;
  
   
  block.Derivatives.Data=dx;          

function Terminate(block)