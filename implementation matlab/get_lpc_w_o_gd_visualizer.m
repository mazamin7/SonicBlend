clear all, close all, clc;

x = rand(1,randi([100,200]));
M = 2;
num_iter = 30;

N = length(x);

% calculate autocorrelation
rx = xcorr(x, M, 'biased');
rx = N * rx(M+1:end)';

R = toeplitz(rx(1:M+1));

eigs_R = eig(R(2:end,2:end));
factor = 0.3; % with higher values it starts to oscillate

lambda_max = max(eigs_R);
mu_max = 2/lambda_max;

mu = factor * mu_max;

% compute optimal solution using "lpc"
w_o_opt = lpc(x, M);
w_o_opt = -w_o_opt(2:end)';

% init iteration solutions
w_o_partial = zeros(num_iter,M);
J_partial = zeros(num_iter,1);

J_min = sum(x.^2);

% initialize coefficients to random values between -1 and 1
w_o = 2*rand(1,M)'-1;

% perform gradient descent
for i = 1:num_iter % modify to do this until sufficient convergence is reached
    % update coefficients
    w_o = w_o + mu * (rx(2:end) - R(2:end,2:end) * w_o);
    w_o_partial(i,:) = w_o;
    J_partial(i) = J_min + (w_o - w_o_opt)' * R(2:end,2:end) * (w_o - w_o_opt);
    % e(i) = sum((w_o-w_o_opt).^2);
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
