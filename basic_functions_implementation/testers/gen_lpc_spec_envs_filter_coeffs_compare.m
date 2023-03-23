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
lpc_freq_resp1 = lpc_spec_envs(:,19);

% Calculate filter frequency response from "gen_lpc_filter_coeffs"
lpc_filter_coeffs = gen_lpc_filter_coefs(xw, p);
coefs = lpc_filter_coeffs(:,19);

% Compute frequency response of LPC filter
[h, w] = freqz(1, coefs, NFFT, 'whole');

% Compute spectral envelope
lpc_freq_resp2 = abs(h);

% x_frame_stft2 = fft(x_frame, NFFT);
y1_stft = x_frame_stft .* lpc_freq_resp1;
y1 = ifft(y1_stft, NFFT);

y2 = filter(1, coefs, x_frame);

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
subplot(211);
plot(freq_spec, lpc_freq_resp1);
hold on;
subplot(212);
plot(freq_spec, lpc_freq_resp2);
sgtitle('Spectral Envelope');
xlabel('Frequency (rad/sample)');
ylabel('Magnitude');

t = 1:length(y1);
figure;
subplot(211);
plot(freq_spec, abs(y1_stft));
hold on;
subplot(212);
plot(freq_spec, abs(fft(y2, NFFT)));
sgtitle('Filtered freq domain signals');
xlabel('Time (samples)');
ylabel('Magnitude');

t = 1:length(y1);
figure;
subplot(211);
plot(t, y1);
hold on;
subplot(212);
plot(t, y2);
sgtitle('Filtered time domain signals');
xlabel('Time (samples)');
ylabel('Magnitude');

