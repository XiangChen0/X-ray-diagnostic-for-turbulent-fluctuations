%Amplitude spectral density of a signal y(x)
function kP=asd(x,y)

dx=x(2)-x(1);

L=length(x)-1;

k=2*pi/dx*(0:L/2)/L;

P2=abs(fft(y(1:end-1))/L);

P1=P2(1:L/2+1);

P1(2:end-1)=2*P1(2:end-1);

kP=repmat(k,2,1);

kP(2,:)=P1;
