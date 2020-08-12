clear,clc,close all
set(0,'DefaultFigureWindowStyle','docked'); 
filename = 'corrupt.wav';
load('kaiserWindowed');
[audio_in,fs] = audioread(filename);
signal = medfilt1(audio_in);
N = length(signal);
df = fs / N ;
frequency = -fs/2:df:fs/2-df;
SIGNAL = fftshift(fft(signal))/length(fft(signal));

KAISER = fft(kaiserWindowed);

subplot(2,1,1)
plot(abs(KAISER(:,1)));
title('Noisy Signal Spectra')
cursor = 75;
threshhold = 35;

for i = 1:cursor:length(KAISER)-cursor
    if abs(KAISER(i)) < threshhold && abs(KAISER(i+cursor)) < threshhold
        KAISER(i:1:i+cursor) = 0;
    end
    
end

subplot(2,1,2)
plot(abs(KAISER(:,1)));
title('Filtered Signal')
ylabel('Magnitude')
xlabel('Frequnecy')

filteredSignal = real(ifft(KAISER));
%sound(filteredSignal);
