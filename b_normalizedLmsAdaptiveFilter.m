% NORMALIZED LMS ALGORITHM (ADAPTIVE FILTER)
set(0,'DefaultFigureWindowStyle','docked'); 
clc,clear,close all;
fs = 8000; 
load('kaiserWindowed');
load('frequencyRange');
t = 0:1/fs:length(kaiserWindowed)/fs-1/fs;
signal = kaiserWindowed;
delayFilter=filter([ 0 0 0 0 0 0 0 0 1 ],1,signal);    % Delay filter 
mu= 0.0001;              % Initialize the step size for LMS algorithms
w = zeros(1,10);                     % Initialize the adaptive filter coefficients
outputSignal = zeros(1,length(signal));   % Initialize the adaptive filter output
errorVector = outputSignal ; 
order = 100;

% Perform Adaptive Filtering 
for i = order:1:length(signal)-1
    flag = 0;
    for j = 1:1:10
    flag = flag + w(j)*delayFilter(i-j);
    end
    outputSignal(i) = flag;
    errorVector(i)=signal(i)-outputSignal(i);
    for k=1:1:10
    a = 1;
    w(k)=w(k)+mu./(a+(abs(signal(k))^2))*errorVector(i)*delayFilter(i-k);

    end

end

%sound(outputSignal*5);

%% Plots
subplot(311);
plot(errorVector)
title('Error e(n)(Normalized LMS Algorithm)')
xlabel('Samples')
ylabel('Magnitude')
subplot(312);
OUTPUTSIGNAL = fftshift(fft(outputSignal));
plot(frequencyRange,abs(OUTPUTSIGNAL));
title('Filtered Signal Frequency Domain(Normalized LMS Algorithm)')
xlabel('Frequency')
ylabel('Magnitude')
subplot(313);
plot(outputSignal);
title('Filtered Signal (Normalized LMS Algorithm)')
ylabel('Magnitude')
xlabel('Samples')

% to save data;
nlmsSignal = outputSignal;