clear all, close all, clc;

addpath ../library

% Read test audio file
[x, Fs] = audioread('modulator.wav');

% Define window size and hop size
L = 256;
R = L / 2;
w = get_bartlett(L);

% Calculate windowed signal using old custom function
x_win1 = get_windowed_signal_old(x, L, R, w);

% Calculate windowed signal using custom function
x_win2 = get_windowed_signal(x, L, R, w);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(x_win1 - x_win2) <= tolerance*abs(x_win1) & sign(x_win1)==sign(x_win2))
    disp('PASS')
else
    disp('FAIL')
end
