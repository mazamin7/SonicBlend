function plt_spec = plot_spectrogram(stft, fs, R, title, colorbar)
% plot spectrogram of stft

    figure('Position', [100 100 1000 500])
    L = size(stft, 1);
    num_frames = size(stft, 2);
    
    % we only look at FFT freq up to nyquist limit fs/2, and normalize out imag components
    stft_db = 20*log10(abs(stft(1:L/2, :))*2);
    plt_spec = imagesc(stft_db);
    set(gca, 'YDir', 'normal');

    % create ylim
    num_yticks = 10;
    ks = linspace(0, L/2, num_yticks);
    ks_hz = ks * fs / L;
    yticks(ks)
    yticklabels(string(round(ks_hz,2)))
    ylabel("Frequency (Hz)")

    % create xlim
    num_xticks = 10;
    ts_spec = linspace(0, num_frames, num_xticks);
    ts_spec_sec = string(linspace(0, (R*num_frames)/fs, num_xticks), '%4.2f');
    xticks(ts_spec);
    xticklabels(ts_spec_sec);
    xlabel("Time (sec)")

    title_str = sprintf('%s L=%d hopsize=%d, fs=%d Spectrogram.shape=%dx%d', title, L, R, fs, size(stft));
    title(title_str)
    if colorbar
        colorbar('Location', 'eastoutside')
    end
end
