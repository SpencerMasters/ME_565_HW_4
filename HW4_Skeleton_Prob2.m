% Template for HW4 Problem2 postme
clear all
close all

Rs = ;      % Enter the Rs here
Q  = ;      % Battery capacity
R1 = ;      % Enter the R1 here
C1 = ;      % Enter the C1 here
alpha = ;   % Enter the alpha here


f_0 = 0.00001; % lower limit for frequency
f_end = 1000; % higher limit for frequency
W = logspace(log10(f_0*2*pi),log10(f_end*2*pi),100); % Calculate the angular frequency vector in log-space

for i = 1:length(W);
RE_Zocvr(i) = ;  % Enter the real part of the impedance of the OCV-R model here
IM_Zocvr(i) = ;  % Enter the imaginary part of the impedance of the OCV-R model here
end

plot(RE_Zocvr,-IM_Zocvr)  % Plot the Nyquist plot of the impedance of the OCV-R model
xlabel('RE(Z) (\Omega)')
ylabel('-IM(Z) (\Omega)')
xlim([0,0.1])


for i = 1:length(W);
RE_Zocvrrc(i) = ; % Enter the real part of the impedance of the OCV-R-RC model here
IM_Zocvrrc(i) = ; % Enter the imaginary part of the impedance of the OCV-R-RC model here
end

figure;
plot(RE_Zocvrrc,-IM_Zocvrrc) % Plot the Nyquist plot of the impedance of the OCV-R-RC model
xlabel('RE(Z) (\Omega)')
ylabel('-IM(Z) (\Omega)')
xlim([0,0.15])
ylim([0 0.2])
