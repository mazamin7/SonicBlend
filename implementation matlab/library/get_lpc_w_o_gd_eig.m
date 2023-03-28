function [w_o, num_iter] = get_lpc_w_o_gd_eig(x, M, error_tolerance, max_num_iter)
% returns optimal coefficients w_o_0, w_o_1, ..., w_o_M for a signal x
% x: input signal
% M: order of LP coefficients
% num_iter: number of iterations for gradient descent

N = length(x);

% calculate autocorrelation
rx = xcorr(x, M, 'biased');
rx = N * rx(M+1:end)'; % biased autocorrelation

R = toeplitz(rx(1:M+1)); % toeplitz matrix of the autocorrelation

[lambda,Q] = eig(R(2:end,2:end)); % eigenvalues of R matrix (excluding the first row and column)
lambda = diag(lambda);
factor = 0.95;
mu_max = 2/max(lambda); % maximum value of mu for gradient descent
mu = factor * mu_max; % learning rate for gradient descent

% initialize coefficients to random values between -1 and 1
v_o = zeros(1,M)';

% perform gradient descent
for i = 1:M
    num_iter = 0;

    while num_iter < max_num_iter
        % modify to do this until sufficient convergence is reached
        % update coefficients
        v_o = v_o * (1 - mu*lambda(i));
        num_iter = num_iter + 1;
    end
end

w_o = Q * v_o;

end
