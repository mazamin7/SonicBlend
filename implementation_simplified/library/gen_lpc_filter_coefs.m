function [filter_coeffs] = gen_lpc_filter_coefs(windowed_modulator, M)
    % windowed_modulator: matrix where each column is a windowed signal
    % M: order of linear predictor
    % nfft: fft size
    %
    % Returns a matrix of spectral envelopes, where column m is spectral envelope for m'th signal frame
    
    num_frames = size(windowed_modulator, 2);
    filter_coeffs = zeros(M+1, num_frames);

    for m = 1:num_frames
        xm = windowed_modulator(:,m); % get mth column

        % coeffs = gen_lp_coeffs(xm', M);
        coeffs = gen_lp_coeffs_gd(xm', M, 1e4);

        filter_coeffs(:,m) = coeffs;
    end
end