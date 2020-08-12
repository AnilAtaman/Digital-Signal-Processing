%Band Stop Elliptic-Filter Design
clear,clc,close all;
filename = 'corrupt.wav';
[audioIn,fs] = audioread('corrupt.wav');
signal = medfilt1(audioIn); %to reduce spikes
df = fs/length(signal); %frequency increment steps
frequencyRange = -fs/2:df:fs/2-df; 
w1 = 730/fs*2;
w2 = 770/fs*2;
[b,a] = ellip(2,5,50,[w1 w2],'stop');
%[b,a] = ellip(4,5,50,[w1 w2],'stop'); %Phase and Magnitude Distortation
%can be observerd
ellipticFilteredSignal = filter(b,a,signal);
%sound(ellipticFilteredSignal);
fvtool(b,a);