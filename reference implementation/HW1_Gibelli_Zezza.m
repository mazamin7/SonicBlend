clc; clear; close all;

%% Your name(s), student ID number(s)
%-------------------------------------------------------------------------%
% Federica Zezza, 962806 (10800278)
% Greta Gibelli, 103463 (10574372)
%-------------------------------------------------------------------------%

%% Here are some MATLAB function that you might find useful:
% audioread, soundsc, flipud, fliplr, xcorr, eig, eigs, filter, toeplitz,
% fft, ifft, pause, disp, ...

%% Read the wav files 
% load the source signal x
[x , ~] = audioread('x.wav');

% load the microphone signal y
[y , Fs] = audioread('y.wav');

%% Parameters
% number of filter taps
M = 4000; 

% length of the source signal x
N_x = length(x);
N_y = length(y);

%% Wiener-Hopf solution
% Compute the autocorrelation matrix

% Compute an estimate of the autocorrelation of the input signal
[r_ac, r_lags] = xcorr(x);
    
% Build auto-correlation matrix
r_ac = r_ac(r_lags >= 0); % Take positive lags 0,...,p
r_ac = 1/N_x * r_ac(1:M); % normalizing with the length of the source signal 

R = toeplitz(r_ac); % Create Toeplitz matrix from vector
%A Toeplitz matrix is a diagonal-constant matrix, which means all elements along a diagonal have the same value

% Estimation of the cross-correlation between the input signal and the desired response y
[p_cc, p_lags] = xcorr(x,y);
p_cc = flipud(p_cc);
% Build cross-correlation matrix
p_cc = p_cc(p_lags >= 0); % Take positive lags 0,...,p

% compute the cross-correlation vector
p = 1/N_y * p_cc(1:M); % normalizing with the length of the desired signal

% compute the Wiener-Hopf solution
w_o = R\p; 

%disp('Wiener-filter solution:');
%disp(w_o);

%% Steepest Descent
% Determine the step-size parameter 
num_steps = 2000;   %Number of steps of the iterative algorithm
eigenvalues = eig(R);   %Eigenvalues of the autocorrelation matrix
factor = 0.95;               

mu = factor * (2/max(eigenvalues));  %Update step

% determine the global time constant of the Steepest Descent algorithm
tau = 1 / (2 * mu * min(eigenvalues));

% initialize the vector of filter taps
w = zeros(M,1); %Initial guess of the filter coefficients: we don't have any prior knowledge so we set it to null vector

for n = 1:num_steps
% perform the iterative update
    w = w + mu*(p - R*w); 
end

x_padded = [x ; zeros(N_y-N_x, 1)]; %zero-padding 

% Compute the theoretical minimum MSE
J_min = var(y) - p'/R*p; 
disp('Theoretical minimum MSE:');
disp(J_min);

% compute the MSE associated with the current taps estimate
J_w = J_min+(w-w_o)'*R*(w-w_o); 
disp('Actual minimum MSE:');
disp(J_w);

% compute and discuss the cost functions ratio 
ratio = J_w / J_min;
disp('Cost function ratio:');
disp(ratio);

pause

%% Apply time-domain filter

% time-domain filter with Wiener
y_hat_td = filter(w_o,1,x_padded);

% time-domain filter with Steepest Descent
sd_out = filter(w,1,x_padded);

%% playback: source signal x
disp('Press any key to start playback...') 
pause()

disp('Playing source signal x...')
soundsc(x, Fs);
pause()


%% playback: microphone signal y

disp('Playing microphone signal y...')
soundsc(y, Fs);
pause()

%% playback: time-domain filtered signal y_hat

disp('Playing time-domain filtered signal with Wiener...')
soundsc(y_hat_td, Fs);
pause()

disp('Playing time-domain filtered signal with Steepest Descent...')
soundsc(sd_out, Fs);
pause()

%% Filtering in the frequency domain
% determine the length of the signal after zero-padding
L = N_x + length(w_o) - 1; %(length(w_o) equal to M)
n_fft = 2^nextpow2(L);  % fft best performing when n is a power of 2

% compute the spectra
W = fft(w_o,n_fft);  
X = fft(x,n_fft); 

% perform frequency-domain filtering
Y = X.*W;

% transform back to time domain
y_hat_fd = ifft(Y); 


%% playback: frequncy-domain filtered signal

disp('Playing frequency-domain filtered signal...')
soundsc(y_hat_fd, Fs);
pause()

%% OLA Filtering
% window length
wlen = 256;

% hop-size (must respect the COLA condition)
hop = wlen / 4;

% define a tapered window
win = hann(wlen);

% determine the length of the windowed signal after zero-padding
L_ola = length(w_o) + wlen - 1; %length(w_o) equal to M

% compute the fft of the Wiener filter
W = fft(w_o,L_ola);

% compute the total number of frames to be processed via OLA
n_frames = ceil((N_x-wlen)/hop+1); % number of time frames

% initialize the output filtered signal
y_hat_ola = zeros(N_y+M,1); % we add M that is the biggest possible length in order to avoid errors in reconstruction

% implement the OLA algorithm
for n=0:n_frames-1
    
    % Segment the source signal x 
    x_n = x_padded( 1+hop*n : wlen+hop*n );
 
    % Window the frame to ensure OLA reconstruction
    x_n =win .* x_n;
    
    % Compute frame's spectrum
    X_win = fft(x_n, L_ola); % n_ola per zero padding
    
    % Apply the spectral attenuation to the frame spectrum
    Y_n = X_win.*W;
    
    % Compute the inverse FFT of the filtered frame. 
    y_n = ifft(Y_n); 
    
    % OLA
    y_hat_ola( 1+hop*n : L_ola+hop*n ) = y_hat_ola( 1+hop*n : L_ola+hop*n ) + y_n;
  
end
y_hat_ola = y_hat_ola(1:N_y);


%% playback: OLA filtered signal y_hat_ola

disp('Playing OLA filtered signal...')
soundsc(y_hat_ola, Fs);
pause()

%% Plot the estimated filter taps against the true RIR
% load the RIR (g.wav)
[g , ~] = audioread('g.wav');

% produce the plot

% the abscissae should expressed in time units in seconds
g_x = 0 : 1/Fs : (length(g)-1)/Fs;
w_x = 0 : 1/Fs : (M-1)/Fs;


fig = figure(1); % name of the figure

subplot(311); % 3 rows, 1 column and we work on the first one
plot(g_x, g,'linewidth',1.5);
axis tight; grid on;
ylabel('g(n)', 'Interpreter', 'latex');
xlabel('Time [s]', 'Interpreter', 'latex'); 
title('True RIR', 'Interpreter', 'latex');

subplot(312); % 3 rows, 1 column and we work on the second one
plot(w_x, w_o,'r','linewidth',1.5);
axis tight; grid on;
ylabel('w$_o$', 'Interpreter', 'latex'); 
xlabel('Time [s]', 'Interpreter', 'latex');
title('Wiener-Hopf solution', 'Interpreter', 'latex');

subplot(313); % 3 rows, 1 column and we work on the third one
plot(w_x, w,'r','linewidth',1.5);
axis tight; grid on;
ylabel('w', 'Interpreter', 'latex');
xlabel('Time [s]', 'Interpreter', 'latex');
title('Steepest Descent solution', 'Interpreter', 'latex');

% save current figure as png
saveas(fig,'EstimationRIR_results.png');
pause()

% ----EOF----