% This Function creates a linear 
% frequency modulated waveform
%  using the following variables:

%Xp: A Single Chirp Waveform

function Xt = chirp(Fc,BW,Tp,t)
     Xp = (exp((j*2*pi*Fc*t) + ( j*pi* (BW/Tp) * (t.^2) ))) .* heaviside(t);

end