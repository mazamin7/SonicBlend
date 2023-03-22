function plt_spec = plot_spectrogram(x_stft, fs, R, title_str, colorbar_do)
% plot spectrogram of stft
L = size(x_stft, 1);
num_frames = size(x_stft, 2);
% we only look at FFT freq up to nyquist limit fs/2, and normalize out imag components
stft_db = 20*log10(abs(x_stft(1:L/2, :))*2);

figure('Units', 'pixels', 'Position', [100, 100, 1000, 500]);
imagesc(stft_db);
set(gca, 'YDir', 'normal');

% create ylim
num_yticks = 10;
ks = linspace(0, L/2, num_yticks);
ks_hz = ks * fs / L;
set(gca, 'YTick', ks, 'YTickLabel', num2str(ks_hz', '%4.2f'));
ylabel('Frequency (Hz)');

% create xlim
num_xticks = 10;
ts_spec = linspace(0, num_frames, num_xticks);
ts_spec_sec  = num2str(linspace(0, (R*num_frames)/fs, num_xticks)', '%4.2f');
set(gca, 'XTick', ts_spec, 'XTickLabel', ts_spec_sec);
xlabel('Time (sec)');

% set title
title_arg = sprintf('%s L=%d hopsize=%d, fs=%d Spectrogram.shape=%dx%d', title_str, L, R, fs, size(x_stft));
title(title_arg);

% add colorbar
if colorbar_do
    colorbar('Location', 'eastoutside');
end

plt_spec = gca;

end