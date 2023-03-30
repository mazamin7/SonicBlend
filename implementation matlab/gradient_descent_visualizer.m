clear all, close all, clc;

addpath library

num_iter = 50;

% ========== Arguments gd ==========

x = rand(1,randi([100,200]));
M = 2;
error_tolerance = 0;
max_num_iter = num_iter;

% ========== Function gd ==========

% compute optimal solution using "lpc"
w_o_opt = lpc(x, M);
w_o_opt = -w_o_opt(2:end)';

% init iteration solutions
w_o_partial = zeros(num_iter,M);
J_partial = zeros(num_iter,1);

J_min = sum(x.^2);

N = length(x);

% calculate autocorrelation
p = xcorr(x, M);
p = p(M+1:end)'; % biased autocorrelation

R = toeplitz(p(1:end-1)); % toeplitz matrix of the autocorrelation

eigs_R = eig(R); % eigenvalues of R matrix (excluding the first row and column)
factor = 0.3; % converges if factor < 1
mu_max = 2/max(eigs_R); % maximum value of mu for gradient descent
mu = factor * mu_max; % learning rate for gradient descent
assert(mu < 0.1)

% computing theoretical upper limit of error vs iterations
lambda_min = min(eigs_R);
% tau = 1 / 2 / mu / lambda_min; % approximated formula
tau = -1/(2 * log(1 - mu*lambda_min));

% initialize coefficients to random values between -1 and 1
w_o = 2*rand(1,M)'-1;

grad = 1;
num_iter = 0;
% perform gradient descent
while (sum(abs(grad)) > error_tolerance) && (num_iter < max_num_iter)
    % update coefficients
    grad = (p(2:end) - R * w_o);
    w_o = w_o + mu*grad;
    w_o_partial(num_iter+1,:) = w_o;
    J_partial(num_iter+1) = J_min + (w_o - w_o_opt)' * R(2:end,2:end) * (w_o - w_o_opt);
    num_iter = num_iter + 1;
end

w1 = w_o_partial(:,1);
w2 = w_o_partial(:,2);

% plot solution vectors
plot(w1,w2,'-o');
hold on;
plot(w_o_opt(1),w_o_opt(2),'rx','LineWidth',2);

hold off;
xlabel('w1');
ylabel('w2');
title('Convergence Path');
legend('Iteration solutions', 'Optimal solution');

amp = J_partial(1) - J_min(1);
iter_axis = 1:num_iter;
exponential = amp*exp(-1/tau*(iter_axis - 1));

figure;
plot(iter_axis,J_partial - J_min);
hold on
plot(iter_axis,exponential)
title('Error vs iterations')
xlabel('Iterations')
ylabel('J')
legend('Experimental','Theoretical upper limit');