clear all; close all; clc;

addpath library

%==============Imports and Load Audio===============%

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

modulator_stft = stft(signal, 'Window', w, 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');
modulator_fft = modulator_stft(:,frame);
modulator_fft_db = 20*log10(abs(modulator_fft));

figure('Position', [0 0 1200 600]);
plot(freq_spec, modulator_fft_db, 'b', 'LineWidth', 2, 'DisplayName', 'Original signal');
hold on;

windowed_signal = get_windowed_signal(signal, L, R, w);
signal_spec_envs = gen_lpc_spec_envs(windowed_signal, M, NFFT);
plot(freq_spec, 20*log10(abs(signal_spec_envs(:, frame)')), 'DisplayName', 'LPC');

grid on;
legend('Location', 'northwest');
title('db vs frequency');
xlabel('Frequency (Hz)');
ylabel('db');