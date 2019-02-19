clear
clc
close all

%%
% frequencies = 2.^(-0.5:1/4:6);  
% 
% %% compare jLab (https://github.com/jonathanlilly/jLab) and matlab. Are them doing the same thing?
signal=randn(1,1000);
% 
% fb_from_filter_bank = cwtfilterbank('WaveletParameters',[3,60],'SignalLength',1000,'Boundary','periodic'); 
% %Matlab: Boundary extension of signal, specified as either 'reflection' or 
% % 'periodic'. Determines how the data is treated at the boundary
% % in jLab default is periodic
% 
% [wt,period,coi,fb,scalingcfs]=cwt(signal,'FilterBank',fb_from_filter_bank);
% 
% [psi_from_filter_bank,t] = wavelets(fb_from_filter_bank);
% scales_from_filter_bank = scales(fb_from_filter_bank);
% % using psi from matlab filterbank as input to wavetrans (jLab) not
% % perfect..
% w_from_jlab=wavetrans(signal',psi_from_filter_bank', 'nodetrend')';
% 
% figure
% for curr_level=1:size(wt,1)
%     subplot(ceil(sqrt(size(wt,1))),floor(sqrt(size(wt,1))),curr_level)
%     plot(real(wt(curr_level,:)))
%     hold on
%     plot(real(w_from_jlab(curr_level,:)))
% end

%% comparing cwt and wavetrans directly
GAMMA=3; %symmetry
BETA=20; 
P_2=GAMMA*BETA; %time-bandwidth product p^2=beta*gamma

[wt,period]=cwt(signal,'WaveletParameters',[GAMMA,P_2],'ExtendSignal',false);

w_from_jlab=wavetrans(signal',{GAMMA,BETA,period*2*pi})';

figure
for curr_level=1:size(wt,1)
    subplot(ceil(sqrt(size(wt,1))),floor(sqrt(size(wt,1))),curr_level)
    plot(real(wt(curr_level,:)))
    hold on
    plot(real(w_from_jlab(curr_level,:)))
end

%% comparing different normalizations 'bandpass'=norm1 (used in Matlab) and 'energy'=norm2 (used in Tannon et.al)
% note that so far, we are using values of gamma and beta that are not
% inteded to fit the Tannon formula (they're useful just for tests)
GAMMA=3; %symmetry
BETA=20; 
P_2=GAMMA*BETA; %time-bandwidth product p^2=beta*gamma

[wt,period,coi,fb,scalingcfs]=cwt(signal,'WaveletParameters',[GAMMA,P_2],'ExtendSignal',false);

w_from_jlab=wavetrans(signal',{GAMMA,BETA,period*2*pi,'energy'})';

figure(101)
for curr_level=1:size(wt,1)
    figure(101)
    subplot(ceil(sqrt(size(wt,1))),floor(sqrt(size(wt,1))),curr_level)
    plot(real(wt(curr_level,:)))
    hold on
    plot(real(w_from_jlab(curr_level,:)))
    figure(102)
    subplot(ceil(sqrt(size(wt,1))),floor(sqrt(size(wt,1))),curr_level)
    plot(real(wt(curr_level,:))./real(w_from_jlab(curr_level,:)))
    mean_ratio(curr_level)=mean(real(wt(curr_level,:))./real(w_from_jlab(curr_level,:)));
    hold on
end
%% looking at the different normalization values
figure
plot(mean_ratio)
xlabel('Scales')
ylabel('ratio norm1/norm2')








