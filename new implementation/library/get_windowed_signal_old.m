function xms = get_windowed_signal(signal, L, R, w)
% Partitions signal into windows of length L, separated by R samples
% returns: M x N matrix, where M is the window size, and N is number of windows

signal = signal';

% Initialize the windowed signal matrix with zeros
xms = zeros(L, floor((length(signal)-L)/R)+1);

% Add zeros to the beginning and end of the signal for COLA reconstruction
signal = [zeros(L/2,1)', signal, zeros(L/2,1)'];

% Generate indices for each window
ms = 1:R:length(signal)-L+1;

% Loop through each window and apply the windowing function
for m = 1:length(ms)
    xm = signal(ms(m):ms(m)+L-1);

    if numel(xm) < L
        % Zero-pad if necessary
        xm = [xm, zeros(L-numel(xm),1)'];
    end

    % Apply the windowing function to the current window
    xm = xm .* w';

    % Store the windowed signal in the matrix
    xms(:,m) = xm;
end

xms = xms(:,2:end-1);

end
