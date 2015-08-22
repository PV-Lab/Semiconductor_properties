%%Density of states
%This function takes as input the silicon sample temperature and calculates
%the effective density of states based on the standard model (T^3/2
%dependence). 

function [NC, NV] = DOS_std(T)
    NC300 = 2.8430e19; %cm^-3
    NV300 = 2.6821e19; %cm^-3
    NC = NC300*((T/300)^(3/2)); %cm^-3
    NV = NV300*((T/300)^(3/2)); %cm^-3
end
