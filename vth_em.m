%%Thermal velocity
%This function takes as input the silicon sample temperature and calculates
%the thermal velocity for both electrons and holes at the specified
%temperature. This is based on the effective mass of either the electron or
%hole. Reference: Sze (Physics of Semiconductor Devices), pg 29. The
%formulas for electron and hole effective masses are taken from Rein pg.
%23. Outputs are thermal velocities in cm/s. 

function [vth_e,vth_h] = vth_em(T)

%Coefficients per Rein, pg. 23
N = 2.541e19; %cm^-3
C = 0.1905; %dimensionless
mlm0 = 0.9163; %dimensionless
a = 0.4435870; 
b = 0.3609528e-2;
c = 0.1173515e-3;
d = 0.1263218e-5;
e = 0.3025581e-8;
f = 0.4683382e-2;
g = 0.2286895e-3;
h = 0.7469271e-6;
i = 0.1727481e-8;

%Electron rest mass
m0 = 9.109e-31; %kg

%Bandgap in silicon at input temperature and at T = 0K
[Eg] = Sze(T); %eV
[Eg0] = Sze(0); %eV

%Boltzmann constant
k_B = 1.3806488e-23; %J/K

%Calculate electron effective mass relative to electron rest mass
mem0 = (6^(2/3))*((((C*(Eg0/Eg))^2)*mlm0)^(1/3)); %dimensionless

%Calculate hole effective mass relative to electron rest mass
mhm0 = ((a+(b*T)+(c*(T^2))+(d*(T^3))+(e*(T^4)))/(1+(f*T)+(g*(T^2))+(h*(T^3))+(i*(T^4))))^(2/3); %dimensionless

%Calculate effective masses of electrons and holes
me = mem0*m0; %kg
mh = mhm0*m0; %kg

vth_e = sqrt((3*k_B*T)/(me)); %m/s, Ref Gang Chen, Nanoscale energy transport and conversion, pg. 214
vth_h = sqrt((3*k_B*T)/(mh)); %m/s, Ref Gang Chen, Nanoscale energy transport and conversion, pg. 214

%Convert to cm/s
vth_e = vth_e*100; %cm/s
vth_h = vth_h*100; %cm/s

end