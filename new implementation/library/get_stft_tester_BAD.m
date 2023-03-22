clear all, close all, clc;

% Generate random input signal
x = rand(1, 1024);

% Define window length and overlap
win_length = 128;
overlap = 0;

% Calculate STFT using "stft" function
stft1 = stft(x, 'Window', boxcar(win_length), 'FFTLength', win_length, 'OverlapLength', overlap);

% Calculate STFT using custom function
x = get_windowed_signal(x);
stft2 = get_stft(x, win_length);

% Compare results
tolerance = 0.01; % 1% tolerance
if all(abs(stft1 - stft2) <= tolerance*abs(stft1) & sign(stft1)==sign(stft2))
    disp('PASS')
else
    disp('FAIL')
end
