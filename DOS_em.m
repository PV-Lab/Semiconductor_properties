%%Effective mass density of states model
%This function takes as input the temperature of the sample and calculates
%the density of states based on the effective mass model, pg. 23 of Rein.
%This assumes a silicon sample. 

function [NC,NV] = DOS_em(T)

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

%Bandgap in silicon at input temperature and at T = 0K
[Eg] = Sze(T); %eV
[Eg0] = Sze(0); %eV

%Calculate electron effective mass relative to electron rest mass
mem0 = (6^(2/3))*((((C*(Eg0/Eg))^2)*mlm0)^(1/3)); %dimensionless

%Calculate hole effective mass relative to electron rest mass
mhm0 = ((a+(b*T)+(c*(T^2))+(d*(T^3))+(e*(T^4)))/(1+(f*T)+(g*(T^2))+(h*(T^3))+(i*(T^4))))^(2/3); %dimensionless

%Calculate density of states in conduction band
NC = N*(mem0^(3/2))*((T/300)^(3/2)); %cm^-3

%Calculate density of states in valence band
NV = N*(mhm0^(3/2))*((T/300)^(3/2)); %cm^-3

end



