% Arrange the data so that the channels are concatenated
% Input Shape: (n_samples*1000)x3
% Output Shape: n_samples*3000
% the rows are the number of examples and the columns are the 4 seconds at
% 250 Hz of the 3 concatenated channels (3000)

clear
clc

% load data
% change to the subject number and check if it is T or E
load('FilteredB9E.mat');

n_samples = length(filtered_signals) / 1000; % n examples

% array to save EEG with the new organization
new = zeros(n_samples, 3000);

counter2 = 1;
for i=1:n_samples % n examples
    counter1 = 1;
    for j=1:3 % n channels
        new(i, counter1:counter1+999)...
            = filtered_signals(counter2:counter2+999, j);
        % 1000 because it is 4 seconds at 250 Hz
        counter1 = counter1 + 1000;
    end
    % 1000 because it is 4 seconds at 250 Hz
    counter2 = counter2 + 1000;
end

% change to the subject number and check if it is T or E
csvwrite('MI-EEG-B9E.csv',new); % save in .csv
save('MI-EEG-B9E.mat','new'); % save in .mat

train_labels = [];

load('B0901T.mat');
train_labels = [train_labels; classlabel - 1];
clear classlabel

load('B0902T.mat');
train_labels = [train_labels; classlabel - 1];
clear classlabel

load('B0903T.mat');
train_labels = [train_labels; classlabel - 1];
clear classlabel 
% test 

test_labels = [];

load('B0904E.mat');
test_labels = [test_labels; classlabel - 1];
clear classlabel 
load('B0905E.mat');
test_labels = [test_labels; classlabel - 1];
clear classlabel 

csvwrite('train_labels_9.csv', train_labels);
csvwrite('test_labels_9.csv', test_labels);