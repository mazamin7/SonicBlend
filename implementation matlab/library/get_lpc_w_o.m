function [w_o] = get_lpc_w_o(x, M)
    % returns optimal coefficients w_o_0, w_o_1, ..., w_o_M for a signal x
    % x: input signal
    % M: order of LP coefficients
    
    p = xcorr(x, M, 'biased');
    N = length(p);
    p = N * p(M+1:end)';
    R = toeplitz(p);

    w_o = linsolve(R(2:end,2:end), p(2:end));
end