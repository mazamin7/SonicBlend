%==============Imports and Load Audio===============%
clear; clc;
close all;

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

% If there are two channels, just use one
if size(carrier,2) > 1
    carrier = carrier(:,1);
end
if size(modulator,2) > 1
    modulator = modulator(:,1);
end

% Normalize signals
carrier = carrier./max(carrier);
modulator = modulator./max(modulator);

disp(length(carrier));
disp(length(modulator));

% ==========Visualize LPC envelope on first frame of modulator===========

N = 256;
nfft = N*2;
frame = 19;
freq_spec = (0:(nfft/2)-1)*fs/nfft;

windowed_modulator = get_windowed_signal(modulator, N, N, @get_bartlett);
modulator_fft = fft(windowed_modulator(:,frame), nfft);
modulator_fft_db = 20*log10(abs(modulator_fft));

figure('Position', [0 0 1200 600]);
plot(freq_spec, modulator_fft_db(1:nfft/2), 'b', 'LineWidth', 2, 'DisplayName', 'Original signal');
hold on;

for M = 6:7
    modulator_spec_envs = gen_lpc_spec_envs(windowed_modulator, M, nfft);
    plot(freq_spec, 20*log10(abs(modulator_spec_envs(:, frame))), 'DisplayName', ['Spec env M=' num2str(M)]);
end

grid on;
legend('Location', 'northwest');
title('db vs frequency');
xlabel('Frequency (Hz)');
ylabel('db');
