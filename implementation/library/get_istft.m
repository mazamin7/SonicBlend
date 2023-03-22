function [signal] = get_istft(x_stft, R)
    % Performs Overlap-Add reconstruction of original signal
    nfft = size(x_stft, 1);  % size of the FFT
    num_frames = size(x_stft, 2);  % number of FFT windows
    signal = zeros((R * (num_frames - 1)) + nfft, 1);

    for m = 1:num_frames
        idx = (m-1)*R + 1;
        windowed_signal = ifft(fftshift(x_stft(:, m)));
        windowed_signal = real(windowed_signal(:));
        signal(idx:idx+nfft-1) = signal(idx:idx+nfft-1) + windowed_signal;
    end
end