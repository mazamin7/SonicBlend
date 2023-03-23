clear all, close all, clc;

addpath ../library

% Read test audio file
[x, Fs] = audioread('modulator.wav');
L = 128;
R = 64;
w = bartlett(L);

% Split and reconstruct signal
x_frames = get_windowed_signal(x, L, R, w);
x2 = reverse_windowing(x_frames, L, R, w);

% Plot original signal and istft1 and istft2
t = 0:1/Fs:(length(x)-1)/Fs;
figure;
subplot(3,1,1);
plot(t,x);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');

t = 0:1/Fs:(length(x2)-1)/Fs;
subplot(3,1,2);
plot(t,x2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Reconstructed Signal');

% x = x(1:length(x2));

% Compare results
% tolerance = 0.01; % 1% tolerance
% if all(abs(x - x2) <= tolerance*abs(x) & sign(x)==sign(x2))
%     disp('PASS')
% else
%     disp('FAIL')
% end
