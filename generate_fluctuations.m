%fluctuation generation
function [rang, time, fluct_xt]=generate_fluctuations(radial_kc,poloidal_nc,freq_c,number_of_time)


radial_k=(-8*radial_kc:radial_kc/ceil(radial_kc/2/pi):8*radial_kc)';
poloidal_n=-8*poloidal_nc:poloidal_nc/ceil(poloidal_nc):8*poloidal_nc;
delta_freq=freq_c/8;
freq=(-floor(number_of_time/2):floor(number_of_time/2))*delta_freq;
%-8*freq_c:8*freq_c/number_of_time:8*freq_c;

freq=reshape(freq,[1,1,length(freq)]);

len_kr=length(radial_k);
len_kp=length(poloidal_n);
len_fq=length(freq);

radial_k=repmat(radial_k,[1,len_kp,len_fq]);
poloidal_n=repmat(poloidal_n,[len_kr,1,len_fq]);
freq=repmat(freq,[len_kr,len_kp,1]);

radial_k_norm=abs(radial_k/radial_kc);
poloidal_n_norm=abs(poloidal_n/poloidal_nc);
freq_norm=abs(freq/freq_c);

fluct_spectrum=(radial_k_norm./(1+(abs(radial_k_norm-1)).^3)) ...
             .*(poloidal_n_norm./(1+(abs(poloidal_n_norm-1)).^3)) ...
             .*(freq_norm./(1+abs(freq_norm-1).^3));

rng('shuffle');

random_phase=2*pi*rand(len_kr,len_kp,len_fq);

fluct_spectrum=fluct_spectrum.*exp(1i*random_phase);

fluct_spectrum=ifftshift(ifftshift(ifftshift(fluct_spectrum,3),2),1);

fluct_xt=real(ifftshift(ifftshift(ifftshift(ifftn(fluct_spectrum),1),2),3));

fluct_xt=fluct_xt*0.04/max(max(max(fluct_xt)));

delta_r=2*pi/(radial_k(end)-radial_k(1));
r=0:delta_r:(len_kr-1)*delta_r;

delta_ang=2*pi/(poloidal_n(end)-poloidal_n(1));
ang=(1-len_kp)/2*delta_ang:delta_ang:(len_kp-1)/2*delta_ang;

r=repmat(r',[1,length(ang)]);
ang=repmat(ang,[length(r(:,1)),1]);
rang=repmat(r,[1,1,2]);
rang(:,:,2)=ang;

delta_t=1/(freq(end)-freq(1));
time=0:delta_t:(len_fq-1)*delta_t;

%% debug
%{
rq=(0:1e-3:1)';
thetaq=-pi:pi/800:pi;
rq=repmat(rq,[1,length(thetaq)]);
thetaq=repmat(thetaq,[length(rq(:,1)),1]);


fluct_syn=interp2(ang,r,fluct_xt(:,:,100),thetaq,rq,'spline');
fluct_syn=fluct_syn.*wgt(rq).*(1-rq.^2).^0.8;
fluct_syn=fluct_syn*0.04/max(max(fluct_syn));

figure;
h=pcolor(rq.*cos(thetaq),rq.*sin(thetaq),fluct_syn);
set(h,'EdgeColor','none');
axis equal;
xlim([0.4 0.8]);
ylim([-0.1 0.1]);
colorbar;

figure;
h=pcolor(real(squeeze(fluct_xt(:,:,10))));
set(h,'EdgeColor','none');


s1=squeeze(fluct_xt(40,440,:));
rs=zeros(1,121);
for ii=1:121
    s=squeeze(fluct_xt(ii,440,:));
    rs(ii)=xcorr(s1,s,0);
end
figure;
plot(rs);
toc;

%}

