clear all, close all, clc;

% Generate random input signal
rx = rand(1,10);
M = length(rx);

% Calculate toeplitz matrix using "toeplitz"
toeplitz1 = toeplitz(rx);

% Calculate toeplitz matrix using custom function
toeplitz2 = gen_toeplitz(rx, M);

% Compare results
if isequal(toeplitz1, toeplitz2)
    disp('PASS')
else
    disp('FAIL')
end
