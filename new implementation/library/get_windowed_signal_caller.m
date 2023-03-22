clear all, close all, clc;

% Read test audio file
[x, Fs] = audioread('modulator.wav');
x = x';

% Define window size and hop size
L = 256;
R = L / 2;
w = bartlett(L);

% Calculate windowed signal using built-in function
% NO BUILT-IN FUNCTION

% Calculate windowed signal using custom function
x_win = get_windowed_signal(x, L, R, w);
