%% Parameters
c = 3e8;
BW = 200e6;
Tp = 1e-3;
alpha = BW / Tp;
dt = 1e-7;
t = 0:dt:Tp-dt;  % single-chirp time vector

%% Generate Baseband Chirp
tx_chirp = chirp_baseband(BW, Tp, t);

%% Simulate a target at R_target
R_target = 100;                % 100 m
tau_target = 2 * R_target / c; % round-trip delay

% Create the delayed chirp (baseband)
t_delayed = t - tau_target;
rx_chirp = zeros(size(t));
% only valid where 0 <= t_delayed <= Tp
valid_idx = (t_delayed >= 0) & (t_delayed <= Tp);
rx_chirp(valid_idx) = chirp_baseband(BW, Tp, t_delayed(valid_idx));

% Optionally add noise
SNR_dB = 20;
signalPower = mean(abs(rx_chirp).^2);
noisePower = signalPower / (10^(SNR_dB/10));
noise = sqrt(noisePower/2) .* ...
        (randn(size(rx_chirp)) + 1i*randn(size(rx_chirp)));
rx_total = rx_chirp + noise;

%% De-chirp: multiply by conjugate of tx_chirp
y_base = rx_total .* conj(tx_chirp);

%% FFT to find beat frequency
Nfft = 2^nextpow2(length(t));
Y = fft(y_base, Nfft);
f_axis = (0:Nfft-1) * (1/(dt*Nfft));  % from 0 up to Fs

% Plot
figure;
plot(f_axis, abs(Y));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('FFT of De-chirped Signal (Baseband)');
xlim([0, 2e6]);  % ~2 MHz is enough to see a ~100 m target beat

% Peak frequency
[~, idx] = max(abs(Y));
f_beat = f_axis(idx);
fprintf('Beat Frequency: %.2f Hz\n', f_beat);

%% Range from beat frequency
R_est = (c * f_beat) / (2 * alpha);
fprintf('Estimated Range: %.2f meters\n', R_est);
