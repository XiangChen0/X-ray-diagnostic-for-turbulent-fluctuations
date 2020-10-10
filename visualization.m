% --------------------------------------------------------------------------
% -----------------------------VISUALIZATION--------------------------------
% --------------------------------------------------------------------------
%% save workspace
name4=['../output/workspace_' num2str(length(time)) 'it_'  ...
       num2str(number_of_angles) 'ang_' num2str(number_of_global_chords) ...
      'global_' num2str(number_of_local_chords) 'local.mat'];
save(name4);


Figure_Default_Setting;
figure;
plot(measure_points,temp_fluct_synthetic');
xlabel('R/m');
ylabel('\delta T_e/Te');
name1=['../figure/synthetic_temp_fluct_' num2str(length(time)) 'it_'  ...
       num2str(number_of_angles) 'ang_' num2str(number_of_global_chords) ...
      'global_' num2str(number_of_local_chords) 'local.png'];
saveas(gcf,name1);

figure;
plot(measure_points,temp_fluct_reconstructed');
xlabel('R/m');
ylabel('\delta T_e/Te');
name2=['../figure/reconstructed_temp_fluct_' num2str(length(time)) 'it_'  ...
       num2str(number_of_angles) 'ang_' num2str(number_of_global_chords) ...
      'global_' num2str(number_of_local_chords) 'local.png'];
saveas(gcf,name2);

figure;
plot(spectrum_synthetic(:,1), mean(spectrum_synthetic(:,2:end),2)/ ...
     max(mean(spectrum_synthetic(:,2:end),2)));
hold on;
plot(spectrum_reconstructed(:,1), mean(spectrum_reconstructed(:,2:end),2)/ ...
     max(mean(spectrum_reconstructed(:,2:end),2)));
grid on;
xlabel('k/m^{-1}');
ylabel('S(k)/S(k)_{max}');
legend('synthetic','reconstructed');
name3=['../figure/spectrum_' num2str(length(time)) 'it_'  ...
       num2str(number_of_angles) 'ang_' num2str(number_of_global_chords) ... 
      'global_' num2str(number_of_local_chords) 'local.png'];
saveas(gcf,name3);





%%
%{
figure;
plot(zs,Te_ref./Teq-1);
hold on;
plot(zs,Te_ms./Teq-1);
grid on;
xlabel('r');
ylabel('T_e^{err}');
legend('Te_{ref}','Te_{ms}');
A_ref=mean(Te_ref./Teq-1);
A_ms=mean(Te_ms./Teq-1);
S_ref=std(Te_ref./Teq-1);
S_ms=std(Te_ms./Teq-1);
%title('mean=',num2str(A_ref),num2str(A_ms),\,'rms=',num2str(Rms_ref),num2str(Rms_ms));
title({['A_{ref}=',num2str(A_ref),',','   A_{ms}=',num2str(A_ms)], ...
       ['S_{ref}=',num2str(S_ref),',','   S_{ms}=',num2str(S_ms)]});
saveas(gcf,'Te_err.png');



ku=asd(zs,Te_ref./Teq-1);
figure;
plot(ku(1,:),ku(2,:));
ku=asd(zs,Te_ms./Teq-1);
hold on;
plot(ku(1,:),ku(2,:));
grid on;
xlabel('k');
ylabel('|P(k)|');
legend('reference','reconstructed');
saveas(gcf,'spectrum.png');
%}



%{
rq=0.5:0.3/800:0.8;
rq=rq';
dTer=0;
dner=0;
for ii=1:length(kr)
    
    dTer=dTer+sin(rq*kr(ii)+phirt(ii))*Ar(ii);
    dner=dner+sin(rq*kr(ii)+phirn(ii))*Ar(ii);
  
end

Jt=besselj(0,rq*kr);
Jn=besselj(0,rq*kr);

Art=(Jt'*Jt)\(Jt'*dTer);
Arn=(Jn'*Jn)\(Jn'*dner);

for ii=1:length(kr)
    
    dTer=dTer+besselj(0,rq*kr(ii))*Art(ii);
    dner=dner+besselj(0,rq*kr(ii))*Arn(ii);
  
end
%}
