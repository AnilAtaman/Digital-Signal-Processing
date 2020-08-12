clc,clear,close all;
set(0,'DefaultFigureWindowStyle','docked'); 
[audioIn,fs] = audioread('corrupt.wav');
load('frequencyRange');
load('df');
signal = medfilt1(audioIn);
N = length(signal);
SIGNAL = fft(signal);

%IDEAL DFT FILTER 
figure;
stem(abs(SIGNAL));
title('Noisy Signal FFT');
ylabel('Magnitude');
xlabel('Sample');
windowMatrix = ones(N,1);
windowMatrix(4669:4709) = 0;
windowMatrix(45293:45333) = 0;
BANDSTOPFILTEREDSIGNAL = SIGNAL .* windowMatrix;
filteredSignal = ifft(BANDSTOPFILTEREDSIGNAL);
subplot(511)
plot(frequencyRange,windowMatrix,'r','Linewidth',2);
hold on;
plot(frequencyRange,abs(SIGNAL)/max(abs(SIGNAL)),'b');
title('Window and Normalized Noisy Signal')
xlabel('Frequency');
ylabel('Magnitude');
legend('Window','Normalized Noisy Signal');
subplot(512)
plot(frequencyRange,fftshift(abs(BANDSTOPFILTEREDSIGNAL)));
title('Ideal DFT Filtered Signal (Window Method)');
ylabel('Magnitude');
xlabel('Frequency');

%WINDOWING (IT CAN BE OBSERVED AFTER THE SAMPLE NUMBER 14 SNR IS VERY HIGH
windowing14k = zeros(1,N);
windowing14k(1:14009) = 1;
windowing14k(35993:50000) = 1;
subplot(513)
plot(abs(BANDSTOPFILTEREDSIGNAL)/max(abs(BANDSTOPFILTEREDSIGNAL)));
hold on,
plot(windowing14k,'r','Linewidth',4);
title('Again Windowing the Signal Due to High SNR Ratio After 14000 Sample Number(After 2240 Hz)')
xlabel('Samples');
ylabel('Magnitude');
WINDOWEDSIGNAL = BANDSTOPFILTEREDSIGNAL .* windowing14k'; % it is kind of low pass filter
subplot(514)
plot(abs(WINDOWEDSIGNAL));
title('Windowed Signal');
xlabel('Samples');
ylabel('Magnitudes');

windowedSignal = ifft(WINDOWEDSIGNAL);

%%WIENER FILTER

%Estimating the noise magnitude spectra
signalVar = var(abs(fft(windowedSignal)));
signalMean = mean(abs(fft(windowedSignal)));
estimatedNoise = signalMean*randn(N,1)/signalVar*12;

%Generate the power spectra
sigPower = abs(fftshift(fft(windowedSignal))).^2;        
noisePower =abs(fftshift(fft(estimatedNoise))).^2;

filter =  sigPower./(sigPower + noisePower);

WIENERFILTEREDSIGNAL = filter .* fftshift(fft(windowedSignal)); 
wienerwindowFiltered = ifft(ifftshift(WIENERFILTEREDSIGNAL));

subplot(515)
plot(fftshift(abs(WIENERFILTEREDSIGNAL)));
title('Wiener Filtered Signal');
xlabel('Samples')
ylabel('Magnitudes')



%sound(wienerwindowFiltered)
