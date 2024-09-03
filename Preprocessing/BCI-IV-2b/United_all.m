% unified flow

% Data subsets for BCI-IV-2b
% We obtain the 4 seconds of motor imagery from second 3 to 7
% Fs=250Hz, therefore in 4 seconds there are 1000 data
% Input Shape: allx6
% Output Shape: (n examples*1000)x3 (n examplesx4x250)x3
% [(n examples x sec x fs) x n channels]
% you need to run biosig_installer.m

% 
% [s, h] = sload('B0901T.gdf'); % load data
% n_samples = length(h.TRIG); % calculate n of examples
% 
% % array to store motor imagery segments
% signals = zeros(n_samples*1000, 3);
% counter = 1;
% for i=1:n_samples %n samples
% % s(3sec : 7sec, n channel)
% % signal from all channels from second 3 to 7
% signals(counter:counter+999, 1:3) = ...
% s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
% counter = counter + 1000; % 1000 because it's 4 seconds at 250 Hz
% end
% % save the motor imagery segments
% % change the four numbers after B to the subject number
% % and check if it's T or E
% save('MI901T.mat','signals');
% 
% [s, h] = sload('B0902T.gdf'); % load the data
% n_samples = length(h.TRIG); % calculate n of examples
% 
% % matrix to save the motor imagery segments
% signals = zeros(n_samples*1000, 3);
% counter = 1;
% for i=1:n_samples %n samples
% % s(3sec : 7sec, n channel)
% % signal from all channels from second 3 to 7
% signals(counter:counter+999, 1:3) = ...
% s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
% counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
% end
% % save the motor imagery segments
% % change the four numbers after B to the subject number
% % and check if it is T or E
% save('MI902T.mat','signals');
% 
% [s, h] = sload('B0903T.gdf'); % load the data
% n_samples = length(h.TRIG); % calculate n of examples
% 
% % matrix to save the motor imagery segments
% signals = zeros(n_samples*1000, 3);
% counter = 1;
% for i=1:n_samples %n samples
% % s(3sec : 7sec, n channel)
% % signal from all channels from second 3 to 7
% signals(counter:counter+999, 1:3) = ...
% s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
% counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
% end
% % save the motor imagery segments
% % change the four numbers after B to the subject number
% % and check if it is T or E
% save('MI903T.mat','signals');
% 
% [s, h] = sload('B0904E.gdf'); % load the data
% n_samples = length(h.TRIG); % calculate n of examples
% 
% % matrix to save the motor imagery segments
% signals = zeros(n_samples*1000, 3);
% counter = 1;
% for i=1:n_samples %n samples
% % s(3sec : 7sec, n channel)
% % signal from all channels from second 3 to 7
% signals(counter:counter+999, 1:3) = ...
% s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
% counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
% end
% % save the motor imagery segments
% % change the four numbers after B to the subject number
% % and check if it is T or E
% save('MI904E.mat','signals');
% 
% [s, h] = sload('B0905E.gdf'); % load the data
% n_samples = length(h.TRIG); % calculate n of examples
% 
% % matrix to save the motor imagery segments
% signals = zeros(n_samples*1000, 3);
% counter = 1;
% for i=1:n_samples %n samples
% % s(3sec : 7sec, n channel)
% % signal from all channels from second 3 to 7
% signals(counter:counter+999, 1:3) = ...
% s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
% counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
% end
% % save the motor imagery segments
% % change the four numbers after B to the subject number
% % and check if it is T or E
% save('MI905E.mat','signals');
% 
% train = [];
% test = [];
% 
% load('MI901T.mat')
% train = [train; signals];
% clear signals
% 
% load('MI902T.mat')
% train = [train; signals];
% clear signals
% 
% load('MI903T.mat')
% train = [train; signals];
% clear signals
% 
% load('MI904E.mat')
% test = [test; signals];
% clear signals
% 
% load('MI905E.mat')
% test = [test; signals];
% clear signals
% 
% save('MI_train_9.mat','train');
% save('MI_test_9.mat','test');
% 
% % load data, change the number to the subject number
% load('MI_test_9.mat');
% % array to store signals without NaN
% signals_clean = zeros(size(test));
% 
% counter = 1;
% n_samples_nan = 0; % count the number of NaN examples
% n_samples = length(test)/1000;
% for i=1:n_samples % n examples
%     % read all channels of each example
%     sample = test(counter:counter+999,:);
%     % if there is a NaN
%     if sum(sum(isnan(sample))) > 0
%         % median filter order of 255
%         y = medfilt1(sample,255,'omitnan');
% %         figure;
% %         plot(sample);
% %         grid;
%         % replace NaN with the median filter values in each example
%         sample(isnan(sample)) = y(isnan(sample));
% %         figure;
% %         plot(sample);
% %         grid;
%         % save the sample without NaN
%         signals_clean(counter:counter+999, :) = sample;
%         n_samples_nan = n_samples_nan + 1;
%         disp('sample number');
%         disp(i);
%     else % If there are no NaNs, copy the values without replacing anything
%         signals_clean(counter:counter+999, :) =...
%             test(counter:counter+999, :);
%     end
%     counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
% end
% disp('Number of NaN samples');
% disp(n_samples_nan);
% 
% % load data, change to subject number and check if it is T or E
% load('Clean_test_9.mat');
% 
% % average of all channels at each time point
% % (average of each point), 2 for the average of each row
% average = mean(signals_clean,2);
% car = signals_clean - average; % subtract average from signals
% % change subject
% 
% fs = 250; % sampling frequency
% 
% % 8-30 Hz bandpass filter
% filtered_signals = bandpass(car, [8 30], fs);
% 
% % save filtered signals, change to subject number and check if
% % it is T or E
% save('FilteredB9E.mat','filtered_signals');
% 
% 
% % load data
% % change to the subject number and check if it is T or E
% load('FilteredB9E.mat');
% 
% n_samples = length(filtered_signals) / 1000; % n examples
% 
% % array to save EEG with the new organization
% new = zeros(n_samples, 3000);
% 
% counter2 = 1;
% for i=1:n_samples % n examples
%     counter1 = 1;
%     for j=1:3 % n channels
%         new(i, counter1:counter1+999)...
%             = filtered_signals(counter2:counter2+999, j);
%         % 1000 because it is 4 seconds at 250 Hz
%         counter1 = counter1 + 1000;
%     end
%     % 1000 because it is 4 seconds at 250 Hz
%     counter2 = counter2 + 1000;
% end
% 
% % change to the subject number and check if it is T or E
% csvwrite('MI-EEG-B9E.csv',new); % save in .csv
% save('MI-EEG-B9E.mat','new'); % save in .mat
% 
% train_labels = [];
% 
% load('B0901T.mat');
% train_labels = [train_labels; classlabel - 1];
% clear classlabel
% 
% load('B0902T.mat');
% train_labels = [train_labels; classlabel - 1];
% clear classlabel
% 
% load('B0903T.mat');
% train_labels = [train_labels; classlabel - 1];
% clear classlabel 
% % test 
% 
% test_labels = [];
% 
% load('B0904E.mat');
% test_labels = [test_labels; classlabel - 1];
% clear classlabel 
% load('B0905E.mat');
% test_labels = [test_labels; classlabel - 1];
% clear classlabel 
% 
% csvwrite('train_labels_9.csv', train_labels);
% csvwrite('test_labels_9.csv', test_labels);train = [];


