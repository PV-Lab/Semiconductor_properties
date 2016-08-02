function [De,Dh] = diffusivity(T,type,doping,delta_carr) 
    %First get the mobility of each carrier
    [u_h,u_e]=mobility_Klassen(T,type,doping,delta_carr);
    
    %Now it's a simple calculation which uses some constants
    k_B = 8.61733238e-5; %eV/K
    
    Dh = u_h*k_B*T; 
    De = u_e*k_B*T; 