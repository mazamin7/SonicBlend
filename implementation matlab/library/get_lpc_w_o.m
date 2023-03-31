function [w_o] = get_lpc_w_o(x, M)
    % Returns optimal coefficients w_o_0, w_o_1, ..., w_o_M for a signal x
	% using the Wiener-Hopf equation
    %
    % x: input signal
    % M: order of LP coefficients
    
    % Calculate autocorrelation sequence
    p = xcorr(x, M, 'none');
    
    % Consider only non-negative lags
    p = p(M+1:end)';
    
    % Construct Toeplitz matrix using autocorrelation sequence
    R = toeplitz(p(1:end-1));
    
    % Solve linear system to obtain optimal LP coefficients
    w_o = linsolve(R, p(2:end));
    % linsolve uses the most appropriate solver with respect to the matrix
    % type -> in our case, it exploits the Toeplitz property, making
    % it O(n^2) as opposed to matrix inversion which is O(n^3)
end
