function [w_o] = get_lpc_w_o(x, M)
    % returns a_0, a_1, ..., a_M for a signal x
    p = xcorr(x, M, 'biased');
    N = length(p);
    p = N * p(M+1:end)';
    R = toeplitz(p);

    w_o = linsolve(R(2:end,2:end), p(2:end));
    w_o = [1, -w_o'];
end