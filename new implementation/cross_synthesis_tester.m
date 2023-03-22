clear all, close all, clc;

% Read test audio file
[x_car, ~] = audioread('organ_carrier.wav');
[x_mod, Fs] = audioread('modulator.wav');
x_car = x_car';
x_mod = x_mod';
win_length = 128;
overlap = 64;
w = bartlett(win_length);
p = 12; % order of linear predictor

% Calculate lpc using "lpc"
[cross_synth_stft, cross_synth_audio] = cross_synthesis(Fs, x_car, x_mod, win_length, overlap, p, false, w, true);
