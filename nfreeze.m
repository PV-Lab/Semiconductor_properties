%%Freeze-out condition function
%This function takes as input the temperature and the doping level of the silicon sample and
%calculates the ionization level. This assumes n-type doping. Note: The
%input is one scalar temperature and one scalar doping level. 

function [f_D] = nfreeze(T,N_dop)

%Boltzmann constant
k_B = 8.61733238e-5; %eV/K

%Energy level of donor doping atom (n-type)
%Specific to phosphorous in silicon
E_Dg = 0.046; %eV (Sze, Physics of Semiconductor Devices, pg. 23)

%Call standard density of states model
[NC,NV] = DOS_std(T); %cm^-3

C = (4*N_dop/NC)*exp(E_Dg/(k_B*T)); %dimensionless
f_D = (-1+sqrt(1+2*C))/C; %dimensionless

end