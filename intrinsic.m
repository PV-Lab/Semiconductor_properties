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

%%Intrinsic conduction condition function
%This function takes as input the doping level and the temperature and
%calculates the majority carrier concentration based on the principle of
%intrinsic conduction. As temperature increases, the majority carrier
%concentration increases and the conduction of the sample in the dark
%increases. This is valid for silicon only. Generic to p-type or n-type -
%when derived, the expressions are exactly the same. Note: The input is one
%scalar temperature and one scalar doping level.

function [conc] = intrinsic(T,N_dop)

%Boltzmann constant
k_B = 8.61733238e-5; %eV/K

%Bandgap in silicon
Eg = 1.124; %eV

%Call standard density of states model
[NC,NV] = DOS_std(T); %cm^-3

%Calculate equilibrium carrier concentration at given temperature
ni = sqrt(NC*NV*exp(-Eg/(k_B*T))); %cm^-3

%Calculate majority carrier concentration at given temperature
conc = (1/2)*(N_dop+sqrt(N_dop^2 + 4*(ni^2))); %cm^-3

end