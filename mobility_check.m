%Plot mobility with temperature
T = linspace(100,500,500); 
doping = 1.5e16; 
type = 'p'; 
delta_carr = 0; 
for i = 1:length(T)
    [h,e]=mobility_Klassen(T(i),type,doping,delta_carr);
    u_h(i) = h; 
    u_e(i) = e;
end
figure;
plot(T,u_h); 
hold all;
plot(T,u_e); 
legend('hole','electron')