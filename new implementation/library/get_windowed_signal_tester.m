clear all, close all, clc;

% Generate random input signal
x = rand(1, 1024);

% Define window size and hop size
L = 256;
R = 128;
w = hamming(L);

% Calculate windowed signal using built-in function
% NO BUILT-IN FUNCTION

% Calculate windowed signal using custom function
x_win2 = get_windowed_signal(x, L, R, w);

% Compare results
% tolerance = 0.01; % 1% tolerance
% if all(abs(x_win1 - x_win2) <= tolerance*abs(x_win1) & sign(x_win1)==sign(x_win2))
%     disp('PASS')
% else
%     disp('FAIL')
% end
