clear all, close all, clc;

addpath ../library
addpath ../

% Read test audio file
[x, Fs] = audioread('modulator.wav');
L = 128;
R = 64;
w = @bartlett;

len_x = length(x);
len_x_round = floor(len_x/R)*R;

x = x(1:len_x_round);

% Split and reconstruct signal
x_frames = get_signal_frames(x, L, R, w, true);
x2 = reverse_windowing(x_frames, L, R);

% Plot original signal and istft1 and istft2
t = 0:1/Fs:(length(x)-1)/Fs;
figure;
subplot(2,1,1);
plot(t,x);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');

t = 0:1/Fs:(length(x2)-1)/Fs;
subplot(2,1,2);
plot(t,x2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Reconstructed Signal');

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(x - x2) <= tolerance*abs(x) & sign(x)==sign(x2))
    disp('PASS')
else
    disp('FAIL')
end
