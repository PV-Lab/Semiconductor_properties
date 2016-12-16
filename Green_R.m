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

%[R,sR] = Green_R(T,pump_lambda): This function was written on July 2, 2015
%to determine the reflectivity of silicon at a given temperature according
%to Green 2008. The inputs are sample temperature in degrees Kelvin and
%incident wavelength in nm. The outputs are reflectivity (percentage) and
%the standard deviation in the reflectivity (percentage) calculated
%according to error propagation assuming no interacting terms.

%Edited on July 21, 2015 to include a calculation of the error in the
%reflectivity according to accuracy values in Green's paper. 

%MAX WAVELENGTH = 1450 nm
%MIN WAVELENGTH = 250 nm

function [R,sR] = Green_R(T,pump_lambda)

load('C:\Users\Mallory\Documents\Lifetime spectroscopy\Experiments\wavelength_alpha_Calpha.mat'); 
%column 4 of this file contains real refractive index
%column 5 of this file contains imaginary refractive index
%column 6 of this file contains the temperature coefficient in 1e-4/K

pump_lambda = pump_lambda*1e-9*1e6;

hold = abs(save_data(:,1)-pump_lambda);
[value,index] = min(hold);


C_n = save_data(index,6)*1e-4;
C_k = save_data(index,3)*1e-4; 


T0 = 300;

b_n = C_n*T0; 
b_k = C_k*T0; 

n0 = save_data(index,4);
k0 = save_data(index,5); 

n = n0.*((T./T0).^b_n); 

if isnan(k0)==1
    k = 0;
else
    k = k0.*((T./T0).^b_k); 
end

%refractive index of nitrogen
n_N2 = 1.0; 

%Reflectivity at this temperature
R = (((n-n_N2)^2)+(k^2))/(((n+n_N2)^2)+(k^2)); 

sn = (0.1/100)*n; %0.1% error according to Green
sk = (4/100)*k; %4% error according to Green. This is dependent on wavelength we will accept 4% for most pump wavelengths. 

dRdn = (-4*n_N2*((n_N2^2)+(k^2)-(n^2)))/(((n_N2^2)+(2*n_N2*n)+(k^2)+(n^2))^2);
dRdk = (8*n_N2*k*n)/(((n_N2^2)+(2*n_N2*n)+(k^2)+(n^2))^2);

sR = sqrt(((dRdn^2)*(sn^2))+((dRdk^2)*(sk^2))); 
