
%% From: Computational implementation of the inverse continuous wavelet transform without a requirement of the admissibility conditionclear
clc

% Determination of the function
N=512;
t=linspace(0,1,N);
f1=cos(20*pi*t);
f2=exp(-4*t);
f3=sin(40*pi*t).*ramp(t,N);
f=f1.*f2+f3;
% Boundary continuation (extension)
[te,fe]=fcontin(t,f);
%Tranform to analytical function
fa=sAnalytic(fe);

%% figure 1
figure
subplot(211)
plot(t,f)
ylim([-2 2])
subplot(212)
% Fig. 1(lower panel) presents abs(w) is obtained as
omega0=2*pi;
a=linspace(0,0.2,51);
we=fftMorlet(te,fa,a,omega0);

ti=te(0.5*N+1:1.5*N);
w=we(:,0.5*N+1:1.5*N);
imagesc(abs(w))
set(gca,'YTick',1:length(a),'YTickLabel',a);
set(gca,'Ydir','normal')

%% figure 2
iw=invMorlet(t,a,w);
figure
plot(t,iw)
hold on
plot(t,f)


function x = ramp(t,N)
    x=zeros(size(t));
    x(round(N/3):round(2*N/3))=1;
end
function [tp,fp]=fcontin(t,f)
n=length(t);tv(:,1)=t;fv(:,1)=f;
%Interpolation into power-two sequences:
N=2^(ceil(log2(n)));
ti(:,1)=linspace(tv(1),tv(end),N);
fi=interp1q(tv,fv,ti);
%Boundary continuation
N=2^(ceil(log2(n)));
dt=ti(2)-ti(1);
tp=zeros(2*N,1);
tp(1:N/2)=linspace(ti(1)-N*dt/2,-dt,N/2);
tp(N/2+1:1.5*N)=ti;
tp(1.5*N+1:2*N)=linspace(ti(end)+dt,ti(end)+N*dt/2,N/2);
fi=interp1q(tv,fv,ti);
% Boundary reflection
fp(1:N/2)=flipud(conj(fi(2:N/2+1)));
fp(N/2+1:1.5*N)=fi;
fp(1.5*N+1:2*N)=flipud(conj(fi(N/2:N-1)));
end

function fa=sAnalytic(f)
N=length(f);
%Cut-off of negative frequencies
F=fft(f);
F=[2*F(1:N/2),zeros(1,N/2)];
%Output: the analytic signal
fa=ifft(F);
end

function w=fftMorlet(t,fp,a,omega0)
N=length(t);
%Fourier transform
F=fft(fp);
nrm=2*pi/(t(end)-t(1));
omega_=([(0:(N/2)) (((-N/2)+1):-1)])*nrm;
%Convolution
if a(1)==0
    w(1,:)=fp*exp(-omega0^2/2);
    k1=2;
else
    k1=1;
end
for k=k1:length(a)
    omega_s=a(k)*omega_;
    window=exp(-(omega_s-omega0).^2/2);
    cnv(k,:)=window.*F;
    w(k,:)=ifft(cnv(k,:));
end
end

function iw=invMorlet(t,a,w)
N=length(t);
d2t=t(3)-t(1);
dw(:,2:N-1)=(w(:,3:end)-w(:,1:end-2))/d2t;
dw(:,1)=(w(:,2)-w(:,1))/(t(2)-t(1));
dw(:,N)=(w(:,N)-w(:,N-1))/(t(N)-t(N-1));
iw=imag(trapz(a,dw))/sqrt(2*pi);
end

