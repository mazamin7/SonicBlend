clear all, close all, clc;

% Generate random input signal
rx = rand(1,10);
M = length(rx);

% Calculate autocorrelation using "xcorr"
autocorr1 = xcorr(rx, M, 'biased');
autocorr1 = M * autocorr1(M+1:end)';

% Calculate autocorrelation using custom function
autocorr2 = gen_autocorrelates(rx, M);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(autocorr1 - autocorr2) <= tolerance*autocorr1)
    disp('PASS')
else
    disp('FAIL')
end
