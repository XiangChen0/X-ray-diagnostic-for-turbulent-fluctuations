%% calculate the emissivity at the queried points for all energy thresholds
function emq=emis(z, E, rang, time, Te_fluct_xt, ne_fluct_xt)

rq=abs(z);
rq(rq>1)=1;
angq=angle(z);

sz=size(z);
neq=zeros(sz(1),sz(2),length(time));
Teq=neq;

r=rang(:,:,1);
ang=rang(:,:,2);

for ii=1:length(time)
    
    neq(:,:,ii)=(1-rq.^2).^0.5.*(1+wgt(rq).*interp2(ang,r,ne_fluct_xt(:,:,ii),angq,rq,'spline'));
    
    Teq(:,:,ii)=(1-rq.^2).^0.8.*(1+wgt(rq).*interp2(ang,r,Te_fluct_xt(:,:,ii),angq,rq,'spline'));
    %{
    if ii==1
       figure;
       h=pcolor(Teq(:,:,ii)-(1-rq.^2).^0.8);
       set(h,'EdgeColor','none');
       axis equal;
       figure;
       h=pcolor(neq(:,:,ii)-(1-rq.^2).^0.5);
       set(h,'EdgeColor','none');
       axis equal;
    end
    %}
    
end

%% emissivity with/without fluctuations for all energy threshold E
emq=repmat(Teq,[1,1,1,length(E)]);

for jj=1:length(E)   
    %% emissivity with fluctuations
    emq(:,:,:,jj)=sqrt(Teq).*(neq).^2.*exp(-E(jj)./Teq);
    
end

emq=squeeze(emq);
