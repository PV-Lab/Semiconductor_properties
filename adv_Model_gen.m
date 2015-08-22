%%Fermi level calculation - advanced model
%This function takes as input the temperature and doping level of the
%sample and calculates the Fermi level based on the advanced model,
%including the freezeout condition, intrinsic conduction, advanced density
%of states model, and advanced bandgap narrowing model.  See pg 19 of Rein
%- Eq 1.24. These expressions are valid for both p and n type silicon. The
%Fermi level is calculated both relative to the intrinsic energy (Efi = Ef
%- Ei) and the valence energy (Efv = Ef-Ev). Note: The inputs are one
%scalar temperature, one scalar doping level, and type ('p' or 'n').
%Additional outputs added - hole and electron equilibrium concentrations at
%specified temperature.

function [Efi,Efv,p0,n0,Eiv] = adv_Model_gen(T,N_dop,type)

%Boltzmann constant
k_B = 8.61733238e-5; %eV/K

%Call advanced bandgap narrowing model
[Eg] = Sze(T); %eV

%Call advanced density of states model
[NC,NV] = DOS_em(T); %cm^-3

%Calculate equilibrium carrier concentration at given temperature
ni2 = NC*NV*exp(-Eg/(k_B*T)); %cm^-3

%Determine majority carrier concentration based on Eq. 1.22 in Rein (pg.
%19)
if T<350
    if type=='p'
        [f_A] = pfreeze_adv(T,N_dop);
        p0 = f_A*N_dop; %cm^-3
        n0 = ni2/p0; %cm^-3
    elseif type=='n'
        [f_D] = nfreeze_adv(T,N_dop); 
        n0 = f_D*N_dop; %cm^-3
        p0 = ni2/n0; %cm^-3
    end
elseif T>=350
    [conc] = intrinsic_adv(T,N_dop); %cm^-3
    if type=='p'
        p0 = conc; %cm^-3
        n0 = ni2/p0; %cm^-3
    elseif type=='n'
        n0 = conc; %cm^-3
        p0 = ni2/n0; %cm^-3
    end        
end

if type=='p'
    %Calculate Fermi energy relative to intrinsic energy. 
    Efi = -(Eg/2)+k_B*T*log(sqrt(NC*NV)/p0); %eV
elseif type=='n'
    %Calculate Fermi energy relative to intrinsic energy. 
    Efi = (Eg/2)-k_B*T*log(sqrt(NC*NV)/n0); %eV
end

%Calculate intrinsic energy level relative to valence band.
Eiv = (Eg/2)-((k_B*T)/2)*log(NV/NC); %eV

%Calculate Fermi energy relative to valence band = Eiv+Efi
Efv = Eiv+Efi; %eV

end