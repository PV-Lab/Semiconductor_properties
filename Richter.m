function [tau_intr] = Richter(T,delta,N_dop,type);
%This function takes as input the temperature of the sample, the excess
%minority carrier density of the sample, the doping level of the sample,
%and the type (n or p) of the sample. 

%Models used:
%Radiative Recombination Coefficient, 90-363K, Nguyen APL (2014)
%Relative Radiative Recombination Coefficient, 77-400K, Altermatt Conf Proc
%(2005)
%Bandgap narrowing, 0-1000K, Sze. deltaEg define relative to the energy gap
%at 0 per the Sze model.
%n0, p0 based on temperature-dependent models defined by Rein, valid
%throughout temperature range
%Parameterisation of Auger including g values, 77-400K, Altermatt 1997

Eg0 = 1.170; %eV, per Rein pg. 21
EgT = Sze(T);
deltaEg = Eg0-EgT;
%Fermi level and intrinsic concentrations
[Efi,Efv,p0,n0] = adv_Model_gen(T,N_dop,type); %These parameters don't depend on the defect.
ni = 9.7e9; %cm^-3, intrinsic carrier concentration at 300K per Richter 2012
kB = 8.61733238e-5; %eV/K, Boltzmann constant
beta = 1/(kB*T);
nieff = ni*exp(beta*deltaEg/2);

%Brel per Altermatt et al. IEEE Numerical Simulation Conference (2005).
deltan = delta;
deltap = delta;
n = n0+deltan;
p = p0+deltap;
bmax = 1.00;
rmax = 0.20;
rmin = 0.00;
smax = 1.5e18;
smin = 1e7;
wmax = 4e18;
wmin = 1e9;
b2 = 0.54;
r1 = 320;
s1 = 550;
w1 = 365;
b4 = 1.25;
r2 = 2.50;
s2 = 3.00;
w2 = 3.54;
bmin = rmax+((rmin-rmax)/(1+((T/r1)^r2)));
b1 = smax+((smin-smax)/(1+((T/s1)^s2)));
b3 = wmax+((wmin-wmax)/(1+((T/w1)^w2)));
Brel = bmin+((bmax-bmin)/(1+((n+(p/b1))^b2)+((n+(p/b3))^b4)));

Blow = B_coefficient(T);
N0eeh = 3.3e17; %cm^-3 
N0ehh = 7e17; %cm^-3

geeh = 1+13*(1-tanh((n0/N0eeh)^0.66));
gehh = 1+7.5*(1-tanh((p0/N0ehh)^0.63));

tau_intr = delta/(((n*p)-(nieff^2))*(((2.5e-31)*geeh*n0)+((8.5e-32)*gehh*p0)+((3e-29)*(delta^0.92))+(Brel*Blow)));

end