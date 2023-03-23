function w = get_bartlett(L)
%GET_BARTLETT Returns coefficients for a bartlett/triangular window of length L.
%   Usage: w = get_bartlett(L)
%
%   Input parameters:
%     - L: length of the window
%
%   Output parameters:
%     - w: row vector of length L containing the window coefficients
%
%   Example:
%     w = get_bartlett(20);
%     plot(w);
%
%   See also: bartlett

    w = [0:ceil((L-1)/2)-1, floor((L-1)/2):-1:0]';

    max = (L-1)/2;
    w = w/max;
end