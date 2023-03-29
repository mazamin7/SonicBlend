clear all; close all; clc;

addpath library

% ============== Imports and Load Audio =============== %

% Load audio files
% [signal, fs] = audioread('speech.wav');
[signal, fs] = audioread('piano.wav');

if(~iscolumn(signal))
    signal = signal';
end

% If there are two channels, just use one
if size(signal,2) > 1
    signal = signal(:,1);
end

% Normalize signals
signal = signal./max(abs(signal));

% Set parameters
L = 1024;         % window length
M = 512;           % lpc order

w_fun = @bartlett;          % window type
R = L/2;          % hop size

use_gradient_descent = false;
error_tolerance = 1e-2; % only has effect for gradient descent
max_num_iter = 1e3; % only has effect for gradient descent

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
shaping_filter_db = db(abs(signal_shaping_filters(1:NFFT/2)));

% shifting just for convenience (we're not interested in absolute
% values but in the envelope)
shift = mean(signal_fft_db) - mean(shaping_filter_db);

plot(freq_spec, shaping_filter_db + shift, 'DisplayName', 'LPC');

grid on;
legend('Location', 'northwest');
title('db vs frequency');
xlabel('Frequency (Hz)');
ylabel('db');