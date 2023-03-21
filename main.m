clc; clear; close all;

%% Your name(s), student ID number(s)
%-------------------------------------------------------------------------%
% 
%-------------------------------------------------------------------------%

%% Here are some MATLAB function that you might find useful:
% audioread, soundsc, flipud, fliplr, xcorr, eig, eigs, filter, toeplitz,
% fft, ifft, pause, disp, ...

%% Read the wav files
% load the speech signal x
[d_speech, Fs] = audioread('speech.wav');
[d_piano, Fs] = audioread('piano.wav');
% length of the source signal x
N = length(d_speech);

lim1 = Fs/1000;
lim2 = Fs/1000 + 4;

%% Parameters
% number of filter taps
p = floor(lim2);

% segments of 20 ms length
M = round(0.02 * Fs);

p = M; % check if it's correct

n_seg = floor(N / M);

d_speech_seg = zeros(M,1);

w_whitening_o = zeros(M,1);
w_piano_o = zeros(M,1);

for n = 1 : n_seg

    white_noise = randn(M,1);
    d_speech_seg = d_speech((n-1)*M + 1 : n*M);

    % Compute an estimate of the autocorrelation of the input signal
    [r_ac, r_lags] = xcorr(white_noise,'normalized');
        
    % Build auto-correlation matrix
    r_ac = r_ac(r_lags >= 0); % Take positive lags 0,...,p
    r_ac = r_ac(1:M); % normalizing with the length of the source signal 
    
    R = toeplitz(r_ac); % Create Toeplitz matrix from vector
    %A Toeplitz matrix is a diagonal-constant matrix, which means all elements along a diagonal have the same value
    
    % Estimation of the cross-correlation between the input signal and the desired response y
    [p_cc, p_lags] = xcorr(white_noise,d_speech_seg); % check if we need to normalize
    p_cc = flipud(p_cc);
    % Build cross-correlation matrix
    p_cc = p_cc(p_lags >= 0); % Take positive lags 0,...,p
    
    % compute the cross-correlation vector
    p = p_cc(1:M); % normalizing with the length of the desired signal
    
    % compute the Wiener-Hopf solution
    w_whitening_o = R\p_cc;

    %%%%%%%

    d_piano_seg = d_speech((n-1)*M + 1 : n*M);

    % Compute an estimate of the autocorrelation of the input signal
    [r_ac, r_lags] = xcorr(d_piano_seg,'normalized');
        
    % Build auto-correlation matrix
    r_ac = r_ac(r_lags >= 0); % Take positive lags 0,...,p
    r_ac = r_ac(1:M); % normalizing with the length of the source signal 
    
    R = toeplitz(r_ac); % Create Toeplitz matrix from vector
    %A Toeplitz matrix is a diagonal-constant matrix, which means all elements along a diagonal have the same value
    
    % Estimation of the cross-correlation between the input signal and the desired response y
    % desired = input
    
    % compute the Wiener-Hopf solution
    w_piano_o = R\r_ac;

end
