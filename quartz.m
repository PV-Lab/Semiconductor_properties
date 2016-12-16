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