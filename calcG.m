%{
MIT License

Copyright (c) [2016] [Mallory Ann Jensen, jensenma@alum.mit.edu]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}

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




