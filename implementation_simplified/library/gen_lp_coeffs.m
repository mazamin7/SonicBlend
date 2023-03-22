function [coeffs] = gen_lp_coeffs(x, M)
    % returns a_0, a_1, ..., a_M for a signal x
    rx = xcorr(x, M, 'biased');
    N = length(rx);
    rx = N * rx(M+1:end)';
    R = toeplitz(rx);

    coeffs = linsolve(R(2:end,2:end), rx(2:end));
    coeffs = [1, -coeffs'];
end