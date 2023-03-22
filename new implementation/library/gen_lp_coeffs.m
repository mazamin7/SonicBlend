function [coeffs] = gen_lp_coeffs(x, M)
    % returns a_0, a_1, ..., a_M for a signal x
    rx = gen_autocorrelates(x, M);
    toeplitz_mat = gen_toeplitz(rx, M);

    coeffs = linsolve(toeplitz_mat, -1*rx(2:end)');
    coeffs = [1; coeffs]';
end