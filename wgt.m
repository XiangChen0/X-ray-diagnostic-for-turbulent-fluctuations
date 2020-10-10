%the fluctuation level versus radius. It's expected that the fluctuations
%is vialating at the edge, which can be up to 50% of the average value or more, 
%but in the core plasma, the fluctuation level is only 0.2%

function y=wgt(x)
    
y=exp(1.5*(2*x-1));
%{
y=((x-0.4)/0.6*1.95+0.05)/2;   
    
y(x<0.4)=0.05/2;
%}  
