
%Testing Chrip Generation
t = -.1:.001:10;
Tp = 1;
BW = 5;
Fc = 20;

y = chirp(Fc,BW,Tp,t);

plot(t,y)


