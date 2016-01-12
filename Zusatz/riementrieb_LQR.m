
%Parameter
I_l  = 4e-5;     %Trägheitsmoment Last
cr1 = 10;       %lineare Steifigkeit Riemen
cr3 = 1e6;      %kubische Steifigkeit Riemen (1e6)
dl  = 0.001;    %visk. Dämpfung Last
rl  = 0.05;     %Radius Riemenscheibe Last
I_m  = 0.5e-5;   %Trägheitsmoment Motor
dm  = 0.01;     %viskose Dämpfung Motor
rm  = 0.025;    %Radius Riemenscheibe Motor
Rm  = 1.388;    %Widerstand PSM
Lm  = 1.475e-3; %Induktivität PSM
p   = 2.0;      %Polpaarzahl PSM
Phi_m = 2.715e-2; %Fluss Permanentmagnet PSM

Ta = 0.1e-3;

%Time variant LQR
R = eye(2);
Q = diag([10,1,100,1,1,200,100]);
N = zeros(7,2);

%desired states
wm_d = 1000/60*2*pi;
id_d = 0.1;
iq_d = 0.2e1 / 0.3e1 * wm_d * (dl * rm ^ 2 + dm * rl ^ 2) / Phi_m / p / rl ^ 2;
Fr = -dl * rm * wm_d / rl ^ 2 / 0.2e1;
wl_d = rm * wm_d / rl;
uq_d = -wm_d * (0.9e1 * Lm * Phi_m * id_d * p ^ 2 * rl ^ 2 - 0.6e1 * Phi_m ^ 2 * p ^ 2 * rl ^ 2 - 0.4e1 * Rm * dl * rm ^ 2 - 0.4e1 * Rm * dm * rl ^ 2) / Phi_m / p / rl ^ 2 / 0.6e1;
ud_d = (Lm * dl * rm ^ 2 * wm_d ^ 2 + Lm * dm * rl ^ 2 * wm_d ^ 2 + Phi_m * Rm * id_d * rl ^ 2) / Phi_m / rl ^ 2;

%syms e
%lsg = double(solve(cr1*e+cr3*e^3-Fr,e));
lsg = roots([cr3,0,cr1,-Fr]);
%e_d = lsg(any(imag(lsg)));
%e_d=e_d(1);
e_d = lsg(imag(lsg)==0);


%aus Maple
Phi_m = [1 - Ta * dm / I_m 0.3e1 / 0.2e1 * Ta * Phi_m * p / I_m 0 (Ta * (12 * cr3 * e_d ^ 2 * rm + 4 * cr1 * rm) / I_m) / 0.2e1 0 0 0; (Ta * (3 * Lm * id_d * p - 2 * Phi_m * p) / Lm) / 0.3e1 0.1e1 - 0.2e1 / 0.3e1 * Ta * Rm / Lm Ta * p * wm_d 0 0 0 0; -Ta * iq_d * p -Ta * p * wm_d 0.1e1 - 0.2e1 / 0.3e1 * Ta * Rm / Lm 0 0 0 0; -Ta * rm 0 0 1 Ta * rl 0 0; 0 0 0 -Ta * (6 * cr3 * e_d ^ 2 * rl + 2 * cr1 * rl) / I_l 1 - Ta * dl / I_l 0 0; Ta 0 0 0 0 1 0; 0 0 Ta 0 0 0 1;];
Gamma = [0 0; 0.2e1 / 0.3e1 * Ta / Lm 0; 0 0.2e1 / 0.3e1 * Ta / Lm; 0 0; 0 0; 0 0; 0 0;];

%discrete Riccati equation
[S,L,G] = dare(Phi_m,Gamma,Q,R);
%P_sym = 1/2*(P+P');

N=length(Phi_out.Data);

%lqr Entwurf
%[K,S,E] = dlqr(Phi,Gamma,Q,R,N);

P(:,:,N+1)=S;



for i=(N):-1:1
    
    Phi_m = Phi_out.Data(:,:,i);

    K(:,:,i)= -(R+Gamma'*P(:,:,i+1)*Gamma)^(-1)*(N+Gamma'*P(:,:,i+1)*Phi_m);

    P(:,:,i)=(Q+(Phi_m')*P(:,:,i+1)*Phi_m)-(N+Gamma'*P(:,:,i+1)*Phi_m)'*((R+Gamma'*P(:,:,i+1)*Gamma)^(-1))*(N+Gamma'*P(:,:,i+1)*Phi_m);
   
    P(:,:,i)=0.5*(P(:,:,i)+P(:,:,i)');
    
end
    