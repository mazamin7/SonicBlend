function [coeffs] = gen_lp_coeffs_gd(x, M, num_iter)
% returns a_0, a_1, ..., a_M for a signal x using gradient descent
% x: input signal
% M: order of LP coefficients
% alpha: step size for gradient descent
% num_iter: number of iterations for gradient descent

N = length(x);

% calculate autocorrelation
rx = xcorr(x, M, 'biased');
rx = N * rx(M+1:end)';

R = toeplitz(rx(1:M+1));

eigs_R = eig(R);
factor = 0.95;
mu = factor * (2/max(eigs_R));

% initialize coefficients to random values between -1 and 1
coeffs = 2*rand(1,M)'-1;

% perform gradient descent
for i = 1:num_iter % modify to do this until sufficient convergence is reached
    % update coefficients
    coeffs = coeffs + mu * (rx(2:end) - R(2:end,2:end) * coeffs);
end

coeffs = [1, -coeffs'];

end
