%Notch-Filter Design
clear,clc,close all;
filename = 'corrupt.wav';
[audioIn,fs] = audioread('corrupt.wav');
signal = medfilt1(audioIn); %to reduce spikes
df = fs/length(signal); %frequency increment steps
frequencyRange = -fs/2:df:fs/2-df; 
F0 = 750;   % interference is at 750 Hz  % sampling frequency is 8000 Hz
notchspec = fdesign.notch('N,F0,Q',2,F0,20,fs); % Quality Factor( how underdamped an oscillator or resonator is)
%(Q) = 20  Filter Order(N) = 2;
notchfilt = design(notchspec,'SystemObject',true);
fvtool(notchfilt,'Color','white');
notchFilteredSignal = notchfilt(signal);
NOTCH_FILTERED_SIGNAL = fftshift(fft(notchFilteredSignal)); %FFT of Notch-Filtered Signal
plot(frequencyRange,abs(NOTCH_FILTERED_SIGNAL))
title('Notch Filtered Signal Frequency Domain')
xlabel('Frequency', 'fontsize', 12);
ylabel('Magnitude', 'fontsize', 12); 
%sound(notchFilteredSignal);