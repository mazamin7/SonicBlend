clear all, close all, clc;

addpath ../library

% Generate random input signal
M = randi([5,15]);

% Calculate window using "toeplitz"
window1 = hamming(M);

% Calculate window using custom function
window2 = get_hamming(M);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(window1 - window2) <= tolerance*window1)
    disp('PASS')
else
    disp('FAIL')
end
