clear all; close all; clc;

addpath library

%==============Imports and Load Audio===============%

% Load audio files
[modulator, fs_mod] = audioread('modulator.wav');
[carrier, fs_car] = audioread('organ_carrier.wav');

% Make sure files are the same sampling rate
fs = min(fs_mod, fs_car);
modulator = resample(modulator, fs, fs_mod);
carrier = resample(carrier, fs, fs_car);

% Trim carrier and modulator to same length
carrier = carrier(1:min(length(modulator), length(carrier)));
modulator = modulator(1:min(length(modulator), length(carrier)));

if(~iscolumn(carrier))
    carrier = carrier';
end

if(~iscolumn(modulator))
    modulator = modulator';
end

% If there are two channels, just use one
if size(carrier,2) > 1
    carrier = carrier(:,1);
end

if size(modulator,2) > 1
    modulator = modulator(:,1);
end

% Normalize signals
carrier = carrier./max(abs(carrier));
modulator = modulator./max(abs(modulator));

% Set parameters
L = 1024;
R = L/2;
w = bartlett(L);
NFFT = L*2;

M = 32;

% ==========Visualize LPC envelope on first frame of modulator===========

frame = 19;

freq_spec = (-(NFFT/2):(NFFT/2)-1)*fs/NFFT;

modulator_stft = stft(modulator, 'Window', w, 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');
modulator_fft = modulator_stft(:,frame);
modulator_fft_db = 20*log10(abs(modulator_fft));

figure('Position', [0 0 1200 600]);
plot(freq_spec, modulator_fft_db, 'b', 'LineWidth', 2, 'DisplayName', 'Original signal');
hold on;

windowed_modulator = get_windowed_signal(modulator, L, R, w);
modulator_spec_envs = gen_lpc_spec_envs(windowed_modulator, M, NFFT);
plot(freq_spec, 20*log10(abs(modulator_spec_envs(:, frame)')), 'DisplayName', 'LPC');

grid on;
legend('Location', 'northwest');
title('db vs frequency');
xlabel('Frequency (Hz)');
ylabel('db');

% ========== CROSS-SYNTHESIS ==========

% Calculate lpc using "lpc"
freq_domain = false;
cross_synth_audio = cross_synthesis(fs, carrier, modulator, L, R, M, true, w, false, freq_domain);

cross_synth_audio = real(cross_synth_audio) / max(abs(cross_synth_audio)) * 0.8;

% Save the cross-synthesis result to a WAV file
audiowrite('cross_synthesis.wav', cross_synth_audio, fs);
