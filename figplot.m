load ../output/workspace_256it_6ang_19global_41local.mat;
Figure_Default_Setting;
figure;
hold on;
grid on;

plot(std(Te_total_ref,0,2),std(Te_total_ms,0,2),'.');
plot(mean(std(Te_total_ref,0,2)),mean(std(Te_total_ms,0,2)),'r*');
plot(mean(std(Te_total_ref,0,2)),mean(std(Te_total_ref,0,2)),'go');
xlabel('\sigma(\delta T_e^{syn})');
ylabel('\sigma(\delta T_e^{re})');
plot(0:1e-3:0.05,0:1e-3:0.05,'--');
%{
plot(std(temp_fluct_synthetic,0,1),std(temp_fluct_reconstructed,0,1),'.');
plot(mean(std(temp_fluct_synthetic,0,1)),mean(std(temp_fluct_reconstructed,0,1)),'r*');
plot(mean(std(temp_fluct_synthetic,0,1)),mean(std(temp_fluct_synthetic,0,1)),'go');
xlabel('\sigma(\delta T_e^{syn})');
ylabel('\sigma(\delta T_e^{re})');
plot(0:1e-3:0.05,0:1e-3:0.05,'--');
%}

%{
plot(zs,std(Te_total_ref,0,1),'.b');
plot(zs,std(Te_total_ms,0,1),'.r');
legend('synthetic','reconstructed');
legend('Location','northeast');
legend('boxoff');
%}
%{
plot(measure_points,std(temp_fluct_synthetic,0,2),'.b');
plot(measure_points,std(temp_fluct_reconstructed,0,2),'.r');
legend('synthetic','reconstructed');
legend('Location','northeast');
legend('boxoff');
%}
%{
plot(spectrum_synthetic(:,1),mean(spectrum_synthetic(:,2:end),2)./max(mean(spectrum_synthetic(:,2:end),2)),'-.*');
plot(spectrum_reconstructed(:,1),mean(spectrum_reconstructed(:,2:end),2)./max(mean(spectrum_reconstructed(:,2:end),2)),'--o');
%}
%{
plot(S_total_ref1(1,:),mean(S_total_ref2,1)./max(mean(S_total_ref2,1)),'-.*');
plot(S_total_ms1(1,:),mean(S_total_ms2,1)./max(mean(S_total_ms2,1)),'--o');
%}
%{
alpha=randi([1 1024],1,1);
plot(S_total_ref1(1,:),S_total_ref2(alpha,:)./max(S_total_ref2(alpha,:)),'-.*');
plot(S_total_ms1(1,:),S_total_ms2(alpha,:)./max(S_total_ms2(alpha,:)),'--o');
%}
%{
kc=2*pi/0.07;
k=0:kc/100:4*kc;
s=k*kc./(1+abs(1-k/kc).^3);
plot(k,s/max(s),'-.','Color',[0.39 0.83 0.07]);
xlabel('k/m^{-1}');
ylabel('S(k)/S(k)_{max}');
legend('synthetic k-spectrum','reconstructed k-spectrum','generating function');
legend('Location','northeast');
legend('boxoff');
%}