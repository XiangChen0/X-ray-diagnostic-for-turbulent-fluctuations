num_ang=2;

%signal=squeeze(brightness_denoised(num_ang,202:end,:,3));

%signal=denoise(signal);

%signal=squeeze(emissivity_reconstructed(:,:,2)-mean(emissivity_reconstructed(:,:,2),1));
signal=squeeze(emissivity_reconstructed(:,:,1));
%signal=signal-mean(signal,2);
%signal=squeeze(emissivity_synthetic(:,:,3));


%emissivity fluctuations
%signal=squeeze(neq);
sz=size(signal);

area=(sz(1)-1)*(sz(2)-1);

spec=abs(fft2(signal(1:end-1,1:end-1))/area);

spec=spec(1:(sz(1)+1)/2,1:(sz(2)+1)/2);

dx=chords(num_ang,203)-chords(num_ang,202);

k=2*pi/dx*(0:(sz(1)-1)/2)/(sz(1)-1);

dt=time(2)-time(1);

f=2*pi/dt*(0:(sz(2)-1)/2)/(sz(2)-1);

[fmesh,kmesh]=meshgrid(f,k);

%
figure;

h=pcolor(fmesh(:,10:end),kmesh(:,10:end),spec(:,10:end));

set(h,'EdgeColor','none');

xlabel('f/kHz');

ylabel('k/m^{-1}');

title('spectrum of emissivity');

colorbar;
%}

%{

signal_noise=signal;

sz=size(signal);

snr=40;

for ii=1:sz(1)
    
    signal_noise(ii,:)=awgn(signal(ii,:),snr,'measured');
    
end

spec_noise=abs(fft2(signal_noise(1:end-1,1:end-1))/area);


spec_noise=spec_noise(1:(sz(1)+1)/2,1:(sz(2)+1)/2);

figure;

h=pcolor(fmesh(:,10:end),kmesh(:,10:end),spec_noise(:,10:end));

set(h,'EdgeColor','none');

xlabel('f/kHz');

ylabel('k/m^{-1}');

title(['snr=' num2str(snr)]);
%}
