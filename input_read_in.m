%subroutine for reading inputs
%take the input parameters from ../input.dat
FID=fopen('../input.dat');
input_cell=textscan(FID,'%f','CommentStyle','#');
input_data=input_cell{1};

%parallel computation setting
if input_data(1)==1
    
   pc=parcluster('local');
   
   parpool(pc,str2num(getenv('SLURM_CPUS_ON_NODE')));
   
end
%--------------------------------------------------------------------------
%Electron temperature and density fluctuations initialization
%radial wavenumber kr is different from poloidal wavenumber kp
%both has a spectrum in the form S(k)~(k/kc)/(1+|k/kc-1|^3) which is
%observed from gyrokinetic simulation results in Juan Ruiz's Phd thesis.
%--------------------------------------------------------------------------
radial_wavelength=input_data(2);
radial_kc=2*pi/radial_wavelength;

%----------------------------------------------------------------------------
poloidal_wavelength=input_data(3);
radial_c=input_data(4);%the radial position where we measure the poloidal wavenumber
poloidal_nc=2*pi*radial_c/poloidal_wavelength;

%The energy threshold of detectable X-rays, realized by applying Beryllium
%windows with different thickness
energy_threshold=[input_data(5) input_data(6) input_data(7)];

number_of_energy_thresholds=length(energy_threshold);
%---------------------------------

%determine the number of time points(should be a multiplier of 8)
time_parameter=input_data(8);

%central frequency in kHz
freq_c=input_data(9);

%Measuring points, located in a line in the midplane
measure_points=input_data(10):(input_data(12)-input_data(10))/(input_data(11)-1):input_data(12);

number_of_measure_points=length(measure_points);

%initial viewing angle in rad
initial_angle=input_data(13)*pi/180;

%number of viewing angles
number_of_angles=input_data(14);

%viewing angles, the direction from which the detector receives the X-rays
view_angles=initial_angle:pi/number_of_angles:initial_angle+pi-pi/number_of_angles;


%For each angle, chords are divided into global and local. Global(local) chords
%have large(small) distance between neighboring chords and is responsible for the
%global(local) reconstruction. The local chords cover a region bigger than the 
%measuring region and all measuring points have a chord passed through.

number_of_global_chords=input_data(15);

spacing_of_global_chords=2/(number_of_global_chords+1);

global_chords_extended=-10:spacing_of_global_chords:10;

number_of_local_chords=input_data(16);

length_of_measure_region=abs(measure_points(end)-measure_points(1));

center_of_measure_region=(measure_points(1)+measure_points(end))/2;

spacing_of_local_chords=2*length_of_measure_region/(number_of_local_chords-1);

chords=zeros(number_of_angles, length(global_chords_extended)+number_of_local_chords);
             
for ii=1:number_of_angles
                                    
     local_chords=center_of_measure_region*sin(view_angles(ii))-length_of_measure_region ...
              :spacing_of_local_chords:center_of_measure_region*sin(view_angles(ii))+length_of_measure_region;
          
     chords(ii,:)=[global_chords_extended local_chords]; 
     
end

%step size of the integration along the viewing chords
integrand_of_chord=-1:input_data(17):1;