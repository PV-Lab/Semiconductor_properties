%[G,sG] =
%calcG_multipleR_photonDensity(photon_density,pump_wavelength,thickness,sampleT,n,sE):
%This function calculates the steady-state generation rate
%through a sample given a certain number of "passes" through the sample
%thickness due to internal reflectance. A simple model is assumed. The
%input parameters are: photon density (incident photons on the sample, in photons/cm2),
%pump_wavelength (wavelength of beam generating carriers, in nm), thickness
%(sample thickness, in microns), sampleT (measured sample temperature at
%the time of the measurement, in K), n (number of passes through the
%sample, or number of internal reflections NOT INCLUDING the initial pass). sE is the standard
%deviation in the photon density in the same
%units as the main inputs.

function [G,sG] = calcG_multipleR_photonDensity(photon_density,pump_wavelength,thickness,sampleT,n,sE)

%Get the reflectivity
[R,sR] = Green_R(sampleT,pump_wavelength); 

%Get the absorption coefficient according to Green 2008
[aBG,saBG] = Green_aBG(sampleT,pump_wavelength);

%Integral of simple generation rate according to Green, averaged over the
%wafer thickness. Note that this is ALSO averaged over the pump time of 6
%ns. 
G(1) = (1-R)*photon_density*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4); 

% dGdE = (1-R)*(1-exp(-aBG*thickness*1e-4))/((thickness*1e-4)*area*E_ph); 
% dGdR = (-E*(1-exp(-aBG*thickness*1e-4)))/(thickness*1e-4*area*E_ph); 
% dGdaBG = ((1-R)*E*thickness*1e-4*exp(-aBG*thickness*1e-4))/(thickness*1e-4*area*E_ph); 
% dGdr = (-2*(1-R)*E*(1-exp(-aBG*thickness*1e-4)))/(thickness*1e-4*pi*E_ph*(radius^3)); 
% sG(1) = sqrt(((dGdE^2)*(sE^2))+((dGdR^2)*(sR^2))+((dGdaBG^2)*(saBG^2))+((dGdr^2)*(sr^2))); 

%Attenuated beam after absorption
I = (1-R)*photon_density*exp(-aBG*thickness*1e-4); 
% dIdR = -E*exp(-aBG*thickness*1e-4)/(area*E_ph); 
% dIdE = (1-R)*exp(-aBG*thickness*1e-4)/(area*E_ph); 
% dIdr = (-2*E*(1-R)*exp(-aBG*thickness*1e-4))/(area*radius*E_ph); 
% dIdaBG =(-E*(1-R)*thickness*1e-4*exp(-aBG*thickness*1e-4))/(area*E_ph); 
% sI = sqrt(((dIdR^2)*(sR^2))+((dIdE^2)*(sE^2))+((dIdr^2)*(sr^2))+((dIdaBG^2)*(saBG^2))); 

%Now look at all of the passes
count = 1;
while count<=n 
    
    I_R = I*R; %we only care about the rays that are reflected by the back surface. This is opposite to the initial reflectance. 
    
    G_thisPass = I_R*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4);
    G(count+1) = G_thisPass; 
    
%     dGdR = I*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4); 
%     dGdI = R*(1-exp(-aBG*thickness*1e-4))/(thickness*1e-4); 
%     dGdaBG = I_R*thickness*1e-4*exp(-aBG*thickness*1e-4)/(thickness*1e-4); 
%     
%     sG(count+1) = sqrt(((dGdR^2)*(sR^2))+((dGdI^2)*(sI^2))+((dGdaBG^2)*(saBG^2))); 
    
    I = I_R*exp(-aBG*thickness*1e-4); 
%     dIdR = I*exp(-aBG*thickness*1e-4);  
%     dIdI = R*exp(-aBG*thickness*1e-4); 
%     dIdaBG = -thickness*1e-4*I*R*exp(-aBG*thickness*1e-4); 
%     sI = sqrt(((dIdR^2)*(sR^2))+((dIdI^2)*(sI^2))+((dIdaBG^2)*(saBG^2)));
    
    count = count+1; 
  
end
sG = zeros(size(G));

figure; 
errorbar(G,sG,'o','MarkerSize',10);
xlabel('Number of passes'); 
ylabel('Excess carriers generated by each pass'); 
    