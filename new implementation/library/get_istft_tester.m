clear all, close all, clc;

% Read test audio file
[x, Fs] = audioread('modulator.wav');
x = x';
win_length = 128;
overlap = 64;
w = bartlett(win_length);
X1 = stft(x, 'Window', w, 'FFTLength', win_length, 'OverlapLength', overlap);
xw = get_windowed_signal(x, win_length, overlap, w);
X2 = get_stft(xw, win_length);

% Calculate iSTFT using "istft" function
istft1 = istft(X1, 'OverlapLength', overlap);

% Calculate iSTFT using custom function
istft2 = get_istft(X2, overlap);

% Plot original signal and istft1 and istft2
t = 0:1/Fs:(length(x)-1)/Fs;
figure;
subplot(3,1,1);
plot(t,x);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');

t = 0:1/Fs:(length(istft1)-1)/Fs;
subplot(3,1,2);
plot(t,istft1);
xlabel('Time (s)');
ylabel('Amplitude');
title('iSTFT using "istft" function');

t = 0:1/Fs:(length(istft2)-1)/Fs;
subplot(3,1,3);
plot(t,istft2);
xlabel('Time (s)');
ylabel('Amplitude');
title('iSTFT using custom function');

% Compare results
% tolerance = 0.01; % 1% tolerance
% if all(abs(istft1 - istft2) <= tolerance*abs(istft1) & sign(istft1)==sign(istft2))
%     disp('PASS')
% else
%     disp('FAIL')
% end
