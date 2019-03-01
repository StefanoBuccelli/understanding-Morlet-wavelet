%% goal is to understand the constant relative bandwidth and the importance of number of cycles in wavelet definitions
figure

omega_0=2.^(-0.5:0.25:6);
N_cycles=1:10;
for curr_n=1:length(N_cycles)
    delta_omega=omega_0./N_cycles(curr_n);
    h(curr_n)=subplot(2,5,curr_n);
    for curr_freq=1:length(omega_0)
        curr_f=omega_0(curr_freq);
        sigma_t=N_cycles(curr_n)/(2*pi*curr_f);
        start_f=curr_f-delta_omega(curr_freq)/2;
        stop_f=curr_f+delta_omega(curr_freq)/2;
        start_t=-3*sigma_t;
        stop_t=3*sigma_t;
        plot([start_f stop_f],[0 0]+curr_freq)
        hold on
        plot([curr_f curr_f],[start_t stop_t]+curr_freq)
        
        t_range=linspace(start_t,stop_t,100);
%         cosine_t_range=cos(2*pi*curr_f*t_range);
        cosine_t_range=exp(2*1i*pi*curr_f*t_range);
        %         sinwave1 = esinwave1 = exp(2*1i*pi*freq1*time);
        A = (sigma_t*sqrt(pi)).^(-0.5);
        %
        gauswin1 = A.*exp( -t_range.^2 / (2* (N_cycles(curr_n)/(2*pi*curr_f))^2 ) );
%         plot(sine_t_range+curr_f,t_range+curr_freq)
        plot(gauswin1.*(real(cosine_t_range))+curr_f,t_range+curr_freq)
    end
    xlabel('freq [Hz]')
    ylabel('time')
    title(['N cycles: ' num2str(curr_n)])
end
linkaxes(h,'xy')