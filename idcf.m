%inverse discrete fourier transform
%symmetry is required... make sure the range of k is -k0<k<+k0
function xf=idcf(xc,k,fk)

dx=2*pi/(k(end)-k(1));

L=length(k);

x=(1-L)*dx/2:dx:(L-1)/2*dx;

x=x+xc;

xf=repmat(x,2,1);

xf(2,:)=ifftshift(ifft(ifftshift(fk)))/dx;