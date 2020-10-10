function signal_denoised=denoise(signal)

signal_highk=signal-mean(signal,2);

signal_denoised=signal;

for ii=1:length(signal(1,1,:))
    
    spec_amp=abs(fft2(squeeze(signal_highk(:,:,ii))));

    spec_amp_fft=fft2(spec_amp);
    
    if ii==1
        
       ind=abs(spec_amp_fft)<=max(max(abs(spec_amp_fft(:,10:230))));
       
    end
    
    spec_amp_fft(ind)=0;
       
    spec_amp_denoised=abs(ifft2(spec_amp_fft));
    
    spec_ang=angle(fft2(squeeze(signal_highk(:,:,ii))));
    
    signal_denoised(:,:,ii)=real(ifft2(spec_amp_denoised.*exp(1i*spec_ang)))+mean(signal(:,:,ii),2);
    
end


