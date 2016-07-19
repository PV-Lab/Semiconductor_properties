%%Thermal velocity
%This function takes as input the silicon sample temperature and calculates
%the thermal velocity for both electrons and holes at the specified
%temperature. This is based on the effective mass of either the electron or
%hole. Reference: Green JAP 1990 and Sze (Physics of Semiconductor Devices), pg 29. The
%formulas for electron and hole effective masses are partially taken from Rein pg.
%23 (original reference Green JAP 1990). Outputs are thermal velocities in cm/s. 

function [vth_e,vth_h] = vth_em(T)

%Electron rest mass
m0 = 9.10938291e-31; %kg

%Bandgap in silicon at input temperature and at T = 0K
[Eg] = Sze(T); %eV
[Eg0] = Sze(0); %eV

%Boltzmann constant
k_B = 1.3806488e-23; %J/K

%Calculate the electron thermal velocity effective mass (mtc* in Green JAP
%1990)
ml = 0.9163*m0;
mtm0 = 0.1905*(Eg0/Eg); 
mt = mtm0*m0; 
delta = sqrt((ml-mt)/ml); 
me  = 4*ml/((1+(((ml/mt)^(1/2))*(asin(delta)/delta)))^2);

%Calculate the hole thermal velocity effective mass (Table 4 in
%10.1088/0022-3719/14/21/011)
meth_v0= 0.3676;
meth_v1= 0;
meth_v2= 1.98738e-5;
meth_v3= -2.588144e-7;
meth_v4= 1.415372e-9;
meth_v5= -3.919169e-12;
meth_v6= 5.410849e-15;
meth_v7= -2.959797e-18;

mh_th = meth_v0 + meth_v1*T + meth_v2*(T^2) + meth_v3*(T^3) + meth_v4*(T^4) + meth_v5*(T^5) + meth_v6*(T^6)+ meth_v7*(T^7); 
mh = mh_th*m0; 

%Calculate the thermal velocities given the effective masses
vth_e = sqrt((8*k_B*T)/(pi*me)); %m/s, Ref Green JAP 1990 equation 10
vth_h = sqrt((8*k_B*T)/(pi*mh)); %m/s, Ref Green JAP 1990 equation 10
%Convert to cm/s which will be used in our other calculations
vth_e = vth_e*100; %cm/s
vth_h = vth_h*100; %cm/s



end