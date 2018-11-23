fs=250; %Hz
frequencies = 2.^(-0.5:1/4:6);  
curr_freq=frequencies(10);

sigmaf = curr_freq./7;  %  7 as Tallon-Baudry et al,
sigmat = 1./sigmaf * (1./(2*pi));  % as in Tallon

% s = 7/(2*pi*curr_freq); % see https://jallen.faculty.arizona.edu/sites/jallen.faculty.arizona.edu/files/Chapter_13_Complex_Morlet_Wavelets_Power_Phase.pdf
% % and look also:
% % https://www.biorxiv.org/content/biorxiv/early/2018/08/21/397182.full.pdf
% % where it's clear that 7 represents the number of cycles. "For neurophysiology data such as EEG, MEG, and LFP, typical values of n
% % range from 2 to 15 over frequencies between 2 Hz and 80 Hz. Other applications may require a
% % different number of cycles. "

Lb = -3*sigmat; 
Ub = +3*sigmat;
time_support = Lb:1/fs:Ub; % 

%% Formula from: Tallon-Baudry, Catherine, et al. "Stimulus specificity of phase-locked and non-phase-locked 40 Hz visual responses in human." Journal of Neuroscience 16.13 (1996): 4240-4249.
wavelet_Tannon = (sqrt(pi)*sigmat).^(-0.5) * exp(2*pi*1i*curr_freq.*time_support) .* exp(-time_support.^2./(2*sigmat^2));   

%% Formula used in cmorwavf and taken from: Computational Signal Processing with Wavelets
wavelet_matlab = ((pi*(1/sigmaf.^2)).^(-0.5)) * exp(2*pi*1i*curr_freq.*time_support) .* exp(-(time_support.^2)*(sigmaf^2)); %% this matches matlab!

%% Modified version of Matlab equation to match Tannon's formula. sqrt(2*pi*(A)) and 2*pi^2 inside the exp of the Gaussian
wavelet_matlab_modified = sqrt(2*pi*((pi*(1/sigmaf.^2)).^(-0.5))) * exp(2*pi*1i*curr_freq.*time_support) .* exp(-(time_support.^2)*(sigmaf^2)*2*pi^2); 

%%  matlab coefficients
N = length(wavelet_Tannon);
fb = 1/(sigmaf^2);
fc = curr_freq;
[psi_from_cmorwavf,x] = cmorwavf(Lb,Ub,N,fb,fc);

%% comparing differently
figure
subplot(311)
plot(x,real(psi_from_cmorwavf),'b.')
hold on
plot(x,real(wavelet_matlab),'g')
legend({'matlab cmorwavf','matlab reproduced'})
subplot(312)
plot(x,real(wavelet_matlab_modified),'k.')
hold on
plot(time_support,real(wavelet_Tannon),'r')
legend({'matlab modified','tannon'})
subplot(313)
plot(x,real(psi_from_cmorwavf),'b.')
hold on
plot(time_support,real(wavelet_Tannon),'r')
legend({'matlab cmorwavf','tannon'})








