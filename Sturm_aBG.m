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