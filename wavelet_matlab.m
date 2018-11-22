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
[wt,f,coi,fb] = cwt(x,'amor',fs,'VoicesPerOctave',4,'FrequencyLimits',[2^(-.5) 64]);
xrec=icwt(wt,'amor',f,[0.8 64]);

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
    title(['level: ' num2str(curr_level) ' f: ' num2str(f(curr_level))])
end
linkaxes(h_s,'xy')

%% plot 
figure
for curr_level=1:size(wt,1)
    raw=ceil(sqrt(size(wt,1)));
    col=ceil(number_of_scales/raw);
    h_fft(curr_level)=subplot(raw,col,curr_level);
    %     plot(hz,2*abs(fft(wt(curr_level,:)/length(wt(curr_level,:)))))
    x=real(wt(curr_level,:))';
    yf=abs(fft(x(:,1)));
    yf=yf(1:end/2);
    xf =linspace(0,fs/2,numel(yf));
    plot(xf,yf)
    title(['level: ' num2str(curr_level) ' f: ' num2str(f(curr_level))])
end
linkaxes(h_fft,'xy')