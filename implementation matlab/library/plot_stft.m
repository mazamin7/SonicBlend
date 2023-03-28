function plt_spec = plot_stft(x_stft, fs, L, R, title_str, colorbar_do)
% Plots STFT

num_frames = size(x_stft, 2);
% Plot magnitude spectrum in db
% Consider only relevant frequencies (f < f_nyquist)
stft_db = db(abs(x_stft(1:L/2, :))*2);

figure('Units', 'pixels', 'Position', [100, 100, 1000, 500]);
imagesc(stft_db);
set(gca, 'YDir', 'normal');

% Create y axis
num_yticks = 10;
ks = linspace(0, L/2, num_yticks);
ks_hz = ks * fs / L;
set(gca, 'YTick', ks, 'YTickLabel', num2str(ks_hz', '%4.2f'));
ylabel('Frequency (Hz)');

% Create x axis
num_xticks = 10;
ts_spec = linspace(0, num_frames, num_xticks);
ts_spec_sec  = num2str(linspace(0, (R*num_frames)/fs, num_xticks)', '%4.2f');
set(gca, 'XTick', ts_spec, 'XTickLabel', ts_spec_sec);
xlabel('Time (s)');

% Set title
title_arg = sprintf('%s, L: %d, R: %d, fs=%d, STFT matrix size: %dx%d', title_str, L, R, fs, size(x_stft));
title(title_arg);

% Add colorbar
if colorbar_do
    colorbar('Location', 'eastoutside');
end

plt_spec = gca;

end