%% the aim of this script is to compare different formulas of the morlet wavelet
% 1) from Tannon-Baudry: 
% 2) from Matlab cmorwavf (Complex Morlet wavelet):
clear
clc
close all

%%
fs=250; %Hz
frequencies = 2.^(-0.5:1/4:6);  
curr_freq=frequencies(10);

%% From Lilly 2009 
v=curr_freq;
v_tilde=v/omega_v;
omega_v=sqrt(-log(1-v_tilde)/v_tilde); % need to numerically solve this

a_v=2*(omega_v/v)*exp((1/2)*(omega_v-v));
psi_v=a_v*exp(-(1/2).*(t.^2)).*(exp(1i*v*t) - exp(-(1/2)*(v^2))); % from Lilly 2009
% v is the carrier wave frequency

% omega_v is the peak frequency at which the frequency domain wavelet
% obtain its maximum value, which is not the same as the carrier frequency
% v

% a_v is the normalization coefficient

%% 
sigmaf = curr_freq./7;  %  7 as Tallon-Baudry et al,
sigmat_TANNON = 1./(sigmaf) * (1./(2*pi)); 
sigmat_MATLAB = 1./(sigmaf) * (1./sqrt(2));  % as in Tallon. NOT SURE IT'S ALWAYS TRUE
sigmaf_matlab=1./(sigmat_TANNON) * (1./sqrt(2));
% help cwt in maxScale you can read:
% The standard deviation of the Morse wavelet in time, ? is approximately 
% where P is the time-bandwidth product. The standard deviation in frequency, ?
% is approximately ... 

Lb = floor(-3*sigmat_MATLAB); 
Ub = ceil(+3*sigmat_MATLAB);
time_support = Lb:1/fs:Ub; % 

%% Formula from: Tallon-Baudry, Catherine, et al. "Stimulus specificity of phase-locked and non-phase-locked 40 Hz visual responses in human." Journal of Neuroscience 16.13 (1996): 4240-4249.
wavelet_Tannon = (sqrt(pi)*sigmat_TANNON).^(-0.5) * exp(2*pi*1i*curr_freq.*time_support) .* exp(-time_support.^2./(2*sigmat_TANNON^2));   

%%  matlab coefficients
N = length(wavelet_Tannon);
fb = 1/(sigmaf_matlab^2);
fc = curr_freq;
[psi_from_cmorwavf,x] = cmorwavf(Lb,Ub,N,fb,fc);

%% cwt is equal to cmorwavf?
[wt,f,coi,fb,scalingcfs] = cwt(rand(size(psi_from_cmorwavf)),'amor',fs,'VoicesPerOctave',4,'FrequencyLimits',[2^(-.5) 64]); % 'FrequencyLimits',[2^(-.5) 64] works only from R.2018
xrec=icwt(wt,'amor',f,[0.71 64]);

%% check fiter bank used
figure
freqz(fb)
title('Frequency Responses Morlet Wavelet')

[psi_cwt, t] = wavelets(fb); % wavelets used by cwt

%% strange scalingcfs what doest it mean?
figure
plot(scalingcfs)
% Scaling coefficients for the CWT if the analyzing wavelet 
% is 'morse' or 'amor',
%% quali wavelet ha usato
figure
plot(real(psi_cwt(17,:)))

%% comparing differently
figure
subplot(211)
plot(time_support,real(psi_from_cmorwavf),'b.')
hold on
plot(time_support,real(wavelet_Tannon),'r')
plot(time_support,100*real(psi_cwt(18,:)),'k')% the order is reversed 27-9
legend({'matlab cmorwavf','tannon','cwt(18)*100'})
subplot(212)
plot(time_support,real(psi_from_cmorwavf)-real(wavelet_Tannon))
title('Difference cmowravf-tannon')

%% still to clarify:
%% time_support and x are different (understand why)
%%





