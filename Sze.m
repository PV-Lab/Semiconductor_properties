%%Sze band gap narrowing model
%This function takes as input the temperature of the sample and calculates
%the band gap at the specified sample. Silicon is assumed. This is equation
%1.25 on pg. 21 of Rein. 

function [Eg] = Sze(T)

Eg0 = 1.170; %eV, per Rein pg. 21

alpha = 4.73e-4; %eV/K

beta = 636; %K

Eg = Eg0-(alpha*(T^2)/(T+beta)); %eV

end