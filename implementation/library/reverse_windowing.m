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

% Initialize overlap-add array
overlap_add = zeros(n, 1);

% Fill overlap-add array with windowed segments
for i = 1:N
    idx = (i-1)*R + 1;
    overlap_add(idx:idx+L-1) = overlap_add(idx:idx+L-1) + xms(:, i).*w;
end

% Apply overlap and add
for i = 1:N
    idx = (i-1)*R + 1;
    signal(idx:idx+L-1) = signal(idx:idx+L-1) + overlap_add(idx:idx+L-1);
end

end
