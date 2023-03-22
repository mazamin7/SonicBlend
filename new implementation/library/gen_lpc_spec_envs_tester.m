clear all, close all, clc;

% Read test audio file
[x, Fs] = audioread('modulator.wav');
x = x';
win_length = 128;
overlap = 64;
w = bartlett(win_length);
xw = get_windowed_signal(x, win_length, overlap, w);
p = 12; % order of linear predictor

% Calculate lpc using "lpc"
lpc_spec_envs = gen_lpc_spec_envs(xw, p, win_length);
