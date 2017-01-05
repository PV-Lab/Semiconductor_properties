%Calculate the optical constant based on reflectance data. This is specific
%to the Sinton Instruments tool with a reference cell (38 mA/cm2). 
function OC = calculate_OC(R_vector,W)
%Minimum wavelength we need to evaluate at
min_wl = 820; 
max_wl = 1200; 
wl = linspace(min_wl,max_wl,500); 
%Interpolate the reflectivity vector
R_interp = interp1(R_vector(:,1),R_vector(:,2),wl); 
integrand = zeros(size(wl)); 
for i = 1:length(integrand)
    %Get the reflectivity at this wavelength
    R = R_interp(i)/100; 
    %Get the absorption coefficient
    a = Green_aBG(298,wl(i));
    integrand(i) = (1-R)*(1+(R*exp(-a*W)))*(1-exp(-a*W))/(1-((R*exp(-a*W))^2)); 
end
%Now integrate what we just found
OC = (46.9/38)*trapz(wl,integrand); 

