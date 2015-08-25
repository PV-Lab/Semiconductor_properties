%[aBG,sBG] = Green_aBG(T,pump_lambda): This function was written on July 2,
%2015 to calculate the band to band absorption as a function of temperature
%according to Green 2008. The inputs are sample temperature in degrees
%Kelvin and incident wavelength in nm. The outputs are band to band
%absorption coefficient (/cm) and the standard deviation in the coefficient
%(/cm) calculated according to error propagation assuming no interacting
%terms.

%Edited on July 21, 2015 to include a calculation of the error in the
%reflectivity according to accuracy values in Green's paper. 

%MAX WAVELENGTH = 1450 nm
%MIN WAVELENGTH = 250 nm

function [aBG,saBG] = Green_aBG(T,pump_lambda)

load('C:\Users\Mallory\Documents\Lifetime spectroscopy\Experiments\wavelength_alpha_Calpha.mat'); 
%column 1 of this file contains wavelength in microns
%column 2 of this file contains absorption coefficient at room temperature
%in /cm
%column 3 of this file contains the temperature coefficient in 1e-4/K

pump_lambda = pump_lambda*1e-9*1e6;

hold = abs(save_data(:,1)-pump_lambda);
[value,index] = min(hold);

C_alpha = save_data(index,3)*1e-4;

T0 = 300;

b = C_alpha*T0; 

alpha0 = save_data(index,2);

aBG = alpha0.*((T./T0).^b); 

saBG = (4/100)*aBG; %4% error according to Green. This is dependent on wavelength we will accept 4% for most pump wavelengths. 