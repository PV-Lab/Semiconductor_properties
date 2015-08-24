%%Intrinsic conduction condition function
%This function takes as input the doping level and the temperature and
%calculates the majority carrier concentration based on the principle of
%intrinsic conduction. As temperature increases, the majority carrier
%concentration increases and the conduction of the sample in the dark
%increases. Both the advanced density of states and the advanced band gap
%model are use. This is valid for silicon only. Generic to p-type or n-type -
%when derived, the expressions are exactly the same. Note: The input is one
%scalar temperature and one scalar doping level.

function [conc] = intrinsic_adv(T,N_dop)

%Boltzmann constant
k_B = 8.61733238e-5; %eV/K

%Bandgap in silicon, taking into account bandgap narrowing
[Eg] = Sze(T); %eV

%Call advanced density of states model
[NC,NV] = DOS_em(T); %cm^-3

%Calculate equilibrium carrier concentration at given temperature
ni2 = NC*NV*exp(-Eg/(k_B*T)); %cm^-3

%Calculate majority carrier concentration at given temperature
conc = (1/2)*(N_dop+sqrt(N_dop^2 + 4*ni2)); %cm^-3, pg. 19 Rein

end