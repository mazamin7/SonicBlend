function [coeffs] = gen_lp_coeffs_gd(x, M, alpha, num_iter)
% returns a_0, a_1, ..., a_M for a signal x using gradient descent
% x: input signal
% M: order of LP coefficients
% alpha: step size for gradient descent
% num_iter: number of iterations for gradient descent

% calculate autocorrelation
rx = gen_autocorrelates(x, M);

% initialize coefficients to random values between -1 and 1
coeffs = 2*rand(1,M+1)-1;

% set first coefficient to 1
coeffs(1) = 1;

% perform gradient descent
for i = 1:num_iter
    % calculate prediction error
    e = x(M+1:end) - filter(coeffs(2:end), 1, x(1:end-M));

    % calculate gradient
    grad = -2*alpha*toeplitz(rx(2:end))/length(x)*e;

    % update coefficients
    coeffs = coeffs - [0 grad']*alpha;
end

end
