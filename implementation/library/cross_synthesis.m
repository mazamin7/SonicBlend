function [cross_synth_audio] = cross_synthesis(fs, carrier, modulator, L, R, M, flatten, w, plot, freq_domain)
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

% to prevent time-domain aliasing, make nfft size double the window size
nfft = L*2; % convolution length of two length-L signals, the whitening filter and windowed signal

windowed_carrier = get_windowed_signal(carrier, L, R, w);
windowed_modulator = get_windowed_signal(modulator, L, R, w);

% carrier_stft = get_stft(windowed_carrier, nfft);
carrier_stft = stft(carrier, 'Window', w, 'FFTLength', nfft, 'OverlapLength', R);
% modulator_stft = get_stft(windowed_modulator, nfft);
modulator_stft = stft(modulator, 'Window', w, 'FFTLength', nfft, 'OverlapLength', R);

if plot
    plot_spectrogram(carrier_stft, fs, R, "original carrier", true);
    plot_spectrogram(modulator_stft, fs, R, "modulator", true);
end

% Optional: divide spectrum of carrier frame by its own envelope
if flatten
    carrier_spec_envs = gen_lpc_spec_envs(windowed_carrier, M, nfft);
    carrier_stft = carrier_stft ./ carrier_spec_envs;

    if plot
        plot_spectrogram(carrier_stft, fs, R, "flattened carrier", true);
    end
end

if freq_domain
    % Multiply carrier spectral frame by modulator spectral envelops
    modulator_spec_envs = gen_lpc_spec_envs(windowed_modulator, M, nfft);
    cross_synth_stft = carrier_stft .* modulator_spec_envs;

    if plot
        plot_spectrogram(cross_synth_stft, fs, R, "cross-synthesized carrier", true);
    end
    
    % cross_synth_audio = get_istft(cross_synth_stft, R);
    cross_synth_audio = istft(cross_synth_stft, 'Window', w, 'FFTLength', nfft, 'OverlapLength', R);
else
    modulator_filter_coefs = gen_lpc_filter_coefs(windowed_modulator, M);
    windowed_carrier_filtered = windowed_modulator * 0;

    num_frames = size(windowed_modulator, 2);

    for n = 1:num_frames
        coefs = modulator_filter_coefs(:,n);
        % windowed_modulator_filtered(:,n) = windowed_carrier(:,n); % Not cross-synthesis
        windowed_carrier_filtered(:,n) = filter(1,coefs,windowed_carrier(:,n));
    end

    cross_synth_audio = reverse_windowing(windowed_carrier_filtered, L, R, w);
end

end
