clear all; close all; clc;

addpath library

% ============== Imports and Load Audio =============== %

% Load audio files
[signal, fs] = audioread('modulator.wav');

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
L = 1024;
R = L/2;
NFFT = L*2;
w = bartlett(L);
M = 32;

frame = 19;

% ========== Visualize LPC envelope on first frame of modulator ===========

freq_spec = (-(NFFT/2):(NFFT/2)-1)*fs/NFFT;

signal_stft = stft(signal, 'Window', w, 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');
signal_stft_frame = signal_stft(:,frame);
signal_fft_db = 20*log10(abs(signal_stft_frame));

figure('Position', [0 0 1200 600]);
plot(freq_spec, signal_fft_db, 'b', 'LineWidth', 2, 'DisplayName', 'Original signal');
hold on;

windowed_signal = get_signal_frames(signal, L, R, w);
windowed_signal = windowed_signal(:,frame);
signal_shaping_filters = get_shaping_filters(windowed_signal, M, NFFT, false);
plot(freq_spec, 20*log10(abs(signal_shaping_filters)), 'DisplayName', 'LPC');

grid on;
legend('Location', 'northwest');
title('db vs frequency');
xlabel('Frequency (Hz)');
ylabel('db');