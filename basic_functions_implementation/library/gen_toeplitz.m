function [toeplitz] = gen_toeplitz(rx, M)
    toeplitz = zeros(M);
    for i = 1:M
        for j = 1:M
            toeplitz(i, j) = rx(abs(i-j)+1);
        end
    end
end