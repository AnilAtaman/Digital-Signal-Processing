%BASIC DFT APPROACH WITHOUT BANDSTOP FILTER
%The First Part of the this code is not effective filter due to SNR ratio
%Non bandstopfiltered signal has the noise that dominates power spectrum
%%
set(0,'DefaultFigureWindowStyle','docked'); 
clear,clc,close all;
filename = 'corrupt.wav';
[audioIn,fs] = audioread('corrupt.wav');
signal = medfilt1(audioIn);
df = fs/length(signal);
frequencyRange = -fs/2:df:fs/2-df;
SIGNAL = fftshift(fft(signal)); % FFT of Signal
subplot(311)
plot(frequencyRange,abs(SIGNAL)/max(abs(SIGNAL)));
title('Noisy-Signal Frequency Domain','fontsize', 14);
xlabel('Frequency', 'fontsize', 12);
ylabel('Magnitude', 'fontsize', 12); 
grid on;
PSD_SIGNAL = SIGNAL .* conj(SIGNAL);%Calculation of Power
subplot(312)
plot(frequencyRange,PSD_SIGNAL/max(PSD_SIGNAL),'b');
xlabel('Frequency', 'fontsize', 12);
ylabel('Power', 'fontsize', 12);
hold on;
grid on;
zeroMatrix = PSD_SIGNAL > mean(PSD_SIGNAL)/2; % Set the threshold
PSD_ZERO = PSD_SIGNAL .* zeroMatrix;
plot(frequencyRange,PSD_ZERO/max(PSD_ZERO),'r');
title('Filtered and Non-Filtered Signal Power Spectrum','fontsize', 14);
xlabel('Frequency', 'fontsize', 12);
ylabel('Power', 'fontsize', 12);
hold on;
legend('Original','Filtered');
%to look spesific interval
subplot(313);
plot(frequencyRange,PSD_SIGNAL/max(PSD_SIGNAL),'b');
axis([0 300 0 0.01])
xlabel('Frequency', 'fontsize', 12);
ylabel('Power', 'fontsize', 12);
hold on;
grid on;
zeroMatrix = PSD_SIGNAL > mean(PSD_SIGNAL)/2;
PSD_ZERO = PSD_SIGNAL .* zeroMatrix;
plot(frequencyRange,PSD_ZERO/max(PSD_ZERO),'r');
axis([0 300 0 0.0010])
title('Filtered and Non-Filtered Signal Power Spectrum(0-300)','fontsize', 14);
xlabel('Frequency', 'fontsize', 12);
ylabel('Power', 'fontsize', 12);
hold on;
legend('Original','Filtered');
FILTERED_SIGNAL = SIGNAL .* zeroMatrix; % Multiply Zero Matrix to apply filter
filteredSignal  = ifft(FILTERED_SIGNAL);
%sound(filteredSignal) 
%%
%BANDSTOPFILTERED SIGNAL BASIC APPROACH
load('kaiserWindowed');
BAND_STOP_FILTERED_SIGNAL = fft(kaiserWindowed);
%Calculation of Power
PSD_BAND_FILTERED = BAND_STOP_FILTERED_SIGNAL .* conj(BAND_STOP_FILTERED_SIGNAL); 
figure(2);
subplot(311)
graph1 = pwelch(PSD_BAND_FILTERED);
pwelch(graph1)
title('Noisy-Signal Power Spectrum','fontsize', 14);
%Compare with the mean to set threshold
zeroMatrixBandStop = PSD_BAND_FILTERED > mean(PSD_BAND_FILTERED);
PSD_BAND_FILTERED_ZERO = PSD_BAND_FILTERED .* zeroMatrixBandStop;
subplot(312)
graph2 = pwelch(PSD_BAND_FILTERED_ZERO);
pwelch(graph2)
title('Filtered Signal Power Spectrum','fontsize', 14);

%to look spesific interval to see filter effect on the power spec
subplot(313);
plot(frequencyRange,PSD_BAND_FILTERED/max(PSD_BAND_FILTERED),'b');
axis([0 300 0 0.01])
xlabel('Frequency', 'fontsize', 12);
ylabel('Power', 'fontsize', 12);
hold on;
plot(frequencyRange,PSD_BAND_FILTERED_ZERO/max(PSD_BAND_FILTERED_ZERO),'r');
axis([0 2000 0 0.01])
title('Filtered and Non-Filtered Signal Power Spectrum(0-2000)','fontsize', 14);
xlabel('Frequency', 'fontsize', 12);
ylabel('Power', 'fontsize', 12);
hold on;
grid on;
legend('Original','Filtered');
%TO APPLY FILTER TO SIGNAL
BAND_STOP_FILTERED_SIGNAL = BAND_STOP_FILTERED_SIGNAL .*zeroMatrixBandStop;
filteredSignalwithBand = ifft(BAND_STOP_FILTERED_SIGNAL);
%Filtered Signal
%sound(filteredSignalwithBand);
%Noisy Signal
%sound(kaiserWindowed);