for patient = 1:9
    train = [];
    test = [];
    
    % Process Training Data
    for session = 1:3
        filename = sprintf('B%02d0%dT.gdf', patient, session);
        [s, h] = sload(filename); % load data
        n_samples = length(h.TRIG); % calculate n of examples

        % Array to store motor imagery segments
        signals = zeros(n_samples * 1000, 3);
        counter = 1;
        for i = 1:n_samples
            % Signal from all channels from second 3 to 7
            signals(counter:counter+999, 1:3) = s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
            counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
        end
        
        save(sprintf('MI%02d0%dT.mat', patient, session), 'signals');
        train = [train; signals];
        clear signals
    end
    
    % Process Testing Data
    for session = 4:5
        filename = sprintf('B%02d0%dE.gdf', patient, session);
        [s, h] = sload(filename); % load data
        n_samples = length(h.TRIG); % calculate n of examples

        % Array to store motor imagery segments
        signals = zeros(n_samples * 1000, 3);
        counter = 1;
        for i = 1:n_samples
            % Signal from all channels from second 3 to 7
            signals(counter:counter+999, 1:3) = s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
            counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
        end
        
        save(sprintf('MI%02d0%dE.mat', patient, session), 'signals');
        test = [test; signals];
        clear signals
    end
    
    % Save combined training and testing data
    save(sprintf('MI_train_%02d.mat', patient), 'train');
    save(sprintf('MI_test_%02d.mat', patient), 'test');
    
    % Clean Test Data (Removing NaNs)
    load(sprintf('MI_test_%02d.mat', patient));
    signals_clean = zeros(size(test));
    counter = 1;
    n_samples_nan = 0; % Count the number of NaN examples
    n_samples = length(test) / 1000;
    
    for i = 1:n_samples
        sample = test(counter:counter+999,:);
        if sum(sum(isnan(sample))) > 0
            y = medfilt1(sample, 255, 'omitnan');
            sample(isnan(sample)) = y(isnan(sample));
            signals_clean(counter:counter+999, :) = sample;
            n_samples_nan = n_samples_nan + 1;
        else
            signals_clean(counter:counter+999, :) = test(counter:counter+999, :);
        end
        counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
    end
    
    save(sprintf('Clean_test_%02d.mat', patient), 'signals_clean');
    
    % Filter the cleaned signals
    fs = 250; % Sampling frequency
    average = mean(signals_clean, 2);
    car = signals_clean - average; % Subtract average from signals
    
    % 8-30 Hz bandpass filter
    filtered_signals = bandpass(car, [8 30], fs);
    save(sprintf('FilteredB%02dE.mat', patient), 'filtered_signals');
    
    % Reorganize filtered signals and save as CSV and MAT
    new = zeros(n_samples, 3000);
    counter2 = 1;
    for i = 1:n_samples
        counter1 = 1;
        for j = 1:3
            new(i, counter1:counter1+999) = filtered_signals(counter2:counter2+999, j);
            counter1 = counter1 + 1000;
        end
        counter2 = counter2 + 1000;
    end
    
    csvwrite(sprintf('MI-EEG-B%02dE.csv', patient), new);
    save(sprintf('MI-EEG-B%02dE.mat', patient), 'new');
    
    % Prepare training labels
    train_labels = [];
    for session = 1:3
        load(sprintf('B%02d0%dT.mat', patient, session));
        train_labels = [train_labels; classlabel - 1];
        clear classlabel
    end
    csvwrite(sprintf('labels_train_%02d.csv', patient), train_labels);
    
    % Prepare testing labels
    test_labels = [];
    for session = 4:5
        load(sprintf('B%02d0%dE.mat', patient, session));
        test_labels = [test_labels; classlabel - 1];
        clear classlabel
    end
    csvwrite(sprintf('labels_test_%02d.csv', patient), test_labels);
end