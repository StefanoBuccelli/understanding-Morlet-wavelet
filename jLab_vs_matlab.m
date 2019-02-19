clear
clc
close all

%%
% frequencies = 2.^(-0.5:1/4:6);  

%% compare jLab (https://github.com/jonathanlilly/jLab) and matlab. Are them doing the same thing?
signal=randn(1,1000);

fb_from_filter_bank = cwtfilterbank('WaveletParameters',[3,60],'SignalLength',1000,'Boundary','periodic'); 
%Matlab: Boundary extension of signal, specified as either 'reflection' or 
% 'periodic'. Determines how the data is treated at the boundary
% in jLab default is periodic

[wt,period,coi,fb,scalingcfs]=cwt(signal,'FilterBank',fb_from_filter_bank);

[psi_from_filter_bank,t] = wavelets(fb_from_filter_bank);
scales_from_filter_bank = scales(fb_from_filter_bank);

w_from_jlab=wavetrans(signal',psi_from_filter_bank', 'nodetrend')';

figure
for curr_level=1:size(wt,1)
    subplot(ceil(sqrt(size(wt,1))),floor(sqrt(size(wt,1))),curr_level)
    plot(real(wt(curr_level,:)))
    hold on
    plot(real(w_from_jlab(curr_level,:)))
end

