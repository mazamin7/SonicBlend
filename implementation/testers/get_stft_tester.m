clear all, close all, clc;

addpath ../library

% Read test audio file
[x, Fs] = audioread('modulator.wav');

% Define window length and overlap
win_length = 128;
overlap = 64;
w = bartlett(win_length);

% Calculate STFT using "stft" function
stft1 = stft(x, 'Window', w, 'FFTLength', win_length, 'OverlapLength', overlap);

% Calculate STFT using custom function
x = get_windowed_signal(x, win_length, overlap, w);
stft2 = get_stft(x, win_length);

% Plot STFTs
figure;
subplot(211);
imagesc(abs(stft1));
title('STFT using "stft" function');
subplot(212);
imagesc(abs(stft2));
title('STFT using custom function');

% Compare results
% tolerance = 0.01; % 1% tolerance
% if all(abs(stft1 - stft2) <= tolerance*abs(stft1) & sign(stft1)==sign(stft2))
%     disp('PASS')
% else
%     disp('FAIL')
% end
