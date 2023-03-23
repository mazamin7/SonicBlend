clear all, close all, clc;

addpath ../library

% Generate random input signal
M = randi([5,15]);

% Calculate window using "toeplitz"
window1 = bartlett(M);

% Calculate window using custom function
window2 = get_bartlett(M);

% Compare results
if isequal(window1, window2)
    disp('PASS')
else
    disp('FAIL')
end
