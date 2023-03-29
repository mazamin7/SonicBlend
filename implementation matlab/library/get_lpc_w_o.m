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
    % linsolve uses the most appropriate solver with respect to the matrix
    % type -> in our case, it exploits the Toeplitz property, making
    % it O(n^2) as opposed to matrix inversion which is O(n^3)
end
