%{
MIT License

Copyright (c) [2016] [Mallory Ann Jensen, jensenma@alum.mit.edu]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}

%% SRH: standard model (no bandgap narrowing, no effective mass DOS, no complicated vth)
%This function takes as input all of the defect parameters, including:
%defect concentration (Nt, cm^-3), electron capture cross section (sigma_n,
%cm^2), hole capture cross section (sigma_p, cm^2), defect energy level
%relative to conduction band (Ect=Ec-Et, eV), and defect energy level
%relative to valence band (Etv=Et-Ev, eV). Let Ect=0 if Etv is known and vice verse. Additional inputs required
%include: temperature of the sample (T, K), excess carrier density
%(delta_n, cm^-3), doping level (N_dop, cm^-3), and type ('n' or 'p'). The
%output of this function is the SRH lifetime at the specified temperature
%and excess carrier density. ****NOTE: this is the full SRH equation
%without any simplications for type or injection level. This likely cannot
%be used due to a lack of data about defect parameters.

function [tau_SRH,n1,p1] = SRH_full_std(Nt,sigma_n,sigma_p,Ect,Etv,T,delta_n,N_dop,type)

%Get sample parameters at specified temperature
[Efi,Efv,p0,n0] = std_Model_gen(T,N_dop,type); 

%Temperature-dependent thermal velocity
[vth_e,vth_h] = vth_em(T); %cm/s, see pg. 85 of Rein

%Bandgap in silicon
Eg = 1.124; %eV

%Get DOS at temperature based on standard model
[NC, NV] = DOS_std(T);

%Boltzmann constant
k_B = 8.61733238e-5; %eV/K

%Calculate the SRH parameters
tau_n0 = (Nt*sigma_n*vth_e)^-1; %seconds
tau_p0 = (Nt*sigma_p*vth_h)^-1; %seconds

%Put defect energies the way we want them
if Ect==0&&Etv~=0
    Ect=Eg-Etv; %eV
    Etv = Etv; %eV
elseif Ect~=0&&Etv==0
    Etv = Eg-Ect; %eV
    Ect = Ect; %eV
else
    Etv = NaN; %error 
    Ect = NaN; %error
end

%Calculate SRH densities
n1 = NC*exp(-Ect/(k_B*T)); %cm^-3
p1 = NV*exp(-Etv/(k_B*T)); %cm^-3

%Finally, calculate the SRH lifetime 
tau_SRH = ((tau_n0*(p0+p1+delta_n))+(tau_p0*(n0+n1+delta_n)))/(p0+n0+delta_n); %seconds

%Convert from seconds to microseconds
tau_SRH = tau_SRH*1e6; %microseconds

end



