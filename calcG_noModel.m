%This function was written on July 2, 2015 to calculate the generation rate
%in silicon as a function of incident beam energy (J), pump wavelength (nm), sample thickness (um)


function [G] = calcG_noModel(E,pump_wavelength,thickness)

h = 6.63e-34; %Js
c = 3e8; %m/s

%photon energy
E_ph = h*c/(pump_wavelength*1e-9); %J/photon

%Beam parameters
diameter = 0.75; %cm
radius = diameter/2; %cm
area = pi*(radius^2); %cm^2

%Beam energy density
E_density = E/area; %J/cm2

%photon density
photon_density = E_density/E_ph; %photons/cm2

%Simple calculation of generation rate
G_wafer = 16.3*photon_density*exp(-16.3*(thickness*1e-4)); 

%Integral of the above expression, averaged over the wafer thickness
G = photon_density*(1-exp(-16.3*thickness*1e-4))/(thickness*1e-4); 

end




