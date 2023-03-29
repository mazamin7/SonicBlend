clear all, close all, clc;

addpath ..\library\

num_iter = 30;

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
rx = xcorr(x, M, 'biased');
rx = N * rx(M+1:end)'; % biased autocorrelation

R = toeplitz(rx(1:M+1)); % toeplitz matrix of the autocorrelation

eigs_R = eig(R(2:end,2:end)); % eigenvalues of R matrix (excluding the first row and column)
factor = 0.3;
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

figure;
plot(1:num_iter,J_partial);
title('Error vs iteration')
xlabel('iteration')
ylabel('J')
