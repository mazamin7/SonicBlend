function [w_o, count] = get_lpc_w_o_gd(x, M, num_iter)
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

temp = 1;
count = 0;
% perform gradient descent
while abs(temp) > 1e-7
    % modify to do this until sufficient convergence is reached
    % update coefficients
    temp = (rx(2:end) - R(2:end,2:end) * w_o);
    w_o = w_o + temp*mu;
    count = count + 1;
end

end
