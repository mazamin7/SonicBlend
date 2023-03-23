clear all, close all, clc;

addpath ../library

% Read test audio file
[x, fs] = audioread('modulator.wav');
% x = x';

% Define window size and hop size
L = 256;
R = L / 2;
NFFT = 2 * L;
w = bartlett(L);

xw = get_windowed_signal(x, L, R, w);

p = 32; % order of linear predictor
frame = 19;

x_frame = xw(:,frame);

x_stft = stft(x, 'Window', w, 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');
x_frame_stft = x_stft(:,frame);

freq_spec = (-(NFFT/2):(NFFT/2)-1)*fs/NFFT;

% Calculate filter frequency response from "gen_lpc_spec_envs"
lpc_spec_envs = gen_lpc_spec_envs(xw, p, NFFT);
lpc_freq_resp = lpc_spec_envs(:,19);

% x_frame_stft2 = fft(x_frame, NFFT);
y_stft = x_frame_stft .* lpc_freq_resp;
y = ifft(y_stft, NFFT);

t = 1:length(x_frame);
figure;
plot(t, x_frame);
sgtitle('Original time domain signal');
xlabel('Time (samples)');
ylabel('Magnitude');

figure;
plot(freq_spec, abs(x_frame_stft));
sgtitle('Original freq domain signal');
xlabel('Frequency (samples)');
ylabel('Magnitude');

% Plot spectral envelope
figure;
plot(freq_spec, lpc_freq_resp);
title('Spectral Envelope');
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');

figure;
plot(freq_spec, abs(y_stft));
title('Filtered freq domain signal');
xlabel('Time (samples)');
ylabel('Magnitude');

figure;
plot(t, y);
title('Filtered time domain signal');
xlabel('Time (samples)');
ylabel('Magnitude');

