% Data subsets for BCI-IV-2b
% We obtain the 4 seconds of motor imagery from second 3 to 7
% Fs=250Hz, therefore in 4 seconds there are 1000 data
% Input Shape: allx6
% Output Shape: (n examples*1000)x3 (n examplesx4x250)x3
% [(n examples x sec x fs) x n channels]
% you need to run biosig_installer.m


[s, h] = sload('B0901T.gdf'); % load data
n_samples = length(h.TRIG); % calculate n of examples

% array to store motor imagery segments
signals = zeros(n_samples*1000, 3);
counter = 1;
for i=1:n_samples %n samples
% s(3sec : 7sec, n channel)
% signal from all channels from second 3 to 7
signals(counter:counter+999, 1:3) = ...
s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
counter = counter + 1000; % 1000 because it's 4 seconds at 250 Hz
end
% save the motor imagery segments
% change the four numbers after B to the subject number
% and check if it's T or E
save('MI901T.mat','signals');

[s, h] = sload('B0902T.gdf'); % load the data
n_samples = length(h.TRIG); % calculate n of examples

% matrix to save the motor imagery segments
signals = zeros(n_samples*1000, 3);
counter = 1;
for i=1:n_samples %n samples
% s(3sec : 7sec, n channel)
% signal from all channels from second 3 to 7
signals(counter:counter+999, 1:3) = ...
s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
end
% save the motor imagery segments
% change the four numbers after B to the subject number
% and check if it is T or E
save('MI902T.mat','signals');

[s, h] = sload('B0903T.gdf'); % load the data
n_samples = length(h.TRIG); % calculate n of examples

% matrix to save the motor imagery segments
signals = zeros(n_samples*1000, 3);
counter = 1;
for i=1:n_samples %n samples
% s(3sec : 7sec, n channel)
% signal from all channels from second 3 to 7
signals(counter:counter+999, 1:3) = ...
s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
end
% save the motor imagery segments
% change the four numbers after B to the subject number
% and check if it is T or E
save('MI903T.mat','signals');

[s, h] = sload('B0904E.gdf'); % load the data
n_samples = length(h.TRIG); % calculate n of examples

% matrix to save the motor imagery segments
signals = zeros(n_samples*1000, 3);
counter = 1;
for i=1:n_samples %n samples
% s(3sec : 7sec, n channel)
% signal from all channels from second 3 to 7
signals(counter:counter+999, 1:3) = ...
s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
end
% save the motor imagery segments
% change the four numbers after B to the subject number
% and check if it is T or E
save('MI904E.mat','signals');

[s, h] = sload('B0905E.gdf'); % load the data
n_samples = length(h.TRIG); % calculate n of examples

% matrix to save the motor imagery segments
signals = zeros(n_samples*1000, 3);
counter = 1;
for i=1:n_samples %n samples
% s(3sec : 7sec, n channel)
% signal from all channels from second 3 to 7
signals(counter:counter+999, 1:3) = ...
s(h.TRIG(i)+751 : h.TRIG(i)+1750, 1:3);
counter = counter + 1000; % 1000 because it is 4 seconds at 250 Hz
end
% save the motor imagery segments
% change the four numbers after B to the subject number
% and check if it is T or E
save('MI905E.mat','signals');