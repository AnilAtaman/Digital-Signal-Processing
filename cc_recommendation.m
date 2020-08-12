
%% The Recommended Filtering Methods
%Initilaze the Signal Information
clc,clear,close all;
[audioIn,fs] = audioread('corrupt.wav');
load('frequencyRange');
load('df');
% Improving the median filter
signal = medfilt1(audioIn,3);
N = length(signal);

%Kaiser Window
win=kaiser(513,10);
b=fir1(512,[730/fs*2,770/fs*2],'stop',win);
kaiserWindowed=filtfilt(b,1,signal);

%WIENER FILTER

%Estimating the noise magnitude spectra
signalVar = var(abs(fft(kaiserWindowed)));
signalMean = mean(abs(fft(kaiserWindowed)));
estimatedNoise = signalMean*randn(N,1)/signalVar*9;


%Generate and View Power Spectra
sigPower = abs(fftshift(fft(kaiserWindowed))).^2;          
noisePower = abs(fftshift(fft(estimatedNoise))).^2;


%Filter Magnitude Response
filter =  sigPower./(sigPower + noisePower);

WIENERFILTEREDSIGNAL = filter .* fftshift(fft(kaiserWindowed)); 
wienerFilteredSignal = ifft(ifftshift(WIENERFILTEREDSIGNAL));

%LOW PASS FILTERING
totallyFilteredSignal = lowpass(wienerFilteredSignal,2200,8000);

%{
%HIGH PASS FILTERING (NOISE CLOSE DC LEVEL)
totallyFilteredSignal__ = highpass(wienerFilteredSignal,80,8000);
there is no signifcant improvement in the signal
%}