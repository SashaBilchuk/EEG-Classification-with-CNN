patients = [1,2,3,4,5,6,7,8,9];
for i = 1:length(patients)
    disp(['Starting patient num ', num2str(patients(i))]);

    % Load data
    x_train = readmatrix(['Preprocessed_data/MI-EEG-B', num2str(patients(i)), 'T.csv']);
    x_test = readmatrix(['Preprocessed_data/MI-EEG-B', num2str(patients(i)), 'E.csv']);
    y_train = readmatrix(['Preprocessed_data/labels_train_', num2str(patients(i)), '.csv']);
    y_test = readmatrix(['Preprocessed_data/labels_test_', num2str(patients(i)), '.csv']);
    n_classes = length(unique(y_test));

    % Process data using STFT
    x_train = join_vertical_spectrograms(x_train, 250, 135, 31, 3, 1000, 225);
    x_test = join_vertical_spectrograms(x_test, 250, 135, 31, 3, 1000, 225);

    % Reshape for CNN + LSTM
    x_train = reshape(x_train, [size(x_train,1), 1, size(x_train,2), size(x_train,3), 1]);
    x_test = reshape(x_test, [size(x_test,1), 1, size(x_test,2), size(x_test,3), 1]);

    startTime = tic;
    array_loss = [];
    array_acc = [];
    array_kappa = [];
    number_of_epochs = 5;
    x = ceil(max(x_train, [], 'all'));

    % Normalize data
    x_train = single(x_train) / x;
    x_test = single(x_test) / x;

    for j = 1:number_of_epochs
        disp(['Iteration: ', num2str(j)]);

        % Select neural network model
        model = CNN_2D_LSTM_TD(4, [3,3], 32, 4, n_classes, size(x_train, 2:4));

        % Train the model
        history = trainNetwork(x_train, y_train, model, ...
            'MiniBatchSize', 36, 'MaxEpochs', 400, ...
            'ValidationData', {x_test, y_test}, ...
            'Verbose', false);

        % Evaluate model
        [YPred, test_loss] = predict(model, x_test);
        test_acc = mean(YPred == y_test);
        
        array_loss = [array_loss; test_loss];
        disp(['loss: ', num2str(test_loss)]);
        array_acc = [array_acc; test_acc];
        disp(['accuracy: ', num2str(test_acc)]);

        % Calculate Cohen's kappa
        [~, y_pred] = max(YPred, [], 2);
        kappa = cohenkappa(y_test, y_pred);
        array_kappa = [array_kappa; kappa];
        disp(['kappa: ', num2str(kappa)]);

        % Confusion matrix
        confusion_matrix_table = confusionmat(y_test, y_pred);
        disp('confusion matrix:');
        disp(confusion_matrix_table);
    end

    % Results
    disp('Results:');
    disp(['loss: ', num2str(array_loss)]);
    disp(['accuracy: ', num2str(array_acc)]);
    disp(['kappa: ', num2str(array_kappa)]);
    total_time = toc(startTime);
    disp(['Time took: ', num2str(total_time)]);
    disp(['patient num ', num2str(patients(i))]);

    disp(['Mean Accuracy: ', num2str(mean(array_acc))]);
    disp(['std: (+/- ', num2str(std(array_acc)), ')']);
    disp(['Mean Kappa: ', num2str(mean(array_kappa))]);
    disp(['std: (+/- ', num2str(std(array_kappa)), ')']);
    disp(['Max Accuracy: ', num2str(max(array_acc))]);
    disp(['Max Kappa: ', num2str(max(array_kappa))]);
    disp(['Time took: ', num2str(int32(total_time))]);

end

function datas = join_vertical_scalograms(data, fs, high, width, n_channels, pts_sig)
    dim = [floor(width/2), floor(high/2)]; % [width, height]
    scales = centfrq('cmor3-3') ./ (8:0.5:30.5) * fs;

    datas = zeros(size(data, 1), dim(2), dim(1)); % [samples, height, width]
    temp = zeros(high, width); % Temporary storage for each sample

    for i = 1:size(data, 1)
        for j = 1:n_channels
            sig = data(i, (j-1)*pts_sig+1:j*pts_sig);
            [coef, freqs] = cwt(sig, scales, 'cmor3-3', 'SamplingPeriod', 1/fs);
            temp((j-1)*45+1:j*45, :) = abs(coef);
        end
        datas(i, :, :) = imresize(temp, dim, 'method', 'bicubic');
        if mod(i, 100) == 0
            disp(i);
        end
    end
end

function datas = join_vertical_spectrograms(data, fs, height, width, n_channels, pts_sig, pts_overlapping)
    datas = zeros(size(data, 1), height, width);
    temporal = zeros(height, width);

    for i = 1:size(data, 1)
        for j = 1:n_channels
            sig = data(i, (j-1)*pts_sig+1:j*pts_sig);
            [Sxx, f, t] = spectrogram(sig, hann(fs), pts_overlapping, fs*2, fs, 'yaxis');
            temporal((j-1)*45+1:j*45, :) = Sxx(16:60, :);
        end
        datas(i, :, :) = temporal;
        if mod(i, 100) == 0
            disp(i);
        end
    end
end

function model = CNN_2D(n_filters, filter_size, n_neurons, n_classes, input_shape)
    layers = [
        imageInputLayer(input_shape)
        convolution2dLayer(filter_size, n_filters, 'Padding', 'same')
        reluLayer
        maxPooling2dLayer(2, 'Stride', 2)
        
        convolution2dLayer(filter_size, n_filters, 'Padding', 'same')
        reluLayer
        maxPooling2dLayer(2, 'Stride', 2)
        
        fullyConnectedLayer(n_neurons)
        reluLayer
        dropoutLayer(0.5)
        
        fullyConnectedLayer(n_classes)
        softmaxLayer
        classificationLayer
    ];

    options = trainingOptions('adam', ...
        'InitialLearnRate', 1e-4, ...
        'MaxEpochs', 400, ...
        'MiniBatchSize', 36, ...
        'Verbose', false, ...
        'Plots', 'none');
    
    model = layerGraph(layers);
    model = trainNetwork([], [], model, options);  % Replace [] with actual training data and labels
end

function model = CNN_2D_LSTM_TD(n_filters, filter_size, n_neurons, LSTM_units, n_classes, input_shape)
    % input_shape should be [time_steps, height, width, channels]
    
    layers = [
        sequenceInputLayer([input_shape(2:end)])
        
        % Fold sequence to apply convolution to each time step separately
        sequenceFoldingLayer
        
        % First CNN Block
        convolution2dLayer(filter_size, n_filters, 'Padding', 'same')
        reluLayer
        maxPooling2dLayer(2, 'Stride', 2)
        
        % Second CNN Block
        convolution2dLayer(filter_size, n_filters, 'Padding', 'same')
        reluLayer
        maxPooling2dLayer(2, 'Stride', 2)
        
        % Unfold sequence back to original time dimension
        sequenceUnfoldingLayer
        
        % Flatten the output of the CNN block
        flattenLayer
        
        % LSTM Layer
        lstmLayer(LSTM_units, 'OutputMode', 'last', ...
            'StateActivationFunction', 'tanh', ...
            'GateActivationFunction', 'sigmoid')
        
        % Apply Dropout after LSTM layer
        dropoutLayer(0.5)
        
        % Fully Connected Layers
        fullyConnectedLayer(n_neurons)
        reluLayer
        
        fullyConnectedLayer(n_classes)
        softmaxLayer
        classificationLayer
    ];

    options = trainingOptions('adam', ...
        'InitialLearnRate', 1e-4, ...
        'MaxEpochs', 400, ...
        'MiniBatchSize', 36, ...
        'Verbose', false, ...
        'Plots', 'none');
    
    model = layerGraph(layers);
    % model = trainNetwork(x_train, y_train, model, options);  % Replace with your actual training data and labels
end