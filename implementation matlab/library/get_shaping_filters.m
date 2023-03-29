function [shaping_filters, count] = get_shaping_filters(framed_signal, M, NFFT, gd, error_tolerance, max_num_iter)
    % shaping_filters: matrix where each column is a shaping filter
    % M: order of linear predictor
    % NFFT: fft size
    % gd: perform optimization using gradient descent
    % error_tolerance: determine the accuracy by setting a threshold
    % max_num_iter: max number of iterations for gradient descent
    %
    % Returns a matrix of shaping filters, where column m is the shaping filter for m'th signal frame
    
    num_frames = size(framed_signal, 2);
    shaping_filters = zeros(NFFT, num_frames);

    for m = 1:num_frames
        xm = framed_signal(:, m); % get mth column

        if gd
            if m > 1
                initial_guess = w_o;
                rand_init = false;
            else
                initial_guess = zeros(M,1);
                rand_init = true;
            end

            [w_o, count] = get_lpc_w_o_gd(xm', M, error_tolerance, max_num_iter, rand_init, initial_guess);
        else
            w_o = get_lpc_w_o(xm', M);
            count = 0;
        end

        shaping_filter = 1./abs(fft([1, -w_o'], NFFT));
        shaping_filters(:,m) = shaping_filter';

        clc;
        disp(['lpc analysis: ' num2str(m) ' out of ' num2str(num_frames) ' frames'])
    end 
end