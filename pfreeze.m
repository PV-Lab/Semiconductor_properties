%%Freeze-out condition function
%This function takes as input the temperature and the doping level of the silicon sample and
%calculates the ionization level. This assumes p-type doping. Note: The
%input is one scalar temperature and one scalar doping level. 

function [f_A] = pfreeze(T,N_dop)

%Boltzmann constant
k_B = 8.61733238e-5; %eV/K

%Energy level of acceptor doping atom (p-type)
%Specific to boron in silicon
E_Ag = 0.045; %eV (pg.16 Rein)

%Call standard density of states model
[NC,NV] = DOS_std(T); %cm^-3

C = (4*N_dop/NV)*exp(E_Ag/(k_B*T)); %dimensionless
f_A = (-1+sqrt(1+2*C))/C; %dimensionless

end


