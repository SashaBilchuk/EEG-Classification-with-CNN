% CAR (common average reference)
% Input Shape: (n_sample*1000)x3
% Output Shape: (n_sample*1000)x3
% channel C4 is 3
% sample 2 is right for subject 1

clear
clc

% load data, change to subject number and check if it is T or E
load('Clean_test_9.mat');

% average of all channels at each time point
% (average of each point), 2 for the average of each row
average = mean(signals_clean,2);
car = signals_clean - average; % subtract average from signals
% change subject
save('CarB09E.mat','car');

% % This is to graph the difference in the signal when applying CAR
c4 = signals_clean(1000:2000,3);
plot(c4,'LineWidth',1);
hold on
c4_car = car(1000:2000,3);
plot(c4_car,'LineWidth',1);
grid;
xlabel('Time');
ylabel('Amplitude');
legend('C4','C4 CHAR');
hold off