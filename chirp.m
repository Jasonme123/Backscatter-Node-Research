% This Function creates 
%  a chirp waveform with 
%  the following variables:

%Fc: Center Carrier Frequency
%BW: Chirp Bandwidth
%Tp: Chirp Duration
%t: Variable of time


function Xp = chirp(Fc,BW,Tp,t)
     Xp = (exp((j*2*pi*Fc*t) + ( j*pi* (BW/Tp) * (t.^2) ))) .* heaviside(t);

end