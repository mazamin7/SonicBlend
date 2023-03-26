function xms = get_windowed_signal(signal, L, R, w)
% signal: input signal
% L: window length
% R: window shift
% w: window function (e.g. hamming, hann, etc.)

if R == L/2
    signal = [zeros(L/2,1); signal; zeros(L/2,1)];
end

% Determine number of windows
N = floor((length(signal)-L)/R) + 1;

% Initialize windowed signal matrix
xms = zeros(L, N);

% Fill matrix with windowed signal
for i = 1:N
    idx = (i-1)*R + 1;
    xms(1:L, i) = signal(idx:idx+L-1).*w;
end

end
