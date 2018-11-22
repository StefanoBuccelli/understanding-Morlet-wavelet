clear
clc
close all

fs=250;
dt=1/fs;
StopTime=5;
t=(0:dt:StopTime-dt)';
Fc=20;

x=cos(2*pi*Fc*t)';

[wt,f,coi,fb] = cwt(x,'amor',fs,'VoicesPerOctave',4);
% [wt,f,coi,fb] = cwt(x,'amor',fs); % ricostruzione perfeta quando gli dai 10 voci per ottava
[wt,f,coi,fb] = cwt(x,'amor',fs,'VoicesPerOctave',4,'FrequencyLimits',[2^(-.5) 64]);
xrec=icwt(wt,'amor',f,[0.8 64]);
%%
figure
plot(x)
hold on
plot(xrec) % il rapporto è *2.5
%%
figure
for curr_level=1:size(wt,1)
    raw=ceil(sqrt(size(wt,1)));
    h(curr_level)=subplot(raw,raw,curr_level);
    plot(real(wt(curr_level,:)))
end
linkaxes(h,'xy')
hz=linspace(0,250/2,floor(length(wt(curr_level,:)/2)));
figure
for curr_level=1:size(wt,1)
    raw=ceil(sqrt(size(wt,1)));
    h(curr_level)=subplot(raw,raw,curr_level);
    %     plot(hz,2*abs(fft(wt(curr_level,:)/length(wt(curr_level,:)))))
    x=real(wt(curr_level,:))';
    yf=abs(fft(x(:,1)));
    yf=yf(1:end/2);
    xf =linspace(0,fs/2,numel(yf));
    plot(xf,yf)
    %     [xf , yf] = fourier_RI(real(wt(curr_level,:)), fs)
    %     plot(hz,
end

% function [xf , yf] = fourier_RI(x, fs)
% 
% % fuorier tranform of the given signal
% 
% 
% yf=abs(fft(x(:,1)));
% 
% yf=yf(1:floor(end/2));
% 
% xf =linspace(0,fs/2,numel(yf));
% 
% %figure;plot(xf, yf)
% 
% %xlabel('frequency
% end
% linkaxes(h,'x')