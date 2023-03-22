function [stft] = get_stft(windowed_signal, nfft)
    % Partitions windowed_signal into windows of length nfft
    % returns: N x M matrix, where N is the FFT size, and M is number of windows
    if nargin < 2
        nfft = size(windowed_signal, 1);
    end
    ms = size(windowed_signal, 2);
    ffts = zeros(nfft, 1);
    for m = 1:ms
        xm = windowed_signal(:, m);
        freq_window = fft(xm, nfft);
        freq_window = freq_window(:);
        ffts = horzcat(ffts, freq_window);
    end
    stft = ffts(:, 2:end);
end