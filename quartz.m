%This function was written on July 2, 2015 to calculated the amount of
%transmitted light through a quartz window at different temperatures. 

%input window temperature in K, beam energy in J, mJ or microJ (the output
%will be in the same units as the energy input)

function [transmitted] = quartz(E,T)

%Change units of temperature
T = T-273.15; %C

%index of refraction at 1050 nm (estimated from data sheet)
N0 = (((1.531-1.535)/(1.320-0.980))*1.050) + (1.535-(((1.531-1.535)/(1.320-0.980))*0.980)); 

%refractive index changes as a function of temperature
dndT = 5e-6; %/degC
N0 = N0+(dndT*(T-25)); 

%transmittance according to reflection losses only (assume no absorption)
T = (2*N0)/(N0^2+1); 

transmitted = T*E; %J