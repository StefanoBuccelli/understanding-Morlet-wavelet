%% Warning: cwt changed from R.2018, this script only works from R.2018a

%%
clear
clc
close all

%% create a simple sine wave 20Hz
fs=250;
dt=1/fs;
StopTime=5;
t=(0:dt:StopTime-dt)';
Fc=20;
x=cos(2*pi*Fc*t)';

%% perform Analytic Morlet Wavelet with different parameters
[wt,f,coi,fb] = cwt(x,'amor',fs,'VoicesPerOctave',4,'FrequencyLimits',[2^(-.5) 64]); % 'FrequencyLimits',[2^(-.5) 64] works only from R.2018
xrec=icwt(wt,'amor',f,[0.8 64]);

%% check fiter bank used
freqz(fb)
title('Frequency Responses Morlet Wavelet')

[psi, t] = wavelets(fb); % wavelets used by cwt
% load('/Users/stefanobuccelli/Desktop/cmw_tot.mat')
% cmw_tot=flipud(cmw_tot); % flip in order to match the order of f from cwt
%% plot wavelets
number_of_scales=length(f);
figure

for curr_level=1:number_of_scales
    raw=ceil(sqrt(size(wt,1)));
    col=ceil(number_of_scales/raw);
    h_s(curr_level)=subplot(raw,col,curr_level);
    plot(t,real(psi(curr_level,:)))
%     % only if you have cmw_tot as obtained by wavelet_RI_hipp
%     hold on
%     plot(-5:1/fs:5,cmw_tot(curr_level,:))
    title(['level: ' num2str(curr_level) ' f: ' num2str(f(curr_level)) ' Hz'])
end
linkaxes(h_s,'x')

%% comparing the original and the reconstructed signals
figure
subplot(311)
plot(t,x)
hold on
plot(t,xrec) 
legend({'original','reconstructed'})
title('comparing the original and the reconstructed signals')

subplot(312)
ratio=x./xrec;
plot(t,ratio)
title(['ratio orignal/reconstructed, mean: ' num2str(mean(ratio)) ', std: ' num2str(std(ratio))])

subplot(313)
difference=x-xrec;
plot(t,difference)
title(['difference orignal-reconstructed, mean: ' num2str(mean(difference)) ', std: ' num2str(std(difference))])
xlabel('Time [s]')

%% plot signal @ different scales
number_of_scales=length(f);
figure
for curr_level=1:number_of_scales
    raw=ceil(sqrt(size(wt,1)));
    col=ceil(number_of_scales/raw);
    h_s(curr_level)=subplot(raw,col,curr_level);
    plot(real(wt(curr_level,:)))
    title(['level: ' num2str(curr_level) ' f: ' num2str(f(curr_level)) ' Hz'])
end
linkaxes(h_s,'xy')

%% plot One side PSD
figure
for curr_level=1:size(wt,1)
    raw=ceil(sqrt(size(wt,1)));
    col=ceil(number_of_scales/raw);
    h_fft(curr_level)=subplot(raw,col,curr_level);
    %     plot(hz,2*abs(fft(wt(curr_level,:)/length(wt(curr_level,:)))))
    x=real(wt(curr_level,:))';
    L=length(x);
    NFFT=1024;
    X=fft(x,NFFT);
    Px=X.*conj(X)/(NFFT*L); %Power of each freq components
    fVals=fs*(0:NFFT/2-1)/NFFT;
    plot(fVals,Px(1:NFFT/2),'b','LineSmoothing','on','LineWidth',1);
    xlabel('Frequency (Hz)')
    ylabel('PSD');
    title(['level: ' num2str(curr_level) ' f: ' num2str(f(curr_level)) ' Hz'])
end
linkaxes(h_fft,'xy')