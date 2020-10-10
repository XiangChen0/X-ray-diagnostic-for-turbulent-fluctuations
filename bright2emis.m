
function emissivity=bright2emis(measure_points, view_angles, number_of_local_chords, chords, brightness)

%%
sz=size(brightness);

number_of_angles=sz(1);%length(brightness(:,1,1,1));

number_of_global_measures=sz(2)-number_of_local_chords;

number_of_time=sz(3);%length(brightness(1,1,:,1));

number_of_energy_thresholds=sz(4);%length(brightness(1,1,1,:));

number_of_measure_points=length(measure_points);

brightness_mean=squeeze(mean(brightness,3));

%%

emissivity=zeros(number_of_measure_points,number_of_time,number_of_energy_thresholds);

total_hilbert=zeros(number_of_angles,number_of_measure_points,number_of_time,number_of_energy_thresholds);

integration_angles=[view_angles view_angles(1)+pi];

for ii=1:number_of_energy_thresholds
    
    for jj=1:number_of_time
    
        for kk=1:number_of_angles
            
            [global_measure_center,global_spectrum]=dcf(chords(kk,1:number_of_global_measures), ...
                                                    squeeze(brightness_mean(kk,1:number_of_global_measures,ii)));
                                                
            global_hilbert=idcf(global_measure_center,global_spectrum(1,:),global_spectrum(2,:).*abs(global_spectrum(1,:)));
            
            [local_measure_center,local_spectrum]=dcf(chords(kk,number_of_global_measures+1:end), ...
                                                  squeeze(brightness(kk,number_of_global_measures+1:end,jj,ii))- ...
                                                  squeeze(brightness_mean(kk,number_of_global_measures+1:end,ii)));
                                                
            local_hilbert=idcf(local_measure_center,local_spectrum(1,:),local_spectrum(2,:).*abs(local_spectrum(1,:)));
             
            total_hilbert(kk,:,jj,ii)=interp1(local_hilbert(1,:),local_hilbert(2,:),measure_points*sin(view_angles(kk)))+ ...
                                      interp1(global_hilbert(1,:),global_hilbert(2,:),measure_points*sin(view_angles(kk)));
            %disp(max(global_hilbert(2,:)));
            %total_hilbert(kk,:,jj,ii)=interp1(global_hilbert(1,:),global_hilbert(2,:),measure_points*sin(view_angles(kk)));
                                  
            %plot(measure_points,interp1(global_hilbert(1,:),global_hilbert(2,:),measure_points*sin(view_angles(kk))),'-');
            %plot(measure_points,interp1(local_hilbert(1,:),local_hilbert(2,:),measure_points*sin(view_angles(kk))),'.-.');
            
        end
        
        %%  integrate over the viewing angle to obtain the reconstructed emissivity
        for ll=1:number_of_measure_points
        
            integration_hilbert=[squeeze(total_hilbert(:,ll,jj,ii)); total_hilbert(1,ll,jj,ii)];
            
            %figure;plot(integration_angles,integration_hilbert);
            
            emissivity(ll,jj,ii)=trapz(integration_angles,integration_hilbert)/2/pi;
        
        end
        
    end   
        
end

