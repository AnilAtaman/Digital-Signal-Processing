clc,clear,close all
filename = 'corrupt.wav';
%Design the Butterworth Filter(Band Reject)
[audioIn,fs] = audioread(filename);
signal = medfilt1(audioIn);
df = fs / length(signal);
frequencyRange = -fs/2:df:fs/2-df;
bandFs1 = 730;
bandFs2 = 770;
w1 = bandFs1/fs*2; %Normalized frequency fl
w2 = bandFs2/fs*2; %Normalized frequency fh
[b,a] = butter(6,[w1 w2],'stop'); %Stable 6th order Butterworth Filter
%[b,a] = butter(8,[w1 w2],'stop'); %Unstable 8th order Butterworth Filter
butterFilteredSignal = filter(b,a,signal);
BUTTER_FILTERED_SIGNAL = fftshift(fft(butterFilteredSignal));
freqz(b,a) % The frequency plot
%title('Designed Butterworth Filter Frequency and Phase Respond 8th Order- Unstable');
title('Designed Butterworth Filter Frequency and Phase Respond 6th Order Stable');
figure,zplane(b,a) % display the pole-zero plot of the filter
%title('Filter in the Z-Plane 8th Order');
title('Filter in the Z- Plane 6th Order');
figure,plot(frequencyRange,abs(BUTTER_FILTERED_SIGNAL));
%title('8th Butterworth Filtered(Band Stop 700-720) Signal Frequency Domain ');
title('6th Butterworth Filtered(Band Stop 700-720) Signal Frequency Domain ');
xlabel('Frequency', 'fontsize', 12);
ylabel('Magnitude', 'fontsize', 12); 
%sound(signal);
%sound(butterFilteredSignal);

