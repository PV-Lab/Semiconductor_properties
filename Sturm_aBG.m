%This function was written on July 2, 2015 to calculate the band to band
%absorption as a function of temperature according to Sturm 1992. The
%inputs are temperature (degrees K) and pump wavelength (nm)

function [aBG] = Sturm_aBG(T,pump_lambda)

h = 4.135e-15; %eV s
c = 2.998e8; %m/s

kB = 8.617e-5; %eV/K

theta_1 = 212; %transverse acoustic phonon energy, K
theta_2 = 670; %transverse optical phonon energy, K
theta = [theta_1, theta_2];

A = 4.73e-4; %eV/K
B = 635; %K
Eg0 = 1.155; %eV

Eg = Eg0-((A.*(T.^2))./(B+T)); %eV, bandgap at this temperature

aBG = 0; 

for i = 1:2
    for l = 1:2
        E = (h*c/(pump_lambda*1e-9))-Eg+(((-1)^l)*kB*theta(i)); %eV

        if E>=0.0055
            alpha(1) = (0.504.*sqrt(E))+(392.*((E-0.0055).^2));
            alpha(2) = (18.08.*sqrt(E))+(5760.*((E-0.0055).^2)); 
        elseif E>=0 
            alpha(1) = 0.504.*sqrt(E);
            alpha(2) = 18.08.*sqrt(E); 
        else
            alpha(1) = 0;
            alpha(2) = 0; 
        end

        quantity = ((-1).^l).*alpha(i)./(exp(((-1).^l).*theta(i)./T)-1); %cm^-1
        aBG = aBG+quantity; %cm^-1
    end
end