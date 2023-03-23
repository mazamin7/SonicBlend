clear all; close all; clc;

addpath library

%============== Imports and Load Audio ===============%

% Load audio files
% [speech, fs_speech] = audioread('modulator.wav');
% [piano, fs_piano] = audioread('organ_carrier.wav');
[speech, fs_speech] = audioread('speech.wav');
[piano, fs_piano] = audioread('piano.wav');

% Make sure files are the same sampling rate
fs = min(fs_speech, fs_piano);
speech = resample(speech, fs, fs_speech);
piano = resample(piano, fs, fs_piano);

% Trim piano and speech to same length
piano = piano(1:min(length(speech), length(piano)));
speech = speech(1:min(length(speech), length(piano)));

if(~iscolumn(piano))
    piano = piano';
end

if(~iscolumn(speech))
    speech = speech';
end

% If there are two channels, just use one
if size(piano,2) > 1
    piano = piano(:,1);
end

if size(speech,2) > 1
    speech = speech(:,1);
end

% Normalize signals
piano = piano./max(abs(piano));
speech = speech./max(abs(speech));

% Set parameters
L = 512;         % window length
R = L/2;          % hop size
NFFT = L*2;       % number of bins
w = bartlett(L);  % window 
M = 64;           % lpc order

% ========== CROSS-SYNTHESIS ==========

% Calculate lpc using "lpc"
talking_instrument = cross_synthesis(fs, piano, speech, L, R, M, w, false);
clc;
disp("Done");

% Normalize the signal
talking_instrument = talking_instrument / max(abs(talking_instrument)) * 0.8;

% Save the cross-synthesis result to a WAV file
audiowrite('talking_instrument.wav', talking_instrument, fs);
