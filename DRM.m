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

%Model DRM effect as a function of temperature
%Input parameters
mobility_sum = 1600.31528425;
T = 400; 
doping = 1.5e16; %cm-3, bulk
type = 'p'; %bulk
emitter_doping = 1e18; %cm-3 
emitter_type = 'n'; 
A_ratio = 1; %ratio of junction area to illumination area
W = 0.0280; %cm, wafer thickness

%constants
q = 1.60217662e-19; %C
%Boltzmann constant
k_B = 1.3806485279e-23; %J/K
epsilon_r = 11.68; %no units, relative permittivity of silicon
epsilon0 = 8.854187817e-12; %F/m
epsilon0 = epsilon0/100; %F/cm
epsilon = epsilon_r*epsilon0; 

%What is the built-in potential? The difference between quasi fermi
%energies in each type. The quasi fermi energy is the location of the fermi
%level if the two types were not placed in contact. 
[Efi_bulk,Efv_bulk,p0_bulk,n0_bulk,Eiv_bulk] = adv_Model_gen(T,doping,type);
[Efi_emitter,Efv_emitter,p0_emitter,n0_emitter,Eiv_emitter] = adv_Model_gen(T,emitter_doping,emitter_type);
V_bi = abs(Efv_emitter-Efv_bulk); %eV

%What is the applied voltage?
deltan = 1e15;
if type == 'p'
    VA = (k_B*T/q)*log((deltan+n0_bulk)/n0_bulk); 
elseif type == 'n'
    VA = (k_B*T/q)*log((deltan+p0_bulk)/p0_bulk); 
end

delta_lp0 = sqrt(V_bi)*sqrt((2*epsilon/q)*(emitter_doping/(doping*(doping+emitter_doping)))); 

%Let's calculate the excess carrier density at which cross-over happens
%(conductance in the depletion region begins to dominant conductance from
%excess carriers). 
deltan_crossover = (doping*A_ratio/W)*delta_lp0; 

deltan = logspace(10,15,500); 
for i = 1:length(deltan)
    VA(i) = (k_B*T/q)*log((deltan(i)+n0_bulk)/n0_bulk); 
    delta_lp(i) = (sqrt(V_bi-VA(i))-sqrt(V_bi))*sqrt((2*epsilon/q)*(emitter_doping/(doping*(doping+emitter_doping)))); 
    delta_sig_junc(i) = q*doping*mobility_sum*delta_lp(i)*A_ratio; 
    delta_sig_carr(i) = deltan(i)*mobility_sum*q*W; 
end
figure;
loglog(deltan,abs(delta_sig_junc),'.');
hold all;
loglog(deltan,delta_sig_carr,'.');
xlabel('Excess carrier density [cm^-^3]'); 
ylabel('Excess conductance [\Ohm^-^1]');
legend('Junction','Carriers'); 

%% 
clear all; close all; 
T = [300 350 400 450 500 550 600]; 
doping = 1.5e16; %cm-3, bulk
type = 'p'; %bulk
emitter_doping = 1e19; %cm-3 
emitter_type = 'n'; 
A_ratio = 1; %ratio of junction area to illumination area
W = 0.0280; %cm, wafer thickness
deltan = logspace(10,15,500); 

for i = 1:length(T)
    DRM_w_T(T(i),doping,type,emitter_doping,emitter_type,W,A_ratio,deltan)
end
%% Replicate Cousins
clear all; close all; 
doping = 1.5e16; 
type = 'p'; 
emitter_doping = 1e18; 
emitter_type = 'n'; 
A_ratio = 1; 
W = 0.0280; 
T = 300; 
deltan = logspace(10,16,500); 
DRM_w_T(T,doping,type,emitter_doping,emitter_type,W,A_ratio,deltan)
%% Look as a function of doping level
clear all; close all; 
T = [300]; 
doping = logspace(13,17,10); %cm-3, bulk
type = 'p'; %bulk
emitter_doping = 1e19; %cm-3 
emitter_type = 'n'; 
A_ratio = 1; %ratio of junction area to illumination area
W = 0.0180; %cm, wafer thickness
deltan = logspace(10,15,500); 

for i = 1:length(doping)
    DRM_w_T(T,doping(i),type,emitter_doping,emitter_type,W,A_ratio,deltan)
end


