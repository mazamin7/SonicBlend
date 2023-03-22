clear all, close all, clc;

% Generate random input signal
rx = rand(1,randi([10,20]));
M = length(rx);

% Calculate lpc using "lpc"
lpc1 = lpc(rx, M)';

% Calculate lpc using custom function
lpc2 = gen_lp_coeffs(rx, M);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(lpc1 - lpc2) <= tolerance*abs(lpc1) & sign(lpc1)==sign(lpc2))
    disp('PASS')
else
    disp('FAIL')
end

