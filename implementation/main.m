clear all; close all; clc;

addpath library

%============== Imports and Load Audio ===============%

% Load audio files
[modulator, fs_mod] = audioread('modulator.wav');
[carrier, fs_car] = audioread('organ_carrier.wav');

% Make sure files are the same sampling rate
fs = min(fs_mod, fs_car);
modulator = resample(modulator, fs, fs_mod);
carrier = resample(carrier, fs, fs_car);

% Trim carrier and modulator to same length
carrier = carrier(1:min(length(modulator), length(carrier)));
modulator = modulator(1:min(length(modulator), length(carrier)));

if(~iscolumn(carrier))
    carrier = carrier';
end

if(~iscolumn(modulator))
    modulator = modulator';
end

% If there are two channels, just use one
if size(carrier,2) > 1
    carrier = carrier(:,1);
end

if size(modulator,2) > 1
    modulator = modulator(:,1);
end

% Normalize signals
carrier = carrier./max(abs(carrier));
modulator = modulator./max(abs(modulator));

% Set parameters
L = 1024;
R = L/2;
NFFT = L*2;
w = bartlett(L);
M = 32;

% ========== CROSS-SYNTHESIS ==========

% Calculate lpc using "lpc"
cross_synth_audio = cross_synthesis(fs, carrier, modulator, L, R, M, w, true, false);
disp("Done");

% Normalize the signal
cross_synth_audio = cross_synth_audio / max(abs(cross_synth_audio)) * 0.8;

% Save the cross-synthesis result to a WAV file
audiowrite('cross_synthesis.wav', cross_synth_audio, fs);
