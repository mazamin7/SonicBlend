clear all; close all; clc;

% ==================== Description of the script ==========================

% The shaping_filter_visualizer script which reads an audio file and plots
% the FFT and the shaping filter of a frame, in order to compare them

addpath library

% ============== Imports and Load Audio ===============

% Load audio file
[signal, fs] = audioread('speech.wav');
%[signal, fs] = audioread('piano.wav');

if(~iscolumn(signal))
    signal = signal';
end

% If there are two channels, just use one
if size(signal,2) > 1
    signal = signal(:,1);
end

% Normalize signal
signal = signal./max(abs(signal));

% Set parameters
L = 1024;         % window length
M = 512;           % lpc order

w_fun = @bartlett;          % window type
R = L/2;          % hop size

use_gradient_descent = false;
error_tolerance = 1e-2; % only has effect for gradient descent
error_tolerance_finer = 1e-10; % only has effect for gradient descent
max_num_iter = 1e2; % only has effect for gradient descent
max_num_iter_finer = 1e6; % only has effect for gradient descent

NFFT = 2*L;

frame = 32;

% ========== Visualize LPC envelope on first frame of modulator ===========

freq_spec = (0:(NFFT/2)-1)*fs/NFFT;

signal_stft = stft(signal, 'Window', w_fun(L), 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');
signal_stft_frame = signal_stft(:,frame);
signal_fft_db = db(abs(signal_stft_frame(1:NFFT/2)));

figure('Position', [0 0 1200 600]);
plot(freq_spec, signal_fft_db, 'b', 'LineWidth', 2, 'DisplayName', 'Original signal');
hold on;

windowed_signal = get_signal_frames(signal, L, R, w_fun, false);
windowed_signal = windowed_signal(:,frame);
[signal_shaping_filters, count] = get_shaping_filters(windowed_signal, M, NFFT, use_gradient_descent, error_tolerance, max_num_iter, false);
[signal_shaping_filters_finer, count_finer] = get_shaping_filters(windowed_signal, M, NFFT, use_gradient_descent, error_tolerance_finer, max_num_iter_finer, false);
shaping_filter_db = db(abs(signal_shaping_filters(1:NFFT/2)));
shaping_filter_db_finer = db(abs(signal_shaping_filters_finer(1:NFFT/2)));

% shifting just for convenience (we're not interested in absolute
% values but in the envelope)
LIMIT = 200;
shift = mean(signal_fft_db(1:LIMIT)) - mean(shaping_filter_db(1:LIMIT));
shift_finer = mean(signal_fft_db(1:LIMIT)) - mean(shaping_filter_db_finer(1:LIMIT));

figure(1)
plot(freq_spec, shaping_filter_db + shift, 'DisplayName', 'LPC');
if use_gradient_descent
    hold on
    plot(freq_spec, shaping_filter_db_finer + shift_finer, 'DisplayName', 'LPC with a finer tolerance');
end

grid on;
legend('Location', 'northwest');
title('db vs frequency');
xlabel('Frequency (Hz)');
ylabel('db');