function [rx] = gen_autocorrelates(x, M)
    % returns [r_0, r_1, ..., r_M]
    rx = zeros(M+1,1);
    for i = 1:M+1
        rx(i) = x(1:end-i+1)*x(i:end)';
    end
    rx = rx';
end