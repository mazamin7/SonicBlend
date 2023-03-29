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
% L = 1024; % good for speech
L = 2048; % good for piano
R = L/2;
NFFT = L*2;
w = @bartlett;
% M = 8; % good for speech
M = 10; % good for piano

frame = 64;

% ========== Visualize LPC envelope on first frame of modulator ===========

freq_spec = (0:(NFFT/2)-1)*fs/NFFT;

signal_stft = stft(signal, 'Window', w(L), 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');
signal_stft_frame = signal_stft(:,frame);
signal_fft_db = db(abs(signal_stft_frame(NFFT/2+1:end)));

figure('Position', [0 0 1200 600]);
plot(freq_spec, signal_fft_db, 'b', 'LineWidth', 2, 'DisplayName', 'Original signal');
hold on;

windowed_signal = get_signal_frames(signal, L, R, w, false);
windowed_signal = windowed_signal(:,frame);
signal_shaping_filters = get_shaping_filters(windowed_signal, M, NFFT, false);
plot(freq_spec, 25 + db(abs(signal_shaping_filters(NFFT/2+1:end))), 'DisplayName', 'LPC');
% shifting just for convenience (we're not interested in absolute
% values but in the envelope)

grid on;
legend('Location', 'northwest');
title('db vs frequency');
xlabel('Frequency (Hz)');
ylabel('db');