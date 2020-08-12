clc,clear,close all;
set(0,'DefaultFigureWindowStyle','docked'); 
[audioIn,fs] = audioread('corrupt.wav');
load('frequencyRange');
load('df');
signal = medfilt1(audioIn);
N = length(signal);
win=kaiser(513,10);
figure,plot(win);
title('Kaiser Window');
ylabel('Magnitude');
xlabel('Sample');
axis([0 500 0 1.1]);
b=fir1(512,[730/fs*2,770/fs*2],'stop',win);
filteredSignal=filtfilt(b,1,signal); % x is input signal which length is 10000
kaiserWindowed = filteredSignal;

%sound(filteredSignal);