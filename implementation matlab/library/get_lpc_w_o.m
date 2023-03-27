function [w_o] = get_lpc_w_o(x, M)
    % returns optimal coefficients w_o_0, w_o_1, ..., w_o_M for a signal x
    % x: input signal
    % M: order of LP coefficients
    
    % Calculate autocorrelation sequence
    p = xcorr(x, M, 'biased');
    
    % Determine length of signal
    N = length(p);
    
    % Extract relevant portion of autocorrelation sequence
    p = N * p(M+1:end)';
    
    % Construct Toeplitz matrix using autocorrelation sequence
    R = toeplitz(p);
    
    % Solve linear system to obtain optimal LP coefficients
    w_o = linsolve(R(2:end,2:end), p(2:end));
end
