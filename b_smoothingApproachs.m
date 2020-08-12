clear,clc,close all;
set(0,'DefaultFigureWindowStyle','docked'); 
filename = 'corrupt.wav'
[audio_in,fs] = audioread(filename);
load('kaiserWindowed');
signal = medfilt1(audio_in);
N = length(signal);
df = fs / N ;
frequency = -fs/2:df:fs/2-df;
SIGNAL = fftshift(fft(signal))/length(fft(signal));
figure('name','Signal and Signal FFT');

fcutlow = 720;
fcuthigh = 770;
[b,a] = butter(3,[fcutlow,fcuthigh]/(fs/2),'stop');
butter_filtered_signal = filter(b,a,signal);
%after FIR filter
butter_filtered_signal = kaiserWindowed;

%wavelet_denoising_signal

wavelet_denoising_signal = wden(butter_filtered_signal,'rigrsure','s','sln',8,'sym6');

%moving_average_filtered_signal

B = 1/10*ones(10,1);

moving_average_filtered_signal = filter(B,1,butter_filtered_signal);

%Savitzky-Golay Filtering 

order = 3;
framelen = 27;
sgf_signal = sgolayfilt(butter_filtered_signal,order,framelen); %Savitzky-Golay Filtering 
%Butter-Filtered-Signal Graph
subplot(1,5,1)
plot(butter_filtered_signal);
title('Band-Pass Filtered Signal');
xlabel('Sample');
ylabel('Amplitude');
xlim([10 70])

%Wavelet_denoising_signal Graph
subplot(1,5,2)
plot(wavelet_denoising_signal)
xlim([10 70])
title('Wavelet Denoising');
xlabel('Sample');
ylabel('Amplitude');
%sound(wavelet_denoising_signal);
%Moving_average_filtered_signal Graph
subplot(1,5,3)
plot(moving_average_filtered_signal)
xlim([10 70])
title('Moving Average Filtered');
xlabel('Sample');
ylabel('Amplitude');
%sound(moving_average_filtered_signal)

%Savitzky-Golay Filtering Graph
subplot(1,5,4)
plot(sgf_signal)
xlim([10 70])
title('Savitzky-Golay Filtering');
xlabel('Sample');
ylabel('Amplitude');
%sound(sgf_signal);

%Clean-Signal
subplot(1,5,5)
[cleanSignal,fs_clean] = audioread('clean.wav');
plot(cleanSignal)
xlim([10 70])
ylim([-0.02 0.09])
title('Clean Signal');
xlabel('Sample');
ylabel('Amplitude');

%%
%Comparing 3 Wavelet Approach with RMS Approach
movingComparisonMatrix = cleanSignal - moving_average_filtered_signal;
sagoyComparisonMatrix = cleanSignal - sgf_signal;
waveletDenosingCompMatrix = cleanSignal - wavelet_denoising_signal;

movingRmsValue = sqrt(mean((movingComparisonMatrix.^2)));
sagoyRmsValue = sqrt(mean((sagoyComparisonMatrix.^2)));
waveletRmsValue = sqrt(mean((waveletDenosingCompMatrix.^2)));
disp('NON EFFECTIVE COMPARISON WAY FOR WAVELETS');
disp(movingRmsValue);
disp(sagoyRmsValue);
disp(waveletRmsValue);

%It is obvious that rms comparison is not effective due to these filters apply
%different DB range.