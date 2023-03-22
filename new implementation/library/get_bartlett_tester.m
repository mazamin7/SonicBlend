clear all, close all, clc;

% Generate random input signal
M = randi([5,15]);

% Calculate toeplitz matrix using "toeplitz"
window1 = bartlett(M);

% Calculate toeplitz matrix using custom function
window2 = get_bartlett(M);

% Compare results
if isequal(window1, window2)
    disp('PASS')
else
    disp('FAIL')
end
