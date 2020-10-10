%discrete fourier transform
%symmetry is required... to make sure the range of x is -x0<x<+x0
%The length of x(and y) can be either odd or even
function [xc,kP]=dcf(x,y)

xc=(x(1)+x(end))/2;

dk=2*pi/(x(end)-x(1));

L=length(x);

k=-floor(L/2)*dk:dk:(L-1-floor(L/2))*dk;

kP=repmat(k,2,1);

kP(2,:)=fftshift(fft(fftshift(y)))*2*pi/dk/L;