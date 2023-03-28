function [w_o, num_iter] = get_lpc_w_o_gd(x, M, error_tolerance, max_num_iter)
% returns optimal coefficients w_o_0, w_o_1, ..., w_o_M for a signal x
% x: input signal
% M: order of LP coefficients
% num_iter: number of iterations for gradient descent

N = length(x);

% calculate autocorrelation
rx = xcorr(x, M, 'biased');
rx = N * rx(M+1:end)'; % biased autocorrelation

R = toeplitz(rx(1:M+1)); % toeplitz matrix of the autocorrelation

eigs_R = eig(R(2:end,2:end)); % eigenvalues of R matrix (excluding the first row and column)
factor = 0.95;
mu_max = 2/max(eigs_R); % maximum value of mu for gradient descent
mu = factor * mu_max; % learning rate for gradient descent

% initialize coefficients to random values between -1 and 1
w_o = 2*rand(1,M)'-1;

grad = 1;
num_iter = 0;
% perform gradient descent
while (sum(abs(grad)) > error_tolerance) && (num_iter < max_num_iter)
    % modify to do this until sufficient convergence is reached
    % update coefficients
    grad = (rx(2:end) - R(2:end,2:end) * w_o);
    w_o = w_o + grad*mu;
    num_iter = num_iter + 1;
end

end
