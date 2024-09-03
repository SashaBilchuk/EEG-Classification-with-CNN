% Merge labels
% train = first 3 sessions
% test = last 2 sessions

clear
clc

% train
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