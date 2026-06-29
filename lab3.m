%% Lab 3 - Filtering and Noise Removal

clear; close all; clc;

%% Select file
filename = 'lightSensor1000Hz.csv';
Fs = 1000;   % Adjust depending on dataset

%% Load data
data = readtable(filename);

time_ms = data.time;
light = data.light;

time_s = time_ms / 1000;

%% Plot raw signal
figure;
plot(time_s, light);
xlabel('Time (s)');
ylabel('Light Intensity');
title(['Raw Signal - ' filename]);
grid on;

%% Plot first 20 ms
idx_20ms = time_ms <= 20;

figure;
plot(time_s(idx_20ms), light(idx_20ms));
xlabel('Time (s)');
ylabel('Light Intensity');
title('Raw Signal (First 20 ms)');
grid on;
xlim([0 0.02]);

%% Compute statistics
fprintf('Raw signal standard deviation: %.2f\n\n', std(light));

%% -----------------------------
%% Moving Average Filter
%% -----------------------------
window = 10;   % try 3, 5, 10, 20
filtered_ma = movmean(light, window);

%% -----------------------------
%% Low-Pass Filter
%% -----------------------------
% Cutoff frequency (Hz)
fc = 200;   % keep main signal (~150 Hz), remove higher noise

filtered_lp = lowpass(light, fc, Fs);

%% -----------------------------
%% Plot comparison (full signal)
%% -----------------------------
figure;
plot(time_s, light, 'b');
hold on;
plot(time_s, filtered_ma, 'r', 'LineWidth', 1.2);
plot(time_s, filtered_lp, 'g', 'LineWidth', 1.2);
xlabel('Time (s)');
ylabel('Light Intensity');
title('Raw vs Filtered Signals');
legend('Raw', 'Moving Avg', 'Low-pass');
grid on;

%% Zoomed comparison (first 20 ms)
figure;
plot(time_s(idx_20ms), light(idx_20ms), 'b');
hold on;
plot(time_s(idx_20ms), filtered_ma(idx_20ms), 'r', 'LineWidth', 1.2);
plot(time_s(idx_20ms), filtered_lp(idx_20ms), 'g', 'LineWidth', 1.2);
xlabel('Time (s)');
ylabel('Light Intensity');
title('Zoomed Comparison (First 20 ms)');
legend('Raw', 'Moving Avg', 'Low-pass');
grid on;

%% -----------------------------
%% FFT Computation
%% -----------------------------
N = length(light);

% Raw signal
light_detrended = light - mean(light);
Y = fft(light_detrended);

% Moving average
ma_detrended = filtered_ma - mean(filtered_ma);
Yma = fft(ma_detrended);

% Low-pass
lp_detrended = filtered_lp - mean(filtered_lp);
Ylp = fft(lp_detrended);

% Magnitudes
P2 = abs(Y / N);
P2_ma = abs(Yma / N);
P2_lp = abs(Ylp / N);

P1 = P2(1:N/2+1);
P1_ma = P2_ma(1:N/2+1);
P1_lp = P2_lp(1:N/2+1);

P1(2:end-1) = 2 * P1(2:end-1);
P1_ma(2:end-1) = 2 * P1_ma(2:end-1);
P1_lp(2:end-1) = 2 * P1_lp(2:end-1);

% Frequency axis
f = Fs * (0:(N/2)) / N;

%% Plot FFT comparison
figure;
plot(f, P1, 'b');
hold on;
plot(f, P1_ma, 'r', 'LineWidth', 1.2);
plot(f, P1_lp, 'g', 'LineWidth', 1.2);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT: Raw vs Filtered');
legend('Raw', 'Moving Avg', 'Low-pass');
grid on;
xlim([0 Fs/2]);
