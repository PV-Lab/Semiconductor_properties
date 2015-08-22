function [B] = B_coefficient(T)

a = 9.65614;
b = 8.05258e-2;
c = 6.02695e-4; 
d = 2.29844e-6; 
e = 4.31934e-9; 
f = 3.16154e-12;

logB = -a-(b*T)+(c*(T^2))-(d*(T^3))+(e*(T^4))-(f*(T^5));

B = 10^logB;

end