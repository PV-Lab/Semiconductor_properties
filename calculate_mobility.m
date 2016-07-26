%Plot mobility as function of temperature 
T_min = 300; 
T_max = 500; 
T = linspace(T_min,T_max,1000);
doping = 4.3e15; 
type = 'p';

for i = 1:length(T)
    [mu_n(i),mu_p(i)] = mobility(T(i),doping,type);
end

figure;
plot(T,mu_n); 
hold all;
plot(T,mu_p); 