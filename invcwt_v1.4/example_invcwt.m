%build synthetic since wave
dt = 0.01;
t = 0:dt:20; 
N = length(t);
omega = 2;
x = cos(omega*t);

%CWT options
pad = 0;
dj = 0.25; %smaller number gives better resolution, default = 0.25;
so = dt; %default
Jfac = 1; %Sets the maximum scale to compute at (therefore number of scales). 1 is equiv to default. 
j1 =  round(Jfac*(log2(N*dt/so))/dj); %default: (log2(N*dt/so))/dj
mother = 'MORLET';
param = 6; %wave number for morlet, see >> help wave_bases for more details




%compute the CWT 
[wave, period, scale, coi, dj, paramout, k] = contwt(x,dt, pad, dj, so, j1, mother, param);
% contwt(Y,DT,PAD,DJ,S0,J1,MOTHER,PARAM)

%reconstruct the original signal 
Xrec = invcwt(wave, mother, scale, paramout, k);
dE = sum(abs(x - Xrec))/length(x); %compute point wise mean error

%%Plot results 
figure(1); 
subplot(  1, 2, 1)
plot(t,x); %original signal 
hold on; 
plot(t, Xrec, 'r--') 
legend('Original signal', 'Reconstructed Signal', 'location', 'best') 
xlabel('Time (s)'); 
ylabel('Signal (arbitrary units)')
title(sprintf('wo = %g, k0 = %d, dE = %3.3f', omega, param, dE))
ylim([-1.5 1.5]);
set(findall(gcf,'-property','FontSize'),'FontSize',16)
hold off;

%plot wavelet coeffs 
% figure;
subplot( 1, 2,2)
imagesc(abs(wave)) 
xlabel('Time (integer index)') 
ylabel('Scale')
title(sprintf('wo = %g, k0 = %d', omega, param))
set(findall(gcf,'-property','FontSize'),'FontSize',16)
hold off


