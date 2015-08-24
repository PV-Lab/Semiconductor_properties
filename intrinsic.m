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