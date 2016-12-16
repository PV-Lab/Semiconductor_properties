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

function [vth_e, vth_h] = vth_em_constant(T)

%Note: This function assumes that effective mass of holes and electrons
%stays constant as temperature changes. 

m0 = 0.91095e-30; %kg

%Boltzmann constant
k_B = 1.3806488e-23; %J/K

mn300 = 0.26*m0; %kg
mp300 = 0.39*m0; %kg

vth_e300 = sqrt(3*k_B*300/mn300); %m/s
vth_h300 = sqrt(3*k_B*300/mp300); %m/s

vth_e = vth_e300*sqrt(T/300); %m/s
vth_h = vth_h300*sqrt(T/300); %m/s

%convert to cm/s
vth_e = vth_e*100; %cm/s
vth_h = vth_h*100; %cm/s

end
