% 8-30hz bandpass filter
% All signals will be filtered with a single command
% Input Shape: (n examples*1000)x3
% Output Shape: (n examples*1000)x3
% channel C4 is 3
% sample 2 is right for subject 1

clear
clc

% load data, change to subject number and check if it is T or E
load('CarB09E.mat');
fs = 250; % sampling frequency

% 8-30 Hz bandpass filter
filtered_signals = bandpass(car, [8 30], fs);

% save filtered signals, change to subject number and check if
% it is T or E
save('FilteredB9E.mat','filtered_signals');

% This is to plot the difference between the signal and its spectra with FFT
% subplot(2,1,1);
% c4 = car(1000:2000,3);
% plot(c4,'LineWidth',1);
% hold on
% c4_filtered = filtered_signals(1000:2000,3);
% plot(c4_filtered,'LineWidth',1);
% grid;
% xlabel('Time');
% ylabel('Amplitude');
% legend('C4 CAR','C4 Band Pass 8Hz-30Hz');
% hold off`
%
% % FFT
% [P1_1, f_1] = fourierTransform(c4', fs);
% [P1_2, f_2] = fourierTransform(c4_filtered', fs);
% subplot(2,1,2);
% plot(f_1, P1_1,'LineWidth',1);
% hold on % plot(f_2, P1_2,'LineWidth',1);
% title('Fast Fourier Transform');
% xlabel('Frequency');
% ylabel('Power');
% legend('C4 CAR','C4 Band Pass 8Hz-30Hz');
% axis([0 35 0 1.5]);
% grid;
% % %-------------------------------------------------- % % Functions % %-------------------------------------------------- % 
% function [P1, f] = fourierTransform(signal, fs)
%      [fs, signalsize]=size(signal);
%      Y = fft(signal);
%      % Calculate the bilateral spectrum P2. Next, calculate the
%      % one-sided spectrum P1 based on P2 and the signal length of
%      % uniform value L
%      P2 = abs(Y/signalsize);
%      P1 = P2(1:floor(signalsize/2+1));
%      P1(2:end-1) = 2*P1(2:end-1);
%      f = fs*(0:(signalsize/2))/signalsize;
% end