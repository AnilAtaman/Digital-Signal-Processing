
%NAME: ANIL ATAMAN
clc,clear,close all;
set(0,'DefaultFigureWindowStyle','docked');     % docks the windows neatly

%initialize known information and data file
size = 4096;
fs = 2048;
filename = 'dspCW2datav2.bin';
fileID = fopen(filename);
data = fread(fileID,'double');
figure,plot(data);
title('Raw Data')
xlabel('Sample');
ylabel('Magnitude');

%frequency and time compenents
df = fs/size;
frequencyRange = -fs/2:df:fs/2-df;
t = 0:1/fs:size/fs-1/fs;

%Median Filtering to reduce spike detected at first look
signal = medfilt1(data,3); % signal = median filtered signal, order = 3
figure,plot(signal)
title('Median Filtered Signal')
xlabel('Sample Numbers')
ylabel('Magnitude')

%FFT of the Median Filtered Signal
SIGNAL = fft(signal);
figure,stem(frequencyRange,fftshift(abs(SIGNAL)));
title('FFT of Median Filtered Signal')
xlabel('Frequency')
ylabel('Magnitude')

%Window, the reason for windowing remove the broadband noise. We know our
%carrier signal 50 Hz , and fm modulated and am modulated signals should be close
%that frequency and it should be simetric. Using that information, we can
%eliminate broandband noise, using windowing method.

mag = abs(SIGNAL);
filterWindow = zeros(1,size);
filterWindow(80+1:120+1)=1; 
filterWindow((size-120+1):(size-80+1)) = 1;

%plot window
figure
stem(mag/max(mag)/1.1);
hold on;
plot(filterWindow,'r','linewidth',1);
xlabel('Samples');
ylabel('Normalized Signal Magnitude');
legend('Normalized Signal Magnitude','Windowing');
title('Windowing');



%Applying Window Filter
WindowedSignal = SIGNAL .* filterWindow';
show = fftshift(abs(WindowedSignal));
figure,
stem(frequencyRange,show);
windowedSignal = ifft(WindowedSignal);
title('Signal After the Windowing')
xlabel('Frequency');
ylabel('Magnitude');


%Eliminating the Noise that is band-limited at the sample number 105 and 3990 ( non-simetric
%behaviour, so probably it is noise with high magnitude,Note:Normally we can use also 
%the method that average two near samples,however we know our both information has simetrical
%behaviour) ;

WindowedSignal(105+1) = 0;
WindowedSignal(size-105+1) = 0;
windowedFilteredSignal = ifft(WindowedSignal);
figure,
stem(frequencyRange,fftshift(abs(WindowedSignal)));
title('After Eliminated the Noise at the Sample Number 105 and 3990')
xlabel('Frequency')
ylabel('Magnitude')
xlim([-200 200])



%Hilbert Transform for detection of two modulated frequency

AmFmSignalHilbert = hilbert(windowedFilteredSignal);
magAM = abs(AmFmSignalHilbert); % To get AM signal
instfrq = fs/(2*pi)*diff(unwrap(angle(AmFmSignalHilbert))); %To get FM signal

figure,
plot(t(2:end),instfrq, 'linewidth', 5);
title('Instantaneous freuquency of Modulated Signal');
xlabel('Time');
ylabel('Instantaneous Frequency');

figure,plot(t,magAM,'r','linewidth',3);
hold on;
plot(t,windowedFilteredSignal,'b');
title('Instantaneous Amplitude(Envelope) of the Modulated Signal');
xlabel('Time');
ylabel('Instantenpus Amplitude');


%Detection of Frequencies 
fmFrequency = abs(fft(instfrq));
amFrequency = abs(fft(magAM));

fmFrequency(1) = 0; % Make it first sample 0 (DC value)
amFrequency(1) = 0; % Make it first sample 0 (DC value)

%Visulaze 
fmVisu = zeros(1,length(fmFrequency));
amVisu = zeros(1,length(amFrequency));
fmVisu(3+1:5+1) = 1;
amVisu(5+1:7+1) = 1;

%PLOTS FREQUENCIES

figure,
plot(fmVisu,'r','Linewidth',3);
hold on
stem(fmFrequency/max(fmFrequency)/1.1,'b'); %normalised
xlim([0 100])
legend('Fm Modulated Signal Frequency = 4 Hz') % 5-1(DC) = 4Hz;
xlabel('Sample Number');
ylabel('Normalised Magnitude/1.1');
title('FM Modulated Signal Frequency (4Hz)')

figure,
plot(amVisu,'r','Linewidth',3);
hold on
stem(amFrequency/max(amFrequency)/1.1,'b'); %normalised
legend('Am Modulated Signal Frequency = 6 Hz') % 7-1(DC) = 6Hz;
xlim([0 100])
xlabel('Sample Number');
ylabel('Normalised Magnitude/1.1');
title('AM Modulated Signal Frequency (6Hz)');


