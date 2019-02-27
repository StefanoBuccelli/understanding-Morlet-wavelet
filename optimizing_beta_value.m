clear
close all
clc
%%% validating the wavelet calculated with the Morse family
% Hipp defines a wavelet with a defined numer of cycles of 5.83,
% freq / sigma_f = 5.83, for all frequencies in base 2
% 2.^(-0.5:1/4:6)

% load some eeg data
load sources_eeg.mat
eegdata = source.pca_projection * source.imagingkernel * source.sensor_data;

% select a source after reconstruction
signal = eegdata(1999,:);
fs =  1/(source.time(2)-source.time(1));
t = source.time;

% 
new_fs = 128; % redefinition of the abova variables
signal = resample(signal',new_fs,fs)';
time=resample(source.time',new_fs,fs)';
fs = new_fs;


% first step generate the Morlet as defined by Hipp
% hipp Morlet wavelet
count_freq = 0;
numcycles = 5.83;
time = -source.time(ceil(end/2)):1/fs:source.time(ceil(end/2));
freq = 2.^(-0.5:0.25:6);

GAMMA=3; %fixed, it guarantees symmetry that is needed to obtain Morlet from Morse family
beta_val = 1:1:120;%[11.2439 411.2440 11.2441 11.2442 11.2443]%:0.01:11.3;%[11.2430 11.2440];
%figure(11)
for f = (freq)
    count_freq = count_freq + 1;
    %freq1 = f; % of the wavelet
    % create the sine wave and Gaussian window, normalized as Tannon
    % explains to gave unitary energy (A)
    sigma_t = numcycles/(2*pi*f);
    A = (sigma_t*sqrt(pi)).^(-0.5);
    sinwave1 = exp(2*1i*pi*f*time);
    gauswin1 = A.*exp(-time.^2./(2*sigma_t.^2));
    hipp(:,count_freq) = gauswin1 .* sinwave1;
    
    % below there are the Morse wavelet for different values of beta
    for beta = 1:length(beta_val)
        psi(:,count_freq,beta) = morsewave(length(signal),1,GAMMA,beta_val(beta),f.*(2*pi./fs),'energy'); % obtaining morlet usign lilly toolbox
    end
end

% check for frequency content of hipp wavelet and estimates the time domain
% standard deviation that must be equal to
% sigma_t = number of cycles * 2 * pi * f, where number of cyles is 5.83
count_freq = 0;
for f  =1:length(freq)
    count_freq = count_freq +1 ;
    
    xf = linspace(0,fs/2,floor(length(time)/2)+1);
    yf = abs(fft((hipp(:,f)))/length(time)).^2;
    yf = yf ./ max(yf); % normalize the spectrum
    % peak and peak index of the wavelet, the value in Hz has to match the
    % freqeuncy f of the wavelet
    [valmax,indmax] = max(yf);

    if xf(indmax)-freq(f) > 10^(-2) % check is the difference is almost zero, there are approximations and error hence i set the threshold to 0.01
        disp('problem')
    end
    
    % fitting envelope of spectrum of wavelet using a gaussian and estimate
    % of the SD
    fitting = fit(xf',(yf(1:length(xf))),'gauss1');
    values = coeffvalues(fitting);
    stand_dev(f) = values(3); % the third is the standard deviation
    cycle_original_hipp(f) = (freq(f)./(stand_dev(f)));
    % check if the value is equal to the number of cyles 5.83
    disp(['estimated number of cycles : ' num2str(freq(f)./(stand_dev(f)))])
    
    clear xf yf
end

%check the frequency content of Morse generalized wavelet
for beta = 1:length(beta_val)%1:size(psi,3)
    for f  =1:length(freq)
        xf = linspace(0,fs/2,floor(length(time)/2)+1);
        yf = abs(fft((squeeze(psi(:,f,beta))))/length(time)).^2;
        yf = yf ./ max(yf);
        [valmax,indmax] = max(yf);
        %plot(xf, yf)
        if xf(indmax)-freq(f) > 10^(-2) % check is the difference is almost zero, there are approximations and error hence i set the threshold to 0.01
            disp('problem')
        end

        fitting = fit(xf',(yf(1:length(xf))),'gauss1');
        values = coeffvalues(fitting);
        stand_dev(f) = values(3); % in three you have the standard deviation
        
        % this is are varying number of cycles in relation to beta choice
        
        cycles_estimated(beta,f) = freq(f)./(stand_dev(f));
        disp(['beta value:' , num2str(beta_val(beta)) ,'  estimated number of cycles : ' num2str(freq(f)./(stand_dev(f)))])

        clear xf yf
    end
end

%plot(mean(cycle_original_hipp) - mean(cycles_estimated,2))
plot(beta_val ,mean(cycle_original_hipp) - mean(cycles_estimated,2),'o')
xlabel('beta')
ylabel('mean difference across frequencies original hipp - estimated cycles')
set(gca,'XTicklabel',num2str(get(gca,'XTick')','%3f'))
set(gcf,'Color','w'); box off

for i = 1:size(psi,3)
    for ff = 1:27
        mat(ff,i)=corr( real(hipp(:,ff)) , real(squeeze(psi(:,ff,i))));
        %corr( real(hipp(:,ff)) , real(squeeze(psi(:,ff,i))))
    end
end

figure
imagesc(mat);colorbar
grid on
xlabel('beta')
ylabel('frequencies')
title('Pearson correlation between the two wavelets estimate')
set(gca,'XTick',[1:2:120],'fontweight','bold','fontsize',11)%,'YTick',1:27,'YTickLabel',num2str(freq))

figure
imagesc(cycles_estimated');colorbar
grid on
xlabel('beta')
ylabel('frequencies')
title('# of cycles for the Morse wavelet family, \beta = 12.2:0.001:11.3')
set(gca,'XTick',[1:2:120],'fontweight','bold','fontsize',11)%,'YTick',1:27,'YTickLabel',num2str(freq))

figure
contourf(1:length(beta_val),1:27,mat)

figure
plot(mean(mat))
findpeaks(mean(mat),'minpeakheight',0.9)
[valmax, indmax] = findpeaks(mean(mat),'minpeakheight',0.9);
set(gca,'XTick',[1:2:120],'fontweight','bold','fontsize',11)%,'YTick',1:27,'YTickLabel',num2str(freq))
title('mean Pearson values between Hipp Morlet and Morse across the carrier freqeuncy')
std(mat); set(gcf,'Color','w')

disp(['the best beta value is:  ',num2str(indmax)])