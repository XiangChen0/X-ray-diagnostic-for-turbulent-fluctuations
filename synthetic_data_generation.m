%--------------------------------------------------------------------------
%-----------------------SYNTHETIC DATA GENERATION--------------------------
%--------------------------------------------------------------------------
[~, ~, Te_fluct_xt]=generate_fluctuations(radial_kc,poloidal_nc,freq_c,time_parameter);

[rang, time, ne_fluct_xt]=generate_fluctuations(radial_kc,poloidal_nc,freq_c,time_parameter);

emissivity_synthetic=emis(measure_points, energy_threshold, rang, time, Te_fluct_xt, ne_fluct_xt); 
           
brightness=generate_brightness(energy_threshold, view_angles, chords,  ...
           integrand_of_chord, rang, time, Te_fluct_xt, ne_fluct_xt);