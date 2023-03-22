clear all, close all, clc;

% Load the audio signals
[x_car, Fs_car] = audioread('piano.wav');
[x_mod, Fs_mod] = audioread('speech.wav');

% Truncate both signals to the minimum length
min_len = min(length(x_car), length(x_mod));
x_car = x_car(1:min_len);
x_mod = x_mod(1:min_len);

% Resample both signals to the minimum sampling frequency
Fs = min(Fs_car, Fs_mod);
x_car_resampled = resample(x_car, Fs, Fs_car);
x_mod_resampled = resample(x_mod, Fs, Fs_mod);

frame_dur = 0.03;

win_length = 2 * round(frame_dur * Fs * 0.5);
overlap = win_length / 2;
w = bartlett(win_length);
p = 32; % order of linear predictor

% Calculate lpc using "lpc"
[cross_synth_stft, cross_synth_audio] = cross_synthesis(Fs, x_car, x_mod, win_length, overlap, p, false, w, true);

cross_synth_audio = cross_synth_audio / max(abs(cross_synth_audio)) * 0.8;

% Save the cross-synthesis result to a WAV file
audiowrite('cross_synthesis.wav', cross_synth_audio, Fs);

