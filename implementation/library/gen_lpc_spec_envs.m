function [spec_envs] = gen_lpc_spec_envs(windowed_modulator, M, nfft)
    % windowed_modulator: matrix where each column is a windowed signal
    % M: order of linear predictor
    % nfft: fft size
    %
    % Returns a matrix of spectral envelopes, where column m is spectral envelope for m'th signal frame
    
    num_frames = size(windowed_modulator, 2);
    spec_envs = zeros(nfft, 1);

    for m = 1:num_frames
        xm = windowed_modulator(:, m); % get mth column

        % coeffs = gen_lp_coeffs(xm', M);
        coeffs = gen_lp_coeffs_gd(xm', M, 1e4);

        spec_env = 1./abs(fftshift(fft(coeffs, nfft)));
        spec_envs = [spec_envs, spec_env'];
    end

    spec_envs = spec_envs(:, 2:end);
end