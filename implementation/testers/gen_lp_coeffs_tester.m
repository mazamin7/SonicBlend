clear all, close all, clc;

addpath ../library

% Generate random input signal
rx = rand(1,randi([10,20]));
M = length(rx);

% Calculate lpc using "lpc"
lpc1 = lpc(rx, M);

% Calculate lpc using custom function (matrix inversion)
lpc2 = gen_lp_coeffs(rx, M);

% Calculate lpc using custom function (gradient descent)
lpc2 = gen_lp_coeffs_gd(rx, M, 1, 100);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(lpc1 - lpc2) <= tolerance*abs(lpc1) & sign(lpc1)==sign(lpc2))
    disp('PASS1')
else
    disp('FAIL1')
end

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(lpc1 - lpc2) <= tolerance*abs(lpc1) & sign(lpc1)==sign(lpc2))
    disp('PASS2')
else
    disp('FAIL2')
end
