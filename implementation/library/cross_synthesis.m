function [cross_synth_audio] = cross_synthesis(fs, carrier, modulator, L, R, M, w, flatten, plot)
% Cross-synthesis of two audio signals
% fs: sample rate
% carrier: carrier signal in time
% modulator: modulator signal in time
% L: window size
% R: hop size
% M: number of coefficients
% flatten: if true, divide carrier spectrum by its own envelope
% w: window coefficients
% plot: if true, will generate spectrograms
% returns stft of cross-synthesized signal, and cross-synthesized audio signal

% ========== Framing the signals ==========

windowed_carrier = get_windowed_signal(carrier, L, R, w);
windowed_modulator = get_windowed_signal(modulator, L, R, w);

% ========== Transforming to the discrete Fourier domain ==========

% to prevent time-domain aliasing, make nfft size double the window size
nfft = L*2; % convolution length of two length-L signals, the whitening filter and windowed signal

carrier_stft = stft(carrier, 'Window', w, 'FFTLength', nfft, 'OverlapLength', R, 'FrequencyRange','twosided');
modulator_stft = stft(modulator, 'Window', w, 'FFTLength', nfft, 'OverlapLength', R, 'FrequencyRange','twosided');

if plot
    plot_spectrogram(carrier_stft, fs, R, "original carrier", true);
    plot_spectrogram(modulator_stft, fs, R, "modulator", true);
end

% ========== Whitening the carrier ==========

% Optional: divide spectrum of carrier frame by its own envelope
if flatten

    % Performing LPC analysis of carrier frames
    carrier_spec_envs = gen_lpc_spec_envs(windowed_carrier, M, nfft);
    
    % Applying whitening filter (inverse of shaping filter)
    carrier_stft = carrier_stft ./ carrier_spec_envs;

    if plot
        plot_spectrogram(carrier_stft, fs, R, "flattened carrier", true);
    end
end

% ========== Applying shaping filter to the carrier ==========

% Performing LPC analysis of modulator frames
modulator_spec_envs = gen_lpc_spec_envs(windowed_modulator, M, nfft);
% We obtain modulator spectral envelops (modulator shaping filter)

% The carrier is filtered through the shaping filter of the modulator
% We multiply each carrier spectral frame by modulator spectral envelops
cross_synth_stft = carrier_stft .* modulator_spec_envs;

if plot
    plot_spectrogram(cross_synth_stft, fs, R, "cross-synthesized carrier", true);
end

% Go back to time domain
cross_synth_audio = istft(cross_synth_stft, 'Window', w, 'FFTLength', nfft, 'OverlapLength', R, 'FrequencyRange','twosided');

end
