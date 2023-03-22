clc; clear; close all;

%% Your name(s), student ID number(s)
%-------------------------------------------------------------------------%
% 
%-------------------------------------------------------------------------%

%% Here are some MATLAB function that you might find useful:
% audioread, soundsc, flipud, fliplr, xcorr, eig, eigs, filter, toeplitz,
% fft, ifft, pause, disp, ...

%% Read the wav files
% load the speech signal x
[x, Fs] = audioread('speech.wav');

% x = x(1:2*Fs);

% Set the frame size and overlap
frame_size = 0.03 * Fs; % 30 ms
overlap = 0; % 50%

% Split the signal into frames with overlap
frames = buffer(x, frame_size, round(frame_size * overlap), 'nodelay');

num_frames = size(frames, 2);

x_new = zeros(frame_size*num_frames,1);
x_new(1:length(x)) = x;
x = x_new;

p = 12;

% Preallocate variables
lpc_coeffs = zeros(num_frames, p);
residuals = zeros(size(frames));
residuals = residuals';

% Iterate over the frames and compute LPC coefficients and residuals
for i = 1:num_frames
    % Calculate autocorrelation coefficients using xcorr
    [rxx, lags] = xcorr(frames(:, i));
    rxx = rxx(lags >= 0); % Keep only positive lags
    
    % Compute LPC coefficients using the autocorrelation method
    R = toeplitz(rxx(1:p-1));
    a = R \ rxx(2:p);
    lpc_coeffs(i, :) = [1; -a];
    
    % Compute the predicted values and residuals for the frame
    y_pred = filter([0 -a'], 1, frames(:, i));
    residuals(i, :) = frames(:, i) - y_pred;

    clc;
    disp(['completion step 1: ' num2str(i) ' out of ' num2str(num_frames)])
end

% Reshape the residuals into a column vector
% residuals = reshape(residuals, [], 1);

y_lpc = zeros(size(x));

% Synthesize the signal using the LPC coefficients
y_lpc(1:frame_size) = filter(1, lpc_coeffs(1, :), residuals(1, :));

for i = 2:num_frames
    y_lpc((i-1)*frame_size+1:i*frame_size) = filter(1, lpc_coeffs(i, :), residuals(i, :));

    clc;
    disp(['completion step 2: ' num2str(i) ' out of ' num2str(num_frames)])
end

y_lpc = y_lpc/max(abs(y_lpc));

residuals = reshape(residuals, [], 1);

% Plot the original signal and the LPC synthesis signal
t = (0:length(x)-1)/Fs; % Time vector
subplot(3,1,1);
plot(t, x);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(3,1,2);
plot(t, y_lpc);
title('LPC Synthesis Signal');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(3,1,3);
plot(t, residuals);
title('Residual');
xlabel('Time (s)');
ylabel('Amplitude');

audiowrite('speech_reconstructed.wav',y_lpc,Fs);