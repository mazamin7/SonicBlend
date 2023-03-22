clear all, close all, clc;

% Generate random input signal
rx = rand(1,randi([10,20]));
M = length(rx);

% Calculate STFT using "stft" function
stft1 = stft(rx, M)';

% Calculate STFT using custom function
stft2 = get_stft(rx, M);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(stft1 - stft2) <= tolerance*abs(stft1) & sign(stft1)==sign(stft2))
    disp('PASS')
else
    disp('FAIL')
end
