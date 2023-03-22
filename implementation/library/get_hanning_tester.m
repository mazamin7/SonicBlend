clear all, close all, clc;

% Generate random input signal
M = randi([5,15]);

% Calculate window using "toeplitz"
window1 = hanning(M);

% Calculate window using custom function
window2 = get_hanning(M);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(window1 - window2) <= tolerance*window1)
    disp('PASS')
else
    disp('FAIL')
end
