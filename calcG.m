%This function was written on July 2, 2015 to calculate the generation rate
%in silicon as a function of incident beam energy (J), pump wavelength (nm), sample thickness (um),sample temperature (K),
%window temperature (K)

%model means either Sturm or Green. 

function [G] = calcG(E,pump_wavelength,thickness,sampleT,windowT,model)

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

%Cut the incident beam energy according to the transmission by quartz
% E_density = quartz(E_density,windowT); 

%photon density
photon_density = E_density/E_ph; %photons/cm2

%Get the reflectivity
[R] = Green_R(sampleT,pump_wavelength); 

if strcmp(model,'Green')==1
    %Get the absorption coefficient according to Green 2008
    [aBG] = Green_aBG(sampleT,pump_wavelength);
elseif strcmp(model,'Sturm')==1
    %Get the absorption coefficient according to Sturm 1992
    [aBG] = Sturm_aBG(sampleT,pump_wavelength);
else
    error('Model specification incorrect');
end

%Simple calculation of generation rate
G_wafer = (1-R)*aBG*photon_density*exp(-aBG*(thickness*1e-4)); 

%Integral of the above expression, averaged over the wafer thickness
G = (1-R)*photon_density*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4); 

end




