function [shaping_filters] = get_shaping_filters(framed_signal, M, NFFT, gd)
    % framed_signal: matrix where each column is a windowed signal
    % M: order of linear predictor
    % NFFT: fft size
    %
    % Returns a matrix of spectral envelopes, where column m is spectral envelope for m'th signal frame
    
    num_frames = size(framed_signal, 2);
    shaping_filters = zeros(NFFT, num_frames);

    for m = 1:num_frames
        xm = framed_signal(:, m); % get mth column

        if gd
            w_o = get_lpc_w_o_gd(xm', M, 1e4);
        else
            w_o = get_lpc_w_o(xm', M);
        end

        shaping_filter = 1./abs(fft([1, -w_o'], NFFT));
        shaping_filters(:,m) = shaping_filter';

        clc;
        disp(['lpc analysis: ' num2str(m) ' out of ' num2str(num_frames) ' frames'])
    end 
end