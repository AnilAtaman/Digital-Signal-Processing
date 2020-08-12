%WIENER FILTER DESIGN
set(0,'DefaultFigureWindowStyle','docked'); 
clc,clear,close all
filename = 'corrupt.wav';
[audioIn,fs] = audioread(filename);
signal = medfilt1(audioIn);
df = fs / length(signal);
frequencyRange = -fs/2:df:fs/2-df;

load('kaiserWindowed'); % Removed from noise at around 750 Hz
N = length(signal); 

%Estimating the noise magnitude spectra
signalVar = var(abs(fft(kaiserWindowed)));
signalMean = mean(abs(fft(kaiserWindowed)));
estimatedNoise = signalMean*randn(N,1)/signalVar*9

%Plotting FFT OF OUR SIGNAL and Estimated Noise;
figure,
plot(frequencyRange,abs(fftshift(fft(kaiserWindowed))));
hold on,
plot(frequencyRange,abs(fftshift(fft(estimatedNoise))));
title('EstimatedNoise and Signal at Frequency Domain');
xlabel('Frequency','fontsize',20);
ylabel('Magnitude','fontsize',20);


%Generate and View Power Spectra
sigPower = abs(fftshift(fft(kaiserWindowed))).^2;          
noisePower = abs(fftshift(fft(estimatedNoise))).^2;

figure(2);
hold on;
fPlot = [-N/2:N/2-1];
plot(fPlot, sigPower, 'k');
plot(fPlot, noisePower, 'xr');
axis([-N/2 N/2-1  1.1*min(sigPower) 1.1*max(sigPower)]);
title('Power spectra of signal and noise');
xlabel('Frequency', 'fontsize', 20);
ylabel('Power', 'fontsize', 20);
legend('Signal', 'Noise');
grid on;

%Filter Magnitude Response
filter =  sigPower./(sigPower + noisePower);
figure(3);
stem(fPlot, filter, 'b');
axis([-N/2 N/2-1  0 1.1]);
title('Filter magnitude response');
xlabel('Frequency', 'fontsize', 20);
ylabel('Filter Gain', 'fontsize', 20);
grid on;

WIENERFILTEREDSIGNAL = filter .* fftshift(fft(kaiserWindowed)); 
wienerFilteredSignal = ifft(ifftshift(WIENERFILTEREDSIGNAL));

%sound(wienerFilteredSignal);