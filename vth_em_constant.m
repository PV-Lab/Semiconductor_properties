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
