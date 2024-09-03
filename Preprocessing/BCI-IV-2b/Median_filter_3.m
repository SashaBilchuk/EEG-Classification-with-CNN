% replace NaN with the values obtained with the median filter
% Input Shape: (n_sample*1000)x3
% Output Shape: (n_sample*1000)x3

clear
clc

% load data, change the number to the subject number
load('MI_test_9.mat');
% array to store signals without NaN
signals_clean = zeros(size(test));

counter = 1;
n_samples_nan = 0; % count the number of NaN examples
n_samples = length(test)/1000;
for i=1:n_samples % n examples
    % read all channels of each example
    sample = test(counter:counter+999,:);
    % if there is a NaN
    if sum(sum(isnan(sample))) > 0
        % median filter order of 255
        y = medfilt1(sample,255,'omitnan');
%         figure;
%         plot(sample);
%         grid;
        % replace NaN with the median filter values in each example
        sample(isnan(sample)) = y(isnan(sample));
%         figure;
%         plot(sample);
%         grid;
        % save the sample without NaN
        signals_clean(counter:counter+999, :) = sample;
        n_samples_nan = n_samples_nan + 1;
        disp('sample number');
        disp(i);
    else % If there are no NaNs, copy the values without replacing anything
        signals_clean(counter:counter+999, :) =...
            test(counter:counter+999, :);
    end
    counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
end
disp('Number of NaN samples');
disp(n_samples_nan);
%change the number to the subject's number
save('Clean_test_9.mat','signals_clean');