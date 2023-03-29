function xms = get_signal_frames(signal, L, R, w_fun, keep_extremes)
% signal: input signal
% L: window length
% R: window shift
% w_fun: window function handle (e.g. hamming, hann, etc.)
% keep_extremes: returns first and last frames if true

% Generate window
w = w_fun(L);

signal = [zeros(R,1); signal; zeros(R,1)];

% Determine number of frames
N = floor((length(signal)-L)/R) + 1;

% Initialize windowed signal matrix
xms = zeros(L, N);

% Fill matrix with framed signal
for i = 1:N
    idx = (i-1)*R + 1;
    xms(:, i) = signal(idx:idx+L-1).*w;
end

% If used in combination with stft and istft, we should ignore extremes
if ~keep_extremes
    xms = xms(:,2:end-1);
end

end
