function out = F2U(u1)

% Funktion zur Berechnung der Motorspannung aus der momentanen
% Kraft u1 gemäß der statischen Kennlinie. 

k_RRU_down = -0.00150302768587;
k_RRU_up = 0.00485541597537;

if u1 > 0 
    k = k_RRU_up;
    out(1)=sqrt(abs(u1/k));
else
    k = k_RRU_down;
    out(1)=-sqrt(abs(u1/k));
end

end