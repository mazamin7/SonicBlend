clear all, close all, clc;

addpath ../library

% Generate random input signal
rx = rand(1,randi([100,150]));
N = length(rx);
M = randi([10,15]);

% Calculate autocorrelation using "xcorr"
autocorr1 = xcorr(rx, M, 'biased');
autocorr1 = N * autocorr1(M+1:end);

% Calculate autocorrelation using custom function
autocorr2 = gen_autocorrelates(rx, M);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(autocorr1 - autocorr2) <= tolerance*autocorr1)
    disp('PASS')
else
    disp('FAIL')
end
