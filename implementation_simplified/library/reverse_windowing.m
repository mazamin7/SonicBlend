function signal = reverse_windowing(xms, L, R, w)
% xms: windowed signal matrix
% L: window length
% R: window shift
% w: window function (e.g. hamming, hann, etc.)

% Determine signal length
N = size(xms, 2);
n = (N-1)*R + L;

% Initialize output signal
signal = zeros(n, 1);

% Fill output signal with windowed segments
for i = 1:N
    idx = (i-1)*R + 1;
    signal(idx:idx+L-1) = signal(idx:idx+L-1) + xms(:, i).*w;
end

end
