%% Parameters
close all

%Simulation Time Parameters
Total_time = .002; %Total Simulated Time
fs = 1e-7; %Sample rate
t = 0:fs:Total_time-fs;  %Time vector

%chirp Prameters
Fc = 1; %Chirp Carrier Frequency
BW = 200e6; %Chirsp Bandwidth
Tp = 1e-3; %Chirp Duration
alpha = BW / Tp; %Sweep Rate

%Node Parameters
numNodes = 1; %Number of Nodes
Tb = 1e-5; %Node bit Period

%% Create nodes
nodes = createNodes(numNodes);

%% Generate Backscatter Symbol Waveforms as seen from transmitter
for i = 1:numNodes
nodes(i).bitwaveformString = backscatterSymbolGen(nodes(i),Tb,t);
end

%% Generate Baseband Chirp
tx_chirp = chirp(Fc,BW,Tp,t);

s = zeros(size(t));
% %% Signal Recieved at Transmitter
for i = 1:numNodes
    % Calculate the contribution from each node
    contribution = nodes(i).attenuation * (tx_chirp .* nodes(i).bitwaveformString);
    s = s + contribution;
end


%%DeChriping the signal
Recieved = s .* conj(tx_chirp);

% FFT processing to see the tones:
Nfft = 2^nextpow2(length(t));
Y = fft(Recieved, Nfft);
f_axis = linspace(0, 1/fs, Nfft);

% Plot
figure;
plot(f_axis, abs(Y));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('FFT of De-chirped Signal (Baseband)');
xlim([0, 2e6]);  

figure;
plot(t, real(tx_chirp), 'r', 'LineWidth', 2);
hold on;
plot(t,real(s), 'b--', 'LineWidth', 2); 
plot(t, nodes(i).bitwaveformString, 'g--', 'LineWidth', 2); 
hold off;

% Peak frequency
[~, idx] = max(abs(Y));
f_beat = f_axis(idx);
fprintf('Beat Frequency: %.2f Hz\n', f_beat);

%% Range from beat frequency
R_est = (3e8 * f_beat) / (2 * alpha);
R_act = sqrt(nodes(1).x^2 + nodes(1).y^2);
fprintf('Estimated Range: %.2f meters\n', R_est);
fprintf('Actual Range: %.2f meters\n', R_act);