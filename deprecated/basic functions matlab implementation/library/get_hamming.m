function w = get_hamming(L)
%GET_HAMMING Returns coefficients for a Hamming window of length L.
%   Usage: w = get_hamming(L)
%
%   Input parameters:
%     - L: length of the window
%
%   Output parameters:
%     - w: row vector of length L containing the window coefficients
%
%   Example:
%     w = get_hamming(20);
%     plot(w);
%
%   See also: hamming

    w = 0.54 - (0.46*cos(2*pi*(0:L-1)/(L-1))');
end