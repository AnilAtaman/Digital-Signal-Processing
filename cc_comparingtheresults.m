clear,clc,close all
set(0,'DefaultFigureWindowStyle','docked'); 
%Compare the Signals
%I focused on comparing differentDFT,WienerFilter,NLMS and Savitz-Golay
%The reason is other techniques can be easily distinguished by hearing.

%%TIME DOMAIN
load('noisySignal');
load('cleanSignal');
load('differentDFT');
load('wienerFiltered');
load('sgfSignal');
load('wienerwindowFiltered');
load('nlmsSignal');
load('frequencyRange');



%sound(cleanSignal);
%sound(noisySignal);
%sound(filteredSignal); %differentDFT
%sound(wienerFilteredSignal);
%sound(sgf_signal);
%sound(nlmsSignal);
%sound(wienerwindowedFiltered);



fs = 8000;
t = 0:1/fs:length(cleanSignal)/fs-1/fs;
subplot(511)
plot(t,cleanSignal)
hold on;
plot(t,wienerFilteredSignal)
title('Clean and Wiener Filtered Signal');
xlabel('Time','fontsize',15);
ylabel('Magnitudes','fontsize',15);

subplot(512)
plot(t,cleanSignal)
hold on;
plot(t,nlmsSignal*10)
title('Clean and 10xNLMS Filtered Signal');
xlabel('Time','fontsize',15);
ylabel('Magnitudes','fontsize',15);

subplot(513)
plot(t,cleanSignal)
hold on;
plot(t,sgf_signal)
title('Clean and S-G Filtered Signal');
xlabel('Time','fontsize',15);
ylabel('Magnitudes','fontsize',15);

subplot(514)
plot(t,cleanSignal)
hold on;
plot(t,filteredSignal)
title('Clean and Moving DFT Filtered Signal');
xlabel('Time','fontsize',15);
ylabel('Magnitudes','fontsize',15);

subplot(515)
plot(t,cleanSignal)
hold on;
plot(t,wienerwindowFiltered)
title('Clean and Wiener with window');
xlabel('Time','fontsize',15);
ylabel('Magnitudes','fontsize',15);

%%POWER SPECTRA
figure,
subplot(321)
pwelch(cleanSignal)
title('Clean Signal')
subplot(322)
pwelch(wienerFilteredSignal)
title('Wiener Filtered Signal')
subplot(323)
pwelch(nlmsSignal)
title('NLMS Filtered Signal')

subplot(324)
pwelch(sgf_signal)
title('S-G Filtered Signal')

subplot(325)
pwelch(filteredSignal)
title('Moving DFT Filtered Signal')

subplot(326)
pwelch(wienerwindowFiltered)
title('Wiener with Window')

%FREQUENCY DOMAIN
figure,
subplot(321)
plot(frequencyRange,fftshift(abs(fft(cleanSignal))));
title('Clean Signal')
xlabel('Frequency')
ylabel('Magnitude')
subplot(322)
plot(frequencyRange,fftshift(abs(fft(wienerFilteredSignal))));
title('Wiener Filtered Signal')
xlabel('Frequency')
ylabel('Magnitude')
subplot(323)
xlabel('Frequency')
ylabel('Magnitude')
plot(frequencyRange,fftshift(abs(fft(nlmsSignal))));
title('NLMS Filtered Signal')
xlabel('Frequency')
ylabel('Magnitude')
subplot(324)
plot(frequencyRange,fftshift(abs(fft(sgf_signal))));
title('S-G Filtered Signal')
xlabel('Frequency')
ylabel('Magnitude')

subplot(325)
plot(frequencyRange,fftshift(abs(fft(filteredSignal))));
title('Moving DFT Filtered Signal')
xlabel('Frequency')
ylabel('Magnitude')



subplot(326)
plot(frequencyRange,fftshift(abs(fft(wienerwindowFiltered))));
title('Moving DFT Filtered Signal')
xlabel('Frequency')
ylabel('Magnitude')

%% Cross-Correlation ( IT DOES NOT EFFECTIVE WAY TO COMPARE THEM) I MIGHT HAVE DONE SOMETHING WRONG

wienerCorr = xcorr(fft(cleanSignal),fft(wienerFilteredSignal),'coeff');
DFTcorr =  xcorr(fft(cleanSignal),fft(filteredSignal),'coeff');
Sagoycorr = xcorr(fft(cleanSignal),fft(sgf_signal),'coeff');
%{
figure,
subplot(311)
plot(abs(wienerCorr));
title('Cross-Correlation of Wiener Filtered with Clean Signal')
subplot(312)
plot(abs(DFTcorr),'r');
title('Cross-Correlation of Moving DFT Filtered with Clean Signal')
subplot(313)
plot(abs(Sagoycorr),'m');
title('Cross-Correlation of S-G Filtered with Clean Signal')
%}

wienerFlag = 0;
DFTFlag = 0;
for i = 1:length(cleanSignal)
    if abs(wienerCorr(i)) > abs(DFTcorr(i))
       wienerFlag = wienerFlag + 1;
    else
        DFTFlag = DFTFlag + 1;
    end
end
fprintf('DFT Flag =')
disp(DFTFlag)
fprintf('Wiener Flag =')
disp(wienerFlag)


%% STANDART DEVIATION COMPARISION %This is also not effective, it is not compared in this way

stdClean = std(cleanSignal);
stdNoisy = std(noisySignal);
stdbest = std (wienerwindowFiltered);
stdMDFT = std(filteredSignal);

%%








