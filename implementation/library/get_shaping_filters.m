function [shaping_filters] = get_shaping_filters(framed_signal, M, nfft)
    % windowed_modulator: matrix where each column is a windowed signal
    % M: order of linear predictor
    % nfft: fft size
    %
    % Returns a matrix of spectral envelopes, where column m is spectral envelope for m'th signal frame
    
    num_frames = size(framed_signal, 2);
    shaping_filters = zeros(nfft, num_frames);

    for m = 1:num_frames
        xm = framed_signal(:, m); % get mth column

        % w_o = get_lpc_coeffs(xm', M);
        w_o = get_lpc_coeffs_gd(xm', M, 1e4);

        shaping_filter = 1./abs(fft(w_o, nfft));
        shaping_filters(:,m) = shaping_filter';
        clc;
        disp(['lpc analysis: ' num2str(m) ' out of ' num2str(num_frames) ' frames'])
    end 
end