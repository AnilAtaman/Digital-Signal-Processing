% Band-Stop Chebyshev Filter Design
clc,clear,close all,
filename = 'corrupt.wav';
[audioIn,fs] = audioread(filename);
signal = medfilt1(audioIn);
df = fs / length(signal);
bandFs1 = 730;
bandFs2 = 770;
w1 = bandFs1/fs*2; %bandpass fl
w2 = bandFs2/fs*2; %bandpass fh
frequencyRange = -fs/2:df:fs/2-df;
[b,a] = cheby1(2,5,[w1 w2],'stop'); % filter design order = 2, decibels of peak-to-peak ripple = 5
%[b,a] = cheby1(5,5,[w1 w2],'stop') %Phase Distortion
chebyFilteredSignal = filter(b,a,signal);%applying the filter
%sound(chebyFilteredSignal);
fvtool(b,a)