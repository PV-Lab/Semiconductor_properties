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




