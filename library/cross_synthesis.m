function [cross_synth_audio] = cross_synthesis(fs, piano, speech, L_piano, R_piano, M_piano, L_speech, R_speech, M_speech, w_fun, plot_do, gd, error_tolerance, max_num_iter, reuse)
% Cross-synthesis of two audio signals
%
% fs: sample rate
% piano: piano signal in time
% speech: speech signal in time
% L_piano: window size piano
% R_piano: hop size piano
% M_piano: number of coefficients piano
% L_speech: window size speech
% R_speech: hop size speech
% M_speech: number of coefficients speech
% w_fun: window function
% plot_do: if true, will plot the STFT of the signals and the shaping filters
% gd: if true, performs LPC analysis through gradient descent
% error_tolerance: determine the accuracy by setting a threshold
% max_num_iter: max number of iterations for gradient descent
% reuse: (gd only) whether the algorithm should use the w_o of the last
%        frame as initial guess to the w_o of the current frame

% ========== Verifying arguments ==========

% Assert that each L is a power of 2
assert(L_piano == 2^floor(log2(L_piano)), 'L_piano is not a power of 2');
assert(L_speech == 2^floor(log2(L_speech)), 'L_speech is not a power of 2');

% ========== Framing the signals ==========

piano_frames = get_signal_frames(piano, L_piano, R_piano, w_fun, false);
speech_frames = get_signal_frames(speech, L_speech, R_speech, w_fun, false);

% ========== Transforming to the discrete Fourier domain ==========

% NFFT is 2 times the window length to avoid circular convolution
NFFT_piano = L_piano*2;
NFFT_speech = L_speech*2;

piano_stft = stft(piano, 'Window', w_fun(L_piano), 'FFTLength', NFFT_piano, 'OverlapLength', R_piano, 'FrequencyRange','twosided');
speech_stft = stft(speech, 'Window', w_fun(L_speech), 'FFTLength', NFFT_speech, 'OverlapLength', R_speech, 'FrequencyRange','twosided');

if plot_do
    plot_stft(piano_stft, fs, L_piano, R_piano, "piano", true);
    plot_stft(speech_stft, fs, L_speech, R_speech, "speech", true);
end

% ========== Whitening the piano ==========

% Performing LPC analysis of the piano frames
piano_shaping_filters = get_shaping_filters(piano_frames, M_piano, NFFT_piano, gd, error_tolerance, max_num_iter, reuse);

if plot_do
    plot_stft(piano_shaping_filters, fs, L_piano, R_piano, "piano shaping filters", true);
end

% Computing whitening filter (inverse of the shaping filter)
piano_whitening_filters = 1./piano_shaping_filters;

% Applying whitening filter
piano_error_stft = piano_stft.*piano_whitening_filters;

if plot_do
    plot_stft(piano_error_stft, fs, L_piano, R_piano, "piano prediction error", true);
end

% ========== Changing whitened piano resolution ==========

if L_speech ~= L_piano
    piano_error = istft(piano_error_stft, 'Window', w_fun(L_piano), 'FFTLength', NFFT_piano, 'OverlapLength', R_piano, 'FrequencyRange','twosided');
    piano_error_stft = stft(piano_error, 'Window', w_fun(L_speech), 'FFTLength', NFFT_speech, 'OverlapLength', R_speech, 'FrequencyRange','twosided');
end

% ========== Applying shaping filter to the whitened piano ==========

% Performing LPC analysis of speech frames
speech_shaping_filters = get_shaping_filters(speech_frames, M_speech, NFFT_speech, gd, error_tolerance, max_num_iter, reuse);
% We obtain speech spectral envelops (speech shaping filters)

if plot_do
    plot_stft(speech_shaping_filters, fs, L_speech, R_speech, "speech shaping filters", true);
end

% The piano is filtered through the shaping filter of the speech
% We multiply each piano spectral frame by speech spectral envelops
cross_synth_stft = piano_error_stft .* speech_shaping_filters;

if plot_do
    plot_stft(cross_synth_stft, fs, L_speech, R_speech, "talking instrument", true);
end

% Go back to time domain
cross_synth_audio = istft(cross_synth_stft, 'Window', w_fun(L_speech), 'FFTLength', NFFT_speech, 'OverlapLength', R_speech, 'FrequencyRange','twosided');

end
