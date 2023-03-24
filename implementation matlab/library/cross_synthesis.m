function [cross_synth_audio] = cross_synthesis(fs, piano, speech, L_piano, R_piano, M_piano, L_speech, R_speech, M_speech, w_fun, plot_do)
% Cross-synthesis of two audio signals
% fs: sample rate
% piano: piano signal in time
% speech: speech signal in time
% L: window size
% R: hop size
% M: number of coefficients
% w: window coefficients
% plot: if true, will generate spectrograms
% returns the cross-synthesized audio signal

% ========== Framing the signals ==========

piano_frames = get_signal_frames(piano, L_piano, R_piano, w_fun);
speech_frames = get_signal_frames(speech, L_piano, R_speech, w_fun);

% ========== Transforming to the discrete Fourier domain ==========

% to prevent time-domain aliasing, make nfft size double the window size
% convolution length of two length-L signals, the whitening filter and windowed signal
NFFT_piano = L_piano*2;
NFFT_speech = L_speech*2;

piano_stft = stft(piano, 'Window', w_fun(L_piano), 'FFTLength', NFFT_piano, 'OverlapLength', R_piano, 'FrequencyRange','twosided');
speech_stft = stft(speech, 'Window', w_fun(L_speech), 'FFTLength', NFFT_speech, 'OverlapLength', R_speech, 'FrequencyRange','twosided');

if plot_do
    plot_stft(piano_stft, fs, R_piano, "piano", true);
    plot_stft(speech_stft, fs, R_speech, "speech", true);
end

% ========== Whitening the piano ==========

% Performing LPC analysis of the piano frames
piano_shaping_filters = get_shaping_filters(piano_frames, M_piano, NFFT_piano, false);

% Computing whitening filter (inverse of the shaping filter)
piano_whitening_filters = 1./piano_shaping_filters;

% Applying whitening filter
piano_stft = piano_stft.*piano_whitening_filters;

if plot_do
    plot_stft(piano_stft, fs, R_piano, "piano prediction error", true);
end

% ========== Applying shaping filter to the piano ==========

% Performing LPC analysis of speech frames
speech_shaping_filters = get_shaping_filters(speech_frames, M_speech, NFFT_speech, false);
% We obtain speech spectral envelops (speech shaping filter)

% The piano is filtered through the shaping filter of the speech
% We multiply each piano spectral frame by speech spectral envelops
cross_synth_stft = piano_stft .* speech_shaping_filters;

if plot_do
    plot_stft(cross_synth_stft, fs, R_piano, "talking instrument", true);
end

% Go back to time domain
cross_synth_audio = istft(cross_synth_stft, 'Window', w_fun(L_piano), 'FFTLength', NFFT_piano, 'OverlapLength', R_piano, 'FrequencyRange','twosided');

end