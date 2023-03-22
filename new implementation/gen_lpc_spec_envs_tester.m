clear all, close all, clc;

% Read test audio file
[x, Fs] = audioread('modulator.wav');
x = x';

win_length = 256;
overlap = win_length / 2;
NFFT = win_length * 2;
w = bartlett(win_length);

xw = get_windowed_signal(x, win_length, overlap, w);

p = 6; % order of linear predictor

% Calculate lpc using "lpc"
lpc_spec_envs = gen_lpc_spec_envs(xw, p, NFFT);
