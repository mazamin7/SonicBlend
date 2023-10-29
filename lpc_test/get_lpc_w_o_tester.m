clear all, close all, clc;

% ==================== Description of the script ==========================

% This script compares the results obtained with the Wiener-Hopf equations
% and Gradient Descent method with the one obtained with the lpc MATLAB
% built in function

addpath ..\library\

% ========== Computation of lpc using the three different methods ==========

% Generate random input signal
x = rand(1,randi([1000,2000]));
M = randi([10,20]);

% Calculate lpc using "lpc"
lpc1 = lpc(x, M);
lpc1 = -lpc1(2:end)';

% Calculate lpc using custom function (matrix inversion)
tic;
lpc2 = get_lpc_w_o(x, M);
elapsedTime = toc;

disp(['Wiener-Hopf method - Elapsed time: ' num2str(elapsedTime) ' seconds']);

% Calculate lpc using custom function (gradient descent)
tic;
[lpc3,num_iter] = get_lpc_w_o_gd(x, M, 1e-4, 1e6, true, zeros(M,1));
elapsedTime = toc;

disp(['Gradient descent method - Elapsed time: ' num2str(elapsedTime) ' seconds']);
disp(['Gradient descent method - Iterations: ' num2str(num_iter)]);

% ========== Comparison of the results ==========

% Compare results
tolerance = 1e-3; % 1% tolerance
if all(abs(lpc1 - lpc2) <= tolerance*abs(lpc1) & sign(lpc1)==sign(lpc2))
    disp('Wiener-Hopf method - PASS')
else
    disp('Wiener-Hopf method - FAIL')
end


% Compare results
if all(abs(lpc1 - lpc3) <= tolerance*abs(lpc1) & sign(lpc1)==sign(lpc3))
    disp('Gradient descent method - PASS')
else
    disp('Gradient descent method - FAIL')
end
