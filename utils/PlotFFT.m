function [] = PlotFFT(t,v,HighPassCutoff)
time = t;
if exist('HighPassCutoff','var')
    v = highpass(v,HighPassCutoff);
end
Vin = v;

%Matlab tutorial on 1D FFT 
%written by: Nadav Katz
%First Written: 12.6.2003
%Last updated: 18.10.2018 (by Baruch Katz)
%comment on fftshift/ifftshift: numerical FFT has the strange convention of
%assuming the time/frequency data are ordered in the following way: 
%0:dt:((N-1)*dt),-N*dt:dt:-dt, i.e. the array is broken in the middle and
%jumps from +large frequency to -large frequency and the small frequency
%componenets are assumed to be at the edges.
%In order to properly view and understand our signals, we need to shift
%the values so that the ordering is the standard
%(-N*dt):dt:..0..:dt:(N-1)*dt . This is done by the fftshift/ifftshift
%commands. We need to do the shift before applying the fft/ifft and then
%again afterwards.
%Note also - the code manages with odd and non-powers of 2 number of points
%as well.

%close all;
%clear all;

%define a time grid, with proper attention to FFT conventions for zero
%position
dt = t(5)-t(4);
N = length(time);



%1D FFT example

%odd/even disambiguation - different off-by-one treatment by numerical fft

% if mod(N,2)==0,
%     t=((-N/2):1:(N/2-1))*dt;
% else
%     t=((-(N-1)/2):1:((N-1)/2))*dt;
% end;

t = time - mean(time);

%% Gaussian
% t0=1
% sig_t=0.05; x=exp(-t.^2/(sig_t^2))+exp(-(t-t0).^2/(sig_t^2));

%% shifted gaussian
% sig_t=0.2; x=exp(-(t-1).^2/(2*sig_t^2));

%% rect
% width=0.2; x=abs(t)<width/2;

%% cosine
% freq=20;
%x=cos(2*pi*freq*t).*cos(2*pi*freq*t);

%% modulated Gaussian
% freq=20;
% x=exp(-t.^2/(2*0.1^2)).*cos(2*pi*freq*t);

%% beat signal
% freq1=20; freq2=25;
% x=(cos(2*pi*freq1*t)+sin(2*pi*freq2*t)).*exp(-t.^2/(2*1^2));

%%
x = Vin;
%x = VoltageV;

%note the fftshift - placing the zero of frequency in the middle for
%numerical FFT
%note normalization by factor dt - parsavel

u=fftshift(fft(ifftshift(x)))*dt;


%create frequency vector - with odd/even disambiguation similar to time
%vector
if mod(N,2)==0
    f=(-1:(2/N):(1-1/N))*1/(2*dt);
else
    f=((-(N-1)/2):1:((N-1)/2))/(N*dt);
end;
df=f(2)-f(1);

%inverse transform (note normalization by 1/dt - parsavel)



x2=fftshift(ifft(ifftshift(u)))/dt;
figure;
subplot(2,1,1);
plot(f(f>0),abs(u),'linewidth',3);legend('abs');
plotlog(f,abs(u),'linewidth',3);legend('abs');
xlabel('frequency (Hz)');
ylabel('amplitude (a.u.)');
title('Fourie Tranform');
subplot(2,1,2);
plot(t,x,'.b'); hold on; plot(t,real(x2),'g'); %note -assumes real signal
legend('original','F^{(-1)}F[original]');
xlabel('time (sec)');
ylabel('amplitude (a.u.)');
title ('original and FFT^-1(FFT(original))');
%parseval comparison
sum(abs(x).^2)*dt;
sum(abs(u).^2)*df;
A = max(abs(u));
freq = f;
abs_u = abs(u);
end