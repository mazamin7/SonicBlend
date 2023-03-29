function w = get_hanning(L)
%GET_HANNING Returns coefficients for a Hanning window of length L.
%   Usage: w = get_hanning(L)
%
%   Input parameters:
%     - L: length of the window
%
%   Output parameters:
%     - w: row vector of length L containing the window coefficients
%
%   Example:
%     w = get_hanning(20);
%     plot(w);
%
%   See also: hanning

    n = 1:L;
    w = 0.5*(1 - cos(2*pi*n/(L+1)))';
    
end