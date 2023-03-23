function [cross_synth_audio] = cross_synthesis(fs, piano, speech, L, R, M, w, plot)
% Cross-synthesis of two audio signals
% fs: sample rate
% piano: piano signal in time
% speech: modulator signal in time
% L: window size
% R: hop size
% M: number of coefficients
% w: window coefficients
% plot: if true, will generate spectrograms
% returns the cross-synthesized audio signal

% ========== Framing the signals ==========

piano_frames = get_signal_frames(piano, L, R, w);
speech_frames = get_signal_frames(speech, L, R, w);

% ========== Transforming to the discrete Fourier domain ==========

% to prevent time-domain aliasing, make nfft size double the window size
NFFT = L*2; % convolution length of two length-L signals, the whitening filter and windowed signal

piano_stft = stft(piano, 'Window', w, 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');
speech_stft = stft(speech, 'Window', w, 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');

if plot
    plot_stft(piano_stft, fs, R, "piano", true);
    plot_stft(speech_stft, fs, R, "speech", true);
end

% ========== Whitening the piano ==========

% Performing LPC analysis of the piano frames
piano_shaping_filters = get_shaping_filters(piano_frames, M, NFFT, false);

% Computing whitening filter (inverse of the shaping filter)
piano_whitening_filters = 1./piano_shaping_filters;

% Applying whitening filter
piano_stft = piano_stft.*piano_whitening_filters;

if plot
    plot_stft(piano_stft, fs, R, "piano prediction error", true);
end

% ========== Applying shaping filter to the piano ==========

% Performing LPC analysis of modulator frames
modulator_shaping_filters = get_shaping_filters(speech_frames, M, NFFT, false);
% We obtain modulator spectral envelops (modulator shaping filter)

% The piano is filtered through the shaping filter of the modulator
% We multiply each piano spectral frame by modulator spectral envelops
cross_synth_stft = piano_stft .* modulator_shaping_filters;

if plot
    plot_stft(cross_synth_stft, fs, R, "talking instrument", true);
end

% Go back to time domain
cross_synth_audio = istft(cross_synth_stft, 'Window', w, 'FFTLength', NFFT, 'OverlapLength', R, 'FrequencyRange','twosided');
end
