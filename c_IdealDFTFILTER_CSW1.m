

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
FILTEREDSIGNAL = SIGNAL .* windowMatrix;
filteredSignal = ifft(FILTEREDSIGNAL);
subplot(211)
plot(frequencyRange,windowMatrix,'r','Linewidth',2);
hold on;
plot(frequencyRange,abs(SIGNAL)/max(abs(SIGNAL)),'b');
title('Window and Normalized Noisy Signal')
xlabel('Frequency');
ylabel('Magnitude');
legend('Window','Normalized Noisy Signal');
subplot(212)
plot(frequencyRange,fftshift(abs(FILTEREDSIGNAL)));
title('Ideal DFT Filtered Signal (Window Method)');
ylabel('Magnitude');
xlabel('Frequency');
%sound(filteredSignal)
noisySignal = filteredSignal


