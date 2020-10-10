sz=size(temp_fluct_synthetic);

area=(sz(1)-1)*(sz(2)-1);

spec_synthetic=abs(fft2(temp_fluct_synthetic(1:end-1,1:end-1))/area);

%spec_reconstructed=abs(fft2(temp_fluct_reconstructed(1:end-1,1:end-1))/area);

temp_fluct_mdf=temp_fluct_reconstructed-mean(temp_fluct_reconstructed,1);
spec_reconstructed=abs(fft2(temp_fluct_mdf(1:end-1,1:end-1))/area);

spec_synthetic=spec_synthetic(1:(sz(1)+1)/2,1:(sz(2)+1)/2);

spec_reconstructed=spec_reconstructed(1:(sz(1)+1)/2,1:(sz(2)+1)/2);

dx=measure_points(2)-measure_points(1);

k=2*pi/dx*(0:(sz(1)-1)/2)/(sz(1)-1);

dt=time(2)-time(1);

f=2*pi/dt*(0:(sz(2)-1)/2)/(sz(2)-1);

[fmesh,kmesh]=meshgrid(f,k);

%{
K=ones(3,35)/3/35;
spec_synthetic_smoothed = conv2(spec_synthetic,K,'same');
spec_reconstructed_smoothed = conv2(spec_reconstructed,K,'same');
%}
spec_synthetic_fft=fft2(spec_synthetic);
%spec_synthetic_fft(:,5:end-5)=0;
%spec_synthetic_fft(5:7,:)=0;

spec_synthetic_fft(abs(spec_synthetic_fft)<=max(max(abs(spec_synthetic_fft(:,10:end-10)))))=0;
spec_synthetic_smoothed=abs(ifft2(spec_synthetic_fft));


spec_reconstructed_fft=fft2(spec_reconstructed);
%spec_reconstructed_fft(:,4:end-4)=0;
%spec_reconstructed_fft(4:8,:)=0;
spec_reconstructed_fft(abs(spec_reconstructed_fft)<=max(max(abs(spec_reconstructed_fft(:,10:end-10)))))=0;
spec_reconstructed_smoothed=abs(ifft2(spec_reconstructed_fft));

kq=k(1):(k(2)-k(1))/10:k(end);

[fqmesh,kqmesh]=meshgrid(f,kq);




spec_synthetic_smoothed_interp=interp2(fmesh,kmesh,spec_synthetic_smoothed,fqmesh,kqmesh,'spline');

spec_reconstructed_smoothed_interp=interp2(fmesh,kmesh,spec_reconstructed_smoothed,fqmesh,kqmesh,'spline');
%

ind1=find(spec_synthetic_smoothed_interp==max(max(spec_synthetic_smoothed_interp)));

if(numel(ind1)>1)
    
    ind1=ind1(1);
    
end

ind2=find(spec_reconstructed_smoothed_interp==max(max(spec_reconstructed_smoothed_interp)));

if(numel(ind2)>1)
    
    ind2=ind2(1);
    
end

disp([kqmesh(ind1) kqmesh(ind2) fqmesh(ind1) fqmesh(ind2)]);

figure;

h=pcolor(fmesh,kmesh,spec_synthetic);

set(h,'EdgeColor','none');

xlabel('f/kHz');

ylabel('k/m^{-1}');

title('Raw spectrum of \delta T_e^{syn}');

name5=['../figure/Raw_synthetic_2Dspectrum' num2str(length(time)) 'it_'  ...
       num2str(number_of_angles) 'ang_' num2str(number_of_global_chords) ...
      'global_' num2str(number_of_local_chords) 'local.png'];
  
%saveas(gcf,name5);

figure;

h=pcolor(fqmesh,kqmesh,spec_synthetic_smoothed_interp);

set(h,'EdgeColor','none');

xlabel('f/kHz');

ylabel('k/m^{-1}');

title('Smoothed spectrum of \delta T_e^{syn}');

cen_pos1=['k_c=' num2str(roundn(kqmesh(ind1),-1)) ...
          '\newlinef_c=' num2str(roundn(fqmesh(ind1),-1))];

text(500,250,cen_pos1,'Color','red','FontSize',24);

hold on;

plot(fqmesh(ind1),kqmesh(ind1),'r*','MarkerSize',10);

name6=['../figure/Smoothed_synthetic_2Dspectrum' num2str(length(time)) 'it_'  ...
       num2str(number_of_angles) 'ang_' num2str(number_of_global_chords) ...
      'global_' num2str(number_of_local_chords) 'local.png'];
  
%saveas(gcf,name6);
%colorbar;
%}

%
figure;

h=pcolor(fmesh,kmesh,spec_reconstructed);

set(h,'EdgeColor','none');

xlabel('f/kHz');

ylabel('k/m^{-1}');

title('Raw spectrum of \delta T_e^{rec}');

name7=['../figure/Raw_reconstructed_2Dspectrum' num2str(length(time)) 'it_'  ...
       num2str(number_of_angles) 'ang_' num2str(number_of_global_chords) ...
      'global_' num2str(number_of_local_chords) 'local.png'];
  
%saveas(gcf,name7);

figure;

h=pcolor(fqmesh,kqmesh,spec_reconstructed_smoothed_interp);

set(h,'EdgeColor','none');

xlabel('f/kHz');

ylabel('k/m^{-1}');

title('Smoothed spectrum of \delta T_e^{rec}');

cen_pos2=['k_c=' num2str(roundn(kqmesh(ind2),-1)) '\newlinef_c=' num2str(roundn(fqmesh(ind2),-1))];

text(500,250,cen_pos2,'Color','red','FontSize',24);

hold on;

plot(fqmesh(ind2),kqmesh(ind2),'r*','MarkerSize',10);
%colorbar;
%}

name8=['../figure/Smoothed_reconstructed_2Dspectrum' num2str(length(time)) 'it_'  ...
       num2str(number_of_angles) 'ang_' num2str(number_of_global_chords) ...
      'global_' num2str(number_of_local_chords) 'local.png'];
%saveas(gcf,name8);