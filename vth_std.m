%%Thermal velocity
%This function takes as input the silicon sample temperature and calculates
%the thermal velocity based on a T^1/2 model. See pg. 85 of Rein for
%description/reference. 

function [vth] = vth_std(T)
    vth300 = 1e7; %cm/s, see pg. 85 of Rein
    vth = vth300*((T/300)^(1/2)); %cm/s
end
