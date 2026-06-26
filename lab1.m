%% Lab 1 

clear; close all; clc;

%% Select file
filename = 'lightSensor1000Hz.csv';   % change to test other files

%% Load data
data = readtable(filename);

time_ms = data.time;
light = data.light;

% Convert to seconds
time_s = time_ms / 1000;

%% Plot full signal
figure;
plot(time_s, light);
xlabel('Time (s)');
ylabel('Light Intensity');
title(['Full Signal - ' filename]);
grid on;

%% Plot first 100 ms
idx_20ms = time_ms <= 20;

figure;
plot(time_s(idx_20ms), light(idx_20ms));
xlabel('Time (s)');
ylabel('Light Intensity');
title(['First 20 ms - ' filename]);
grid on;
xlim([0 0.02]);

%% Static characteristics
max_val = max(light);
min_val = min(light);
mean_val = mean(light);
std_val = std(light);

%% Display results
fprintf('Results for %s:\n', filename);
fprintf('Max value: %.2f\n', max_val);
fprintf('Min value: %.2f\n', min_val);
fprintf('Mean value: %.2f\n', mean_val);
fprintf('Standard deviation: %.2f\n\n', std_val);


%% Boxplot
figure;
boxplot(light);
ylabel('Light Intensity');
title(['Boxplot - ' filename]);
grid on;

