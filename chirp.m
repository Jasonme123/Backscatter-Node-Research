% This Function creates 
%  a chirp waveform with 
%  the following variables:

%Fc: Center Carrier Frequency (hz)
%BW: Chirp Bandwidth (Hz)
%Tp: Chirp Duration (s)
%t: Variable of time (s)


function Xp = chirp(Fc,BW,Tp,t)
     Xp = (exp((j*2*pi*Fc*t) + ( j*pi* (BW/Tp) * (t.^2) ))) .*(heaviside(t) - heaviside(t - Tp));
end
