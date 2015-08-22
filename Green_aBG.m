%This function was written on July 2, 2015 to calculate the band to band
%absorption as a function of temperature according to Green 2008. The
%inputs are temperature (degrees K) and pump wavelength (nm)

%MAX WAVELENGTH = 1450 nm
%MIN WAVELENGTH = 250 nm

function [aBG] = Green_aBG(T,pump_lambda)

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
