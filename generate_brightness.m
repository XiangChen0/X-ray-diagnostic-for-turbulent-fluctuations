%% This function is used to calculate the reconstructed temperature at the query point series xm. 
function brightness=generate_brightness(energy_threshold, view_angles, ...
                    chords, integrand_of_chord, rang, time, Te_fluct_xt, ne_fluct_xt)
%%
brightness=repmat(chords,[1,1,length(time),length(energy_threshold)]);
brightness=zeros(size(brightness));
    
for ii=1:length(view_angles)                           
        
    for jj=1:length(chords(1,:))
            
        if abs(chords(ii,jj))<1
                
           integral_path=chords(ii,jj)*exp(1i*(view_angles(ii)-pi/2)) ...
                         +integrand_of_chord*exp(1i*view_angles(ii));
                
           emis_with_fluct=emis(integral_path, energy_threshold, rang, time, Te_fluct_xt, ne_fluct_xt);
               
           brightness(ii,jj,:,:)=trapz(integrand_of_chord,emis_with_fluct,1);
               
        end
        
        for kk=1:length(energy_threshold)
            
            brightness(ii,jj,:,kk)=awgn(brightness(ii,jj,:,kk), 60 ,'measured');
            
        end
            
    end

end
