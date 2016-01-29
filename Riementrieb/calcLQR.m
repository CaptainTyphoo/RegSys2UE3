
Ta=1e-4;
Ni=size(st_x_d,1);
Gamma = [0 0; 0.2e1 / 0.3e1 / Lm 0; 0 0.2e1 / 0.3e1 / Lm; 0 0; 0 0; 0 0; 0 0]*Ta;
Phiks=zeros(7,7,Ni);
for i = 1: Ni
wm_d=st_x_d(i,1);
iq_d=st_x_d(i,2);
id_d=st_x_d(i,3);
e_d=st_x_d(i,4);
wl_d=st_x_d(i,5);

Ak = [-0.1e1 / I_m * dm 0.3e1 / 0.2e1 / I_m * Phi * p 0 (12 * cr3 * e_d ^ 2 * rm + 4 * cr1 * rm) / I_m / 0.2e1 0 0 0; -(-0.3e1 * Lm * id_d * p + 0.2e1 * Phi * p) / Lm / 0.3e1 -0.2e1 / 0.3e1 * Rm / Lm p * wm_d 0 0 0 0; -p * iq_d -p * wm_d -0.2e1 / 0.3e1 * Rm / Lm 0 0 0 0; -rm 0 0 0 rl 0 0; 0 0 0 -(6 * cr3 * e_d ^ 2 * rl + 2 * cr1 * rl) / I_l -1 / I_l * dl 0 0; 1 0 0 0 0 0 0; 0 0 1 0 0 0 0;];


Phik=eye(7)+(Ak)*Ta;
Phiks(:,:,i)=Phik;
end

R=diag([1 1]);
Q=diag([10 1 100 1 1 200 100]);
N=zeros(2,7);
PhiN=Phiks(:,:,Ni);
[P,K,G]=dare(PhiN,Gamma,Q,R);
P=(P+P')/2;
Kks=zeros(2,7,Ni);
for i = Ni:-1:1
    Phik=Phiks(:,:,i);
    Kk=-(R+Gamma'*P*Gamma)\(N+Gamma'*P*Phik);
    P=(Q+Phik'*P*Phik) +(N+Gamma'*P*Phi)'*Kk;
    P=(P+P')/2;
    Kks(:,:,i)=Kk;
end