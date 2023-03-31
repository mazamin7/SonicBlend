clear all; close all; clc;

addpath library

% ============== Imports and Load Audio ===============

% Load audio files
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
L_piano = 512;         % window length piano
M_piano = 128;           % lpc order piano

L_speech = 2048;         % window length speech
M_speech = 512;           % lpc order speech

w_fun = @bartlett;          % window type
R_piano = L_piano/2;          % hop size piano
R_speech = L_speech/2;          % hop size speech

use_gradient_descent = false;
error_tolerance = 1e-4; % only has effect for gradient descent
max_num_iter = 1e4; % only has effect for gradient descent
reuse = true; % only has effect for gradient descent

% ========== CROSS-SYNTHESIS ==========

% Calculate lpc using "lpc"
tic;
talking_instrument = cross_synthesis(fs, piano, speech, L_piano, R_piano, M_piano, L_speech, R_speech, M_speech, w_fun, true, use_gradient_descent, error_tolerance, max_num_iter, reuse);
elapsedTime = toc;
clc;
disp(['Done - Elapsed time: ' num2str(elapsedTime)]);

% Normalize the signal
talking_instrument = talking_instrument / max(abs(talking_instrument)) * 0.8;

% Save the cross-synthesis result to a WAV file
audiowrite('talking_instrument.wav', talking_instrument, fs);
