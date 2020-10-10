%% denoise brightness

sz=size(brightness);
brightness_denoised=brightness;

%% brightness denoising
%brightness(:,202:end,:,:)=brightness(:,202:end,:,:)-mean(brightness(:,202:end,:,:)-mean(brightness(:,202:end,:,:),3),2);

%
for ii=1:sz(1)
        
    brightness_denoised(ii,202:end,:,:)=denoise(squeeze(brightness(ii,202:end,:,:)));      
    
end
%}

%% pseudolocal tomography
emissivity_reconstructed=bright2emis(measure_points, view_angles, number_of_local_chords, chords, brightness_denoised);

%total electron temperature at the measuring points and its corresponding
%wavenumber spectrum for the original synthetic data(_ref) and the reconstructed
%results(_ms)

%% emissivity denoising
%trivial
%emissivity_reconstructed=emissivity_reconstructed-mean(emissivity_reconstructed-mean(emissivity_reconstructed,2),1);
%non-trivial
%emissivity_reconstructed=denoise(emissivity_reconstructed);

%emissivity_reconstructed=abs(emissivity_reconstructed);
%emissivity_reconstructed(emissivity_reconstructed<=0)=0;

%% nonlinear fitting
temp_synthetic=zeros(number_of_measure_points,length(time));

temp_reconstructed=temp_synthetic;

spectrum_synthetic=zeros(round((number_of_measure_points+1)/2),length(time));

spectrum_reconstructed=spectrum_synthetic;

F = @(x,xdata)x(1)*exp(-x(2)*xdata);
x0=[1 1];

for ii=1:length(temp_synthetic(:,1))
    
    for jj=1:length(temp_synthetic(1,:))
        
        x=lsqcurvefit(F,x0,energy_threshold',squeeze(emissivity_synthetic(ii,jj,:)));
        temp_synthetic(ii,jj)=1/x(2);
        x=lsqcurvefit(F,x0,energy_threshold',squeeze(emissivity_reconstructed(ii,jj,:)));
        temp_reconstructed(ii,jj)=1/x(2);
        
    end
end

%temperature fluctuations
temp_fluct_synthetic=temp_synthetic-mean(temp_synthetic,2);
temp_fluct_reconstructed=temp_reconstructed-mean(temp_reconstructed,2);

%% calculating fluctuation spectrum

for kk=1:length(time)
    
    kw=asd(measure_points,temp_fluct_synthetic(:,kk));
    
    spectrum_synthetic(:,kk+1)=kw(2,:);
    
    kw=asd(measure_points,temp_fluct_reconstructed(:,kk));
    
    spectrum_reconstructed(:,kk+1)=kw(2,:);
    
end

spectrum_synthetic(:,1)=kw(1,:);
spectrum_reconstructed(:,1)=kw(1,:);

%% linear fitting
%{
for kk=1:length(time)
%emissivity to temperature
    temp_synthetic(:,kk)=-sum((energy_threshold-mean(energy_threshold)).^2)./ ...
        ((log(squeeze(emissivity_synthetic(:,kk,:)))-mean(log(emissivity_synthetic(:,kk,:)),3)) ...
        *(energy_threshold'-mean(energy_threshold)));
    
    temp_reconstructed(:,kk)=-sum((energy_threshold-mean(energy_threshold)).^2)./ ...
        ((log(squeeze(emissivity_reconstructed(:,kk,:)))-mean(log(emissivity_reconstructed(:,kk,:)),3)) ...
        *(energy_threshold'-mean(energy_threshold)));   
    
end
%}
