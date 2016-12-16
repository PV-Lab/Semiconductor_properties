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

%[G,sG] =
%calcG_multipleR(E,pump_wavelength,thickness,sampleT,windowT,n,d,sE,sd):
%This function was written on 7/18/2015 to calculate the generation rate
%through a sample given a certain number of "passes" through the sample
%thickness due to internal reflectance. A simple model is assumed. The
%input parameters are: E (incident energy on the system, in J),
%pump_wavelength (wavelength of beam generating carriers, in nm), thickness
%(sample thickness, in microns), sampleT (measured sample temperature at
%the time of the measurement, in K), windowT (measured window temperature
%at the time of the measurement, in K), n (number of passes through the
%sample, or number of internal reflections NOT INCLUDING the initial pass),
%and d (diameter of the incident beam, in cm). sE and sd are the standard
%deviations in the beam energy and diameter, respectively, in the same
%units as the main inputs.

%Edited on July 21, 2015 to include a calculation of the error in the
%generation according to error propagation. These are the error factors
%that we can know now: E (pump energy), R (reflectivity), aBG( band to band
%absorption), and r (beam size). We need to input the error in pump energy
%(sE)and beam size (sd). The others are calculated according to their respective
%publications. In addition, eliminated the choice of model due to the new
%uncertainty calculation. 

function [G,sG] = calcG_multipleR(E,pump_wavelength,thickness,sampleT,windowT,n,d,sE,sd)

h = 6.63e-34; %Js
c = 3e8; %m/s

%photon energy
E_ph = h*c/(pump_wavelength*1e-9); %J/photon

%Beam parameters
radius = d/2; %cm
sr = sd/2; %cm, error
area = pi*(radius^2); %cm^2

%Beam energy density
E_density = E/area; %J/cm2

%Cut the incident beam energy according to the transmission by quartz. Use
%this function if the beam energy is NOT measured with the quartz plate in
%place.
% E_density = quartz(E_density,windowT); 

%photon density incident on the sample before any absorption
photon_density = E_density/E_ph; %photons/cm2

%Get the reflectivity
[R,sR] = Green_R(sampleT,pump_wavelength); 

%Get the absorption coefficient according to Green 2008
[aBG,saBG] = Green_aBG(sampleT,pump_wavelength);

%Integral of simple generation rate according to Green, averaged over the
%wafer thickness. Note that this is ALSO averaged over the pump time of 6
%ns. 
G(1) = (1-R)*photon_density*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4); 

dGdE = (1-R)*(1-exp(-aBG*thickness*1e-4))/((thickness*1e-4)*area*E_ph); 
dGdR = (-E*(1-exp(-aBG*thickness*1e-4)))/(thickness*1e-4*area*E_ph); 
dGdaBG = ((1-R)*E*thickness*1e-4*exp(-aBG*thickness*1e-4))/(thickness*1e-4*area*E_ph); 
dGdr = (-2*(1-R)*E*(1-exp(-aBG*thickness*1e-4)))/(thickness*1e-4*pi*E_ph*(radius^3)); 
sG(1) = sqrt(((dGdE^2)*(sE^2))+((dGdR^2)*(sR^2))+((dGdaBG^2)*(saBG^2))+((dGdr^2)*(sr^2))); 

%Attenuated beam after absorption
I = (1-R)*photon_density*exp(-aBG*thickness*1e-4); 
dIdR = -E*exp(-aBG*thickness*1e-4)/(area*E_ph); 
dIdE = (1-R)*exp(-aBG*thickness*1e-4)/(area*E_ph); 
dIdr = (-2*E*(1-R)*exp(-aBG*thickness*1e-4))/(area*radius*E_ph); 
dIdaBG =(-E*(1-R)*thickness*1e-4*exp(-aBG*thickness*1e-4))/(area*E_ph); 
sI = sqrt(((dIdR^2)*(sR^2))+((dIdE^2)*(sE^2))+((dIdr^2)*(sr^2))+((dIdaBG^2)*(saBG^2))); 

%Now look at all of the passes
count = 1;
while count<=n 
    
    I_R = I*R; %we only care about the rays that are reflected by the back surface. This is opposite to the initial reflectance. 
    
    G_thisPass = I_R*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4);
    G(count+1) = G_thisPass; 
    
    dGdR = I*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4); 
    dGdI = R*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4); 
    dGdaBG = I_R*thickness*1e-4*exp(-aBG*thickness*1e-4)/(thickness*1e-4); 
    
    sG(count+1) = sqrt(((dGdR^2)*(sR^2))+((dGdI^2)*(sI^2))+((dGdaBG^2)*(saBG^2))); 
    
    I = I_R*exp(-aBG*thickness*1e-4); 
    dIdR = I*exp(-aBG*thickness*1e-4);  
    dIdI = R*exp(-aBG*thickness*1e-4); 
    dIdaBG = -thickness*1e-4*I*R*exp(-aBG*thickness*1e-4); 
    sI = sqrt(((dIdR^2)*(sR^2))+((dIdI^2)*(sI^2))+((dIdaBG^2)*(saBG^2)));
    
    count = count+1; 
  
end

figure; 
errorbar(G,sG,'o','MarkerSize',10);
xlabel('Number of passes'); 
ylabel('Excess carriers generated by each pass'); 
    