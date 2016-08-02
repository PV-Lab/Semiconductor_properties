function DRM_w_T(T,doping,type,emitter_doping,emitter_type,W,A_ratio,deltan)

%constants
q = 1.60217662e-19; %C
k_B = 1.3806485279e-23; %J/K
epsilon_r = 11.68; %no units, relative permittivity of silicon
epsilon0 = 8.854187817e-12; %F/m
epsilon0 = epsilon0/100; %F/cm
epsilon = epsilon_r*epsilon0; 

%Get the Fermi levels at equilibrium for each separate region
[Efi_bulk,Efv_bulk,p0_bulk,n0_bulk,Eiv_bulk] = adv_Model_gen(T,doping,type);
[Efi_emitter,Efv_emitter,p0_emitter,n0_emitter,Eiv_emitter] = adv_Model_gen(T,emitter_doping,emitter_type);
%Determine the built in voltage at equilibrium
V_bi = abs(Efv_emitter-Efv_bulk); %eV

%Calculate the applied voltage at each excess carrier density
for i = 1:length(deltan)
    %Get the mobility sum at this temperature and injection level
    [u_h,u_e]=mobility_Klassen(T,type,doping,deltan(i));
    mobility_sum = u_h+u_e; 
    VA(i) = (k_B*T/q)*log((deltan(i)+n0_bulk)/n0_bulk); 
    delta_lp(i) = (sqrt(V_bi-VA(i))-sqrt(V_bi))*sqrt((2*epsilon/q)*(emitter_doping/(doping*(doping+emitter_doping)))); 
    delta_sig_junc(i) = q*doping*mobility_sum*delta_lp(i)*A_ratio; 
    delta_sig_carr(i) = deltan(i)*mobility_sum*q*W; 
end

figure;
loglog(deltan,abs(delta_sig_junc),'.');
hold all;
loglog(deltan,delta_sig_carr,'.');
xlabel('Excess carrier density [cm^-^3]','FontSize',20); 
ylabel('Excess conductance [\Omega^-^1]','FontSize',20);
legend('Junction','Carriers'); 
title(['T = ' num2str(T)],'FontSize',20);