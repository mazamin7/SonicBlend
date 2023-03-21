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
[x, Fs] = audioread('speech.wav');
% length of the source signal x
N_x = length(x);

lim1 = Fs/1000;
lim2 = Fs/1000 + 4;

%% Parameters
% number of filter taps
p = floor(lim2);

% segments of 20 ms length
M = round(0.02 * Fs);

n_seg = ceil(N_x / M);

x_seg = zeros(M,1);

for n = 1 : n_seg

    x_seg = x((n-1)*M + 1 : n*M);

end


%% Wiener-Hopf solution
% Compute the autocorrelation matrix

% Compute an estimate of the autocorrelation of the input signal
[r_ac, r_lags] = xcorr(x,'normalized');
    
% Build auto-correlation matrix
r_ac = r_ac(r_lags >= 0); % Take positive lags 0,...,p
r_ac = r_ac(1:M); % normalizing with the length of the source signal 

R = toeplitz(r_ac); % Create Toeplitz matrix from vector
%A Toeplitz matrix is a diagonal-constant matrix, which means all elements along a diagonal have the same value

% Estimation of the cross-correlation between the input signal and the desired response y
% The input and the desired response are the same, thus we still use the
% autocorrelation

% compute the Wiener-Hopf solution
w_o = R\r_ac;

disp('Wiener-filter solution:');
disp(w_o);