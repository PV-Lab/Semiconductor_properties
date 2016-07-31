%Model DRM effect as a function of temperature
%Input parameters
T = 300; 
doping = 1.5e16; %cm-3, bulk
type = 'p'; %bulk
emitter_doping = 1e18; %cm-3 
emitter_type = 'n'; 
A_ratio = 1; %ratio of junction area to illumination area
W = 0.0280; %cm, wafer thickness

%constants
q = 1.60217662e-19; %C
%Boltzmann constant
k_B = 8.61733238e-5; %eV/K
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
% V_bi = V_bi/q; %V

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