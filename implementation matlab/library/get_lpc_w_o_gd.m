function [w_o] = get_lpc_w_o_gd(x, M, num_iter)
% returns optimal coefficients w_o_0, w_o_1, ..., w_o_M for a signal x
% x: input signal
% M: order of LP coefficients
% alpha: step size for gradient descent
% num_iter: number of iterations for gradient descent

N = length(x);

% calculate autocorrelation
rx = xcorr(x, M, 'biased');
rx = N * rx(M+1:end)';

R = toeplitz(rx(1:M+1));

eigs_R = eig(R(2:end,2:end));
factor = 0.95;
mu = factor * (2/max(eigs_R));

% initialize coefficients to random values between -1 and 1
w_o = 2*rand(1,M)'-1;

% perform gradient descent
for i = 1:num_iter % modify to do this until sufficient convergence is reached
    % update coefficients
    w_o = w_o + mu * (rx(2:end) - R(2:end,2:end) * w_o);
end

end
