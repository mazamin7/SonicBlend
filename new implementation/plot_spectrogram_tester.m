clear all, close all, clc;

% Read test audio file
[x, Fs] = audioread('modulator.wav');
x = x';
win_length = 128;
overlap = 64;
w = bartlett(win_length);
X1 = stft(x, 'Window', w, 'FFTLength', win_length, 'OverlapLength', overlap);
% xw = get_windowed_signal(x, win_length, overlap, w);
% X2 = get_stft(xw, win_length);

% Plot STFT using built in "imagesc" function
figure;
imagesc(abs(X1(1:win_length/2,:)));
title('Plot STFT using "imagesc" function');

% Plot STFT using custom function
title_str = 'Plot STFT using custom function';
plot_spectrogram(X1, Fs, overlap, title_str, true)

% Compare results
% tolerance = 0.01; % 1% tolerance
% if all(abs(istft1 - istft2) <= tolerance*abs(istft1) & sign(istft1)==sign(istft2))
%     disp('PASS')
% else
%     disp('FAIL')
% end
