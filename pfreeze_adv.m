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

%%Freeze-out condition function
%This function takes as input the temperature and the doping level of the
%silicon sample and calculates the ionization level. The advanced density
%of states model is used. This assumes p-type doping. Note: The input is
%one scalar temperature and one scalar doping level.

function [f_A] = pfreeze_adv(T,N_dop)

%Boltzmann constant
k_B = 8.61733238e-5; %eV/K

%Energy level of acceptor doping atom (p-type)
%Specific to boron in silicon
%This level is assumed to be pinned to the valence band so as the bandgap
%shrinks there is no effect on this value. 
E_Ag = 0.045; %eV (pg.16 Rein)

%Call advanced density of states model
[NC,NV] = DOS_em(T); %cm^-3

C = (4*N_dop/NV)*exp(E_Ag/(k_B*T)); %dimensionless
f_A = (-1+sqrt(1+2*C))/C; %dimensionless

end