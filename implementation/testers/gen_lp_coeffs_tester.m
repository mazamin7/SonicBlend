clear all, close all, clc;

addpath ../library

% Generate random input signal
x = rand(1,randi([100,200]));
M = randi([10,20]);

% Calculate lpc using "lpc"
lpc1 = lpc(x, M);

% Calculate lpc using custom function (matrix inversion)
lpc2 = gen_lp_coeffs(x, M);

% Calculate lpc using custom function (gradient descent)
rx = xcorr(x, M, 'biased');
N = length(rx);
rx = N * rx(M+1:end)';
R = toeplitz(rx);

% coeffs = linsolve(R, -1*rx(2:end));
% coeffs = R \ rx;
coeffs = linsolve(R(2:end,2:end), rx(2:end));
lpc3 = [1, -coeffs'];

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
