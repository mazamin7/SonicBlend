clear all, close all, clc;

addpath ..\library\

% Generate random input signal
x = rand(1,randi([1000,2000]));
M = randi([10,20]);

% Calculate lpc using "lpc"
lpc1 = lpc(x, M);
lpc1 = -lpc1(2:end)';

% Calculate lpc using custom function (matrix inversion)
tic;
lpc2 = get_lpc_w_o(x, M);
elapsedTime1 = toc;

disp(['Matrix inversion method - Elapsed time: ' num2str(elapsedTime1) ' seconds']);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(lpc1 - lpc2) <= tolerance*abs(lpc1) & sign(lpc1)==sign(lpc2))
    disp('Matrix inversion method - PASS')
else
    disp('Matrix inversion method - FAIL')
end

% Calculate lpc using custom function (gradient descent)
tic;
[lpc3,num_iter] = get_lpc_w_o_gd(x, M, 1e-4, 1e4);
elapsedTime2 = toc;

disp(['Gradient descent method - Elapsed time: ' num2str(elapsedTime2) ' seconds']);
disp(['Gradient descent method - Iterations: ' num2str(num_iter)]);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(lpc1 - lpc3) <= tolerance*abs(lpc1) & sign(lpc1)==sign(lpc3))
    disp('Gradient descent method - PASS')
else
    disp('Gradient descent method - FAIL')
end
