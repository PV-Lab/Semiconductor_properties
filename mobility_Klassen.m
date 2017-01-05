function [u_h,u_e]=mobility_Klassen(T,type,doping,delta_carr)
%T is in K. type is 'n' or 'p'. 
if type == 'n'
    Nd = doping;
    Na = 0;
elseif type == 'p'
    Na = doping; 
    Nd = 0; 
end
%Random constants
s1 = .89233;
s2 = .41372;
s3 = .19778;
s4 = .28227;
s5 = .005978;
s6 = 1.80618;
s7 = 0.72169;
r1 = .7643;
r2 = 2.2999;
r3 = 6.5502;
r4 = 2.367;
r5 = -0.8552;
r6 = .6478;
fcw = 2.459; 
fbh = 3.828; 
c_e = 0.21;
c_h = 0.5; 
nref2_e = 4e20;
nref2_h = 7.2e20;
umax_e = 1414;
theta_e = 2.285;
umin_e = 68.5; 
alpha_e = 0.711; 
mr_e = 1; 
mr_h = 1.258; 
umin_h = 44.9; 
umax_h = 470.5; 
theta_h = 2.247; 
alpha_h = 0.719;
nref_e = 9.2e16;
nref_h = 2.23e17; 
%We need one calculation for the electron and one calculation for the hole,
%regardless of type. 

%For this we want the background electron/hole concentrations
[Efi,Efv,p0,n0,Eiv] = adv_Model_gen(T,doping,type);
ne = n0+delta_carr; 
nh = p0+delta_carr;
carrier_sum = nh+ne; 
Z_e = 1+1/(c_e+(nref2_e/Nd)^2);
Z_h = 1+1/(c_h+(nref2_h/Na)^2); 

%Mobility for electron
%lattice scattering for electron
uLS_e = umax_e*((300/T)^theta_e);  
%uDCS for electron
un_e = umax_e^2/(umax_e-umin_e)*(T/300)^(3*alpha_e-1.5); 
Nsc_e = Nd*Z_e+Na*Z_h+nh; 
PCW_e = (3.97e13)*(1/(Nsc_e)*((T/300)^3))^(2/3);
PBH_e = (1.36e20)/carrier_sum*(mr_e*(T/300)^2); 
P_e = 1/(fcw/PCW_e+fbh/PBH_e); 
b = -s1/(s2+(T/300/mr_e)^s4*P_e)^s3;
c = s5/((300/T/mr_e)^s7*P_e)^s6; 
G_e = 1+b+c; 
F_e = (r1*P_e^r6+r2+r3*mr_e/mr_h)/(P_e^(r6)+r4+r5*mr_e/mr_h);
Nsceff_e = G_e*Na*Z_h+Nd*Z_e+nh/F_e;
uc_e = umin_e*umax_e/(umax_e-umin_e)*(300/T)^(1/2); 
uDCS_e = un_e*Nsc_e/Nsceff_e*(nref_e/Nsc_e)^(alpha_e)+(uc_e*carrier_sum/Nsceff_e); 
u_e = 1/(1/uDCS_e+1/uLS_e); 

%Now we get the equivalent to the above for the hole
%lattice scattering for hole
uLS_h = umax_h*((300/T)^theta_h);
%uDCS for hole
un_h = umax_h^2/(umax_h-umin_h)*(T/300)^(3*alpha_h-1.5); 
Nsc_h = Nd*Z_e+Na*Z_h+ne; 
PCW_h = (3.97e13)*(1/(Nsc_h)*((T/300)^3))^(2/3); 
PBH_h = (1.36e20)/carrier_sum*(mr_h*(T/300)^2);
P_h = 1/(fcw/PCW_h+fbh/PBH_h);
b = -s1/(s2+(T/300/mr_h)^s4*P_h)^s3; 
c = s5/((300/T/mr_h)^s7*P_h)^s6;
G_h = 1+b+c; 
F_h = (r1*P_h^r6+r2+r3*mr_h/mr_e)/(P_h^(r6)+r4+r5*mr_h/mr_e);
Nsceff_h = G_h*Nd*Z_e+Na*Z_h+ne/F_h; 
uc_h = umin_h*umax_h/(umax_h-umin_h)*(300/T)^(1/2); 
uDCS_h = un_h*Nsc_h/Nsceff_h*(nref_h/Nsc_h)^(alpha_h)+(uc_h*carrier_sum/Nsceff_h);
u_h = 1/(1/uDCS_h+1/uLS_h); 









% if type == 'p'
%     %The majority carrier is the hole. We will have Boron doping.
%     mu_max = 470.5; %cm2/Vs
%     thetai = 2.247; %for hole, pg 2 first paragraph of Klaassen part II
%     mu_min = 44.9; %cm2/Vs
%     Nref1 = 2.23e17; %/cm3
%     alpha1 = 0.719; 
%     alpha2 = 2.0;
%     c = 0.5; 
%     NrefZ = 7.2e20; %/cm3
%     mr = 1.258; 
% elseif type == 'n'
%     %The majority carrier is the electron. We will have Phosphorous doping.
%     mu_max = 1414.0; %cm2/Vs
%     thetai = 2.285; %for electron, pg 2 first paragraph of Klaassen part II
%     mu_min = 68.5; %cm2/Vs
%     Nref1 = 9.2e16; %/cm3
%     alpha1 = 0.711; 
%     alpha2 = 1.98; 
%     c = 0.21; 
%     NrefZ = 4.0e20; %/cm3
%     mr = 1;
% end
% %Calculate the lattice scattering term (majority carrier)
% mu_LS = mu_max*((300/T)^thetai); %cm2/Vs
% %Calculate the impurity scattering term (majority carrier)
% mu_iN = ((mu_max^2)/(mu_max-mu_min))*((T/300)^((3*alpha1)-1.5)); 
% mu_ic = ((mu_min*mu_max)/(mu_max-mu_min))*((300/T)^0.5); 
% %For this we want the background electron/hole concentrations
% [Efi,Efv,p0,n0,Eiv] = adv_Model_gen(T,doping,type);
% carriers_e = n0+delta_carr; 
% carriers_h = p0+delta_carr;
% carriers = carriers_e+carriers_h; 
% %Calculate the clustering function 
% Z = 1+(1/(c+((NrefZ/N)^2)));
% if type == 'n'
%     Nsc = doping*Z+carriers_h; 
% elseif type == 'p'
%     Nsc = doping*Z+carriers_e;
% end
% PCW = 3.97e13*(1/(Nsc*((T/300)^3))^(2/3)); 
% PBH = 1.36/carriers*(mr*((T/300)^2)); 
% P = 
% a = 
% b = 
% c = 
% G = a+b+c; 
% F = 
% if type == 'n'
%     Nsceff = Na+Nd+carriers_h/F; 
% elseif type == 'p'
%     Nsceff = Na+Nd+carriers_e/F; 
% mu_IS = mu_iN*Nsc/Nsceff*(Nref1/Nsc)^alpha1+(mu_ic*carriers/Nsceff);
% mobility = 1/((1/u_IS)+(1/u_LS)); 