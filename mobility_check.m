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
%% Check Dorkel-Leturcq model
clear all; close all; clc;
%like Fig. 3
doping = 1e14; 
T = 200:50:600; 
np = logspace(26,36,100); np = np'; 
mu_n = zeros(length(np),length(T)); 
mu_p = zeros(length(np),length(T)); 
type = 'p'; 
electron = figure;
hole = figure;
for i = 1:length(T)
    %assume p-type
    [Efi,Efv,p0,n0,Eiv] = adv_Model_gen(T(i),doping,type);
    for j = 1:length(np)
        %solve for carrier density
        a = 1; b = (n0+p0); c = (n0*p0)-np(j); 
        delta_carrier = (-b+sqrt((b^2)-(4*a*c)))/(2*a); 
        [mu_n_hold,mu_p_hold] = mobility(T(i),doping,type,delta_carrier);
        mu_n(j,i) = mu_n_hold;
        mu_p(j,i) = mu_p_hold; 
    end
    figure(electron);
    loglog(np,mu_n(:,i)); 
    hold all;
    figure(hole); 
    loglog(np,mu_p(:,i)); 
    hold all;
end

figure(electron);
xlabel('p*n [cm^-^6]'); 
ylabel('\mu_n [cm^2/Vs]'); 
legend(num2str(T')); 
figure(hole);
xlabel('p*n [cm^-^6]'); 
ylabel('\mu_p [cm^2/Vs]'); 
legend(num2str(T')); 

        
    