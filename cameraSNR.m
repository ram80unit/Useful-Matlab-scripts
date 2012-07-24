% camera SNR calculations

clear all; close all;

% pick a camera
% 1: Atik 314L+
% 2: Andor iKon-M 934, back-illuminated, visible
% 3: Andor iKon-L 936
% 4: Andor Neo sCMOS

camera = 1;

% some other parameters
lens_f = 1.0;
bin_factor = 1;     % in each dimension; i.e. for 2x2 use bin_factor = 2
filter_T = 0.7;     % filter transmission at wavelength of interest
filter_low = 6290;  % filter cutoff frequencies. assumes boxcar shape
filter_high = 6310;


%% now for some calculations

% constants
k = 62500;                  % equals 10^6/16, which comes from Rayleigh definition
waves = [200:50:1100];      % wavelength range for QE
fullwaves = [200:0.2:1100];   % higher resolution (2 A), to interpolate

% camera parameters

if camera == 1,
    % atik
elseif camera == 2,
    % ikon-M
    qe = [07 20 10 23 55 80 94 98 97 94 91 86 78 65 48 30 15 05 00];
    temp = -80;
    R = 6.6;        % read noise at 1 MHz readout
    D = 0.0003;     % dark current at temp
    d = 13e-4;      % cm pixel size
elseif camera == 3,
    % ikon-L
    qe = [07 20 10 23 55 80 94 98 97 94 91 86 78 65 48 30 15 05 00];
    temp = -80;
    R = 7.0;        % at 1 MHz readout
    D = 0.0004;     
    d = 27.6e-4;
elseif camera == 4,
    % neo
    qe = [00 04 10 20 36 46 54 57 56 54 49 41 32 23 14 07 04 02 00];
    temp = -40;
    R = 1;
    D = 0.03;
    d = 6.5e-4;
else
    error('Not a valid camera choice.');
end

d = [13e-4 13.5e-4 13.5e-4];
Q = [0.95 0.95 0.95];
R = [10.3 11.8 11.8];
D = [0.005 0.001 0.001];

I = 100;
Ib = 1;
B = 20;

K = k.*b.*Q*Tf.*(d/f).^2;

for m = 1:length(t),

tint = t(m);
    
S = I * K * tint;
N_R = R.^2;
N_D = D .* b * tint;
N_S = S;
N_B = K * Ib * B * tint;
N = sqrt(N_R + N_D + N_S + N_B);

for n = 1:length(d),
SNR(m,n) = S(n)/N(n);
end

end

plot(t,SNR); hold on;
xlabel('Integration time (s)');
ylabel('SNR');
plot([min(t) max(t)],[1 1],'k--');