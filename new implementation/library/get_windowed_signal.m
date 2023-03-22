function xms = get_windowed_signal(signal, L, R, w)
% Partitions signal into windows of length M, separated by R samples
% returns: M x N matrix, where M is the window size, and N is number of windows
if nargin < 4
    w = [];
end

xms = zeros(L,1)'; % ini

if ~isempty(w)
    ws = w(1:L);
else
    ws = [];
end

signal = [zeros(L/2,1)' signal zeros(L/2,1)']; % for COLA reconstruction
% TODO: do we need to strip these zeros in istft?
ms = 1:R:length(signal);

for i = 1:length(ms)
    m = ms(i);
    
    if (m+L) > length(signal)
        % Zero-pad the last window if necessary
        xm = [signal(m:end) zeros(L-length(signal)+m-1,1)'];
    else
        xm = signal(m+1:m+L);
    end

    if ~isempty(ws) % apply window fn
        xm = xm.*ws';
    end

    xms = [xms; xm];
end

xms = xms';
xms = xms(:,2:end); % discard first column of all zeros

end