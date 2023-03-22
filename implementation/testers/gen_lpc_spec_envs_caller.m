clear all, close all, clc;

addpath ../library

% Read test audio file
[x, Fs] = audioread('modulator.wav');
x = x';

% Define window size and hop size
L = 256;
R = L / 2;
NFFT = 2 * L;
w = bartlett(L);

xw = get_windowed_signal(x, L, R, w);

p = 6; % order of linear predictor

% Calculate lpc using "lpc"
lpc_spec_envs = gen_lpc_spec_envs(xw, p, NFFT);
