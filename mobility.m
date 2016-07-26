%Mobility model from Dorkel and Leturqc as per Sinton Instruments WCT-120
%Temperature Stage Report. Inputs include temperature in Kelvin, doping
%concentration in atoms/cm3.
function [mu_n,mu_p] = mobility(T,doping,type)
%Get some material parameters
[Efi,Efv,p0,n0,Eiv] = adv_Model_gen(T,doping,type);
ni2 = p0*n0; 
%Assign constants
mu_Lo_n = 1430; %cm2/Vs
mu_Lo_p = 495; %cm2/Vs
alpha = 2.2; %no units
A_n = 4.61e17; %/cm/V/s/K(^3/2)
A_p = 1e17; %/cm/V/s/K(^3/2)
B_n = 1.52e15; %/cm3/K2
B_p = 6.25e14; %/cm3/K2

%Calculate mu_L (equation 7)
mu_L_n = mu_Lo_n*((T/300)^(-alpha)); 
mu_L_p = mu_Lo_p*((T/300)^(-alpha)); 
    
%Calculate mu_I (equation 8), assuming N = doping concentration
mu_I_n = (A_n*(T^(3/2))/doping)*((log(1+(B_n*(T^2)/doping))-(B_n*(T^2)/(doping+(B_n*(T^2)))))^(-1)); 
mu_I_p = (A_p*(T^(3/2))/doping)*((log(1+(B_p*(T^2)/doping))-(B_p*(T^2)/(doping+(B_p*(T^2)))))^(-1)); 

%Calculate mu_ccs (equation 9)
mu_ccs = ((2e17)*(T^(3/2))/sqrt(ni2))*((log(1+((8.28e8)*(T^2)*(ni2^(-1/3)))))^(-1)); 

%Calculate X (equation 10)
X_n = sqrt(6*mu_L_n*(mu_I_n+mu_ccs)/(mu_I_n*mu_ccs)); 
X_p = sqrt(6*mu_L_p*(mu_I_p+mu_ccs)/(mu_I_p*mu_ccs)); 

%Calculate mobilities now!
mu_n = mu_L_n*((1.025/(1+((X_n/1.68)^1.43)))-0.025); 
mu_p = mu_L_p*((1.025/(1+((X_p/1.68)^1.43)))-0.025); 

