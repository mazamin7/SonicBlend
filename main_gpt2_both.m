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
[x_speech, ~] = audioread('speech.wav');
[x_piano, Fs] = audioread('piano.wav');

%x_speech = x_speech(1:2*Fs);
%x_piano = x_piano(1:2*Fs);

% Set the frame size and overlap
frame_size_speech = 0.03 * Fs; % 30 ms
frame_size_piano = 0.03 * Fs; % 30 ms
overlap = 0; % 50%

% Split the signal into frames with overlap
frames_speech = buffer(x_speech, frame_size_speech, round(frame_size_speech * overlap), 'nodelay');
frames_piano = buffer(x_piano, frame_size_piano, round(frame_size_piano * overlap), 'nodelay');

num_frames_speech = size(frames_speech, 2);
num_frames_piano = size(frames_piano, 2);

% Pad the input signal with zeros
x_speech = padarray(x_speech, [frame_size_speech*num_frames_speech - length(x_speech), 0], 'post');

% Pad the input signal with zeros
x_piano = padarray(x_piano, [frame_size_piano*num_frames_piano - length(x_piano), 0], 'post');

p1 = 12;
p2 = 12;

% Preallocate variables
lpc_coeffs_speech = zeros(num_frames_speech, p1);
residuals_speech = zeros(size(frames_speech));
residuals_speech = residuals_speech';
whitening_coeffs_speech = zeros(num_frames_speech, p1);

lpc_coeffs_piano = zeros(num_frames_piano, p2);
residuals_piano = zeros(size(frames_piano));
residuals_piano = residuals_piano';
whitening_coeffs_piano = zeros(num_frames_piano, p2);

% LPC analysis for speech
% Iterate over the frames and compute LPC coefficients and residuals
for i = 1:num_frames_speech
    % Calculate autocorrelation coefficients using xcorr
    [rxx, lags] = xcorr(frames_speech(:, i));
    rxx = rxx(lags >= 0); % Keep only positive lags
    
    % Compute LPC coefficients using the autocorrelation method
    R = toeplitz(rxx(1:p1-1));
    a = R \ rxx(2:p1);
    lpc_coeffs_speech(i, :) = [1; a];
    whitening_coeffs_speech(i, :) = [1; -a];
    
    % Compute the predicted values and residuals for the frame
    y_pred = filter([0 a'], 1, frames_speech(:, i));
    residuals_speech(i, :) = frames_speech(:, i) - y_pred;

    clc;
    disp(['completion step 1 speech: ' num2str(i) ' out of ' num2str(num_frames_speech)])
end

% LPC analysis for piano
% Iterate over the frames and compute LPC coefficients and residuals
for i = 1:num_frames_piano
    % Calculate autocorrelation coefficients using xcorr
    [rxx, lags] = xcorr(frames_piano(:, i));
    rxx = rxx(lags >= 0); % Keep only positive lags
    
    % Compute LPC coefficients using the autocorrelation method
    R = toeplitz(rxx(1:p2-1));
    a = R \ rxx(2:p2);
    lpc_coeffs_piano(i, :) = [1; a];
    whitening_coeffs_piano(i, :) = [1; -a];
    
    % Compute the predicted values and residuals for the frame
    y_pred = filter([0 a'], 1, frames_piano(:, i));
    residuals_piano(i, :) = frames_piano(:, i) - y_pred;

    clc;
    disp(['completion step 1 piano: ' num2str(i) ' out of ' num2str(num_frames_piano)])
end

% Reshape the residuals into a column vector
% residuals = reshape(residuals, [], 1);



% RESYNTHESIZE SPEECH
y_lpc = zeros(size(x_speech));

% Synthesize the signal using the LPC coefficients
y_lpc(1:frame_size_speech) = filter(1, whitening_coeffs_speech(1, :), residuals_speech(1, :));

for i = 2:num_frames_piano
    y_lpc((i-1)*frame_size_speech+1:i*frame_size_speech) = filter(1, whitening_coeffs_speech(i, :), residuals_speech(i, :));

    clc;
    disp(['completion step 2: ' num2str(i) ' out of ' num2str(num_frames_speech)])
end

y_lpc = y_lpc/max(abs(y_lpc));

% % Plot the original signal and the LPC synthesis signal
% t = (0:length(x_piano)-1)/Fs; % Time vector
% plot(t, y_lpc);
% title('LPC Cross-Synthesis Signal');
% xlabel('Time (s)');
% ylabel('Amplitude');

audiowrite('reconstructed_speech.wav',y_lpc,Fs);



% RESYNTHESIZE PIANO
y_lpc = zeros(size(x_speech));

% Synthesize the signal using the LPC coefficients
y_lpc(1:frame_size_piano) = filter(1, whitening_coeffs_piano(1, :), residuals_piano(1, :));

for i = 2:num_frames_piano
    y_lpc((i-1)*frame_size_piano+1:i*frame_size_piano) = filter(1, whitening_coeffs_piano(1, :), residuals_piano(i, :));

    clc;
    disp(['completion step 2: ' num2str(i) ' out of ' num2str(num_frames_piano)])
end

y_lpc = y_lpc/max(abs(y_lpc));

% % Plot the original signal and the LPC synthesis signal
% t = (0:length(x_piano)-1)/Fs; % Time vector
% plot(t, y_lpc);
% title('LPC Cross-Synthesis Signal');
% xlabel('Time (s)');
% ylabel('Amplitude');

audiowrite('reconstructed_piano.wav',y_lpc,Fs);



% CROSS-SYNTHESIS
y_lpc = zeros(size(x_speech));

% Synthesize the signal using the LPC coefficients
y_lpc(1:frame_size_piano) = filter(1, whitening_coeffs_speech(1, :), residuals_piano(1, :));

for i = 2:num_frames_piano
    y_lpc((i-1)*frame_size_piano+1:i*frame_size_piano) = filter(1, whitening_coeffs_speech(1, :), residuals_piano(i, :));

    clc;
    disp(['completion step 2: ' num2str(i) ' out of ' num2str(num_frames_piano)])
end

y_lpc = y_lpc/max(abs(y_lpc));

% % Plot the original signal and the LPC synthesis signal
% t = (0:length(x_piano)-1)/Fs; % Time vector
% plot(t, y_lpc);
% title('LPC Cross-Synthesis Signal');
% xlabel('Time (s)');
% ylabel('Amplitude');

audiowrite('talking_piano.wav',y_lpc,Fs);