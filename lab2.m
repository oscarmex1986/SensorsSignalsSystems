%% Lab 2 - Frequency Domain Analysis

clear; close all; clc;

%% Select file
filename = 'lightSensor1000Hz.csv';

%% Load data
data = readtable(filename);

time_ms = data.time;
light = data.light;

% Convert time
time_s = time_ms / 1000;

%% Plot first 20 ms (for visual estimation)
idx_20ms = time_ms <= 20;

figure;
plot(time_s(idx_20ms), light(idx_20ms));
xlabel('Time (s)');
ylabel('Light Intensity');
title(['First 20 ms - ' filename]);
grid on;
xlim([0 0.02]);

%% FFT Analysis

% Sampling frequency
Fs = 1000;   % adjust if using other files

N = length(light);

% Remove DC component
light_detrended = light - mean(light);

% Compute FFT
Y = fft(light_detrended);

% Two-sided spectrum
P2 = abs(Y / N);

% Single-sided spectrum
P1 = P2(1:N/2+1);
P1(2:end-1) = 2 * P1(2:end-1);

% Frequency vector
f = Fs * (0:(N/2)) / N;

%% Plot frequency domain
figure;
plot(f, P1);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title(['FFT Spectrum - ' filename]);
grid on;
xlim([0 Fs/2]);

%% Find dominant frequency
[~, idx_max] = max(P1);
dominant_freq = f(idx_max);

fprintf('Estimated dominant frequency from FFT: %.2f Hz\n', dominant_freq);
