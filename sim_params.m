%% sim_params  Common parameters shared by all scenarios.
% Loaded by Main_Simulation.m

% --- Physics ------------------------------------------------------------
c       = 3e8; %Speed of Light

% --- RF plan ------------------------------------------------------------
fc      = 2.44e9;          % BLE band center (Hz)
BW      = 100e6;           % Total swept bandwidth (Hz)
df      = 2e6;             % Channel spacing (Hz)
N_ch    = round(BW/df);    % Number of channels
freqs   = fc - BW/2 + (0:N_ch-1)*df; %Vector of channel Frequencies

% PBR pair: one adjacent pair near the band center.
pbr_pair = [round(N_ch/2), round(N_ch/2)+1]; % Channel Indexes used for PBR
rssi_idx = setdiff(1:N_ch, pbr_pair);        % Channels not used for PBR

% --- Reader / tag link budget --------------------------------------------
link.Pt   = 10^((10-30)/10);   % Reader TX power: 10 dBm -> W (linear)
link.refl = 10^(-5/10);       % Backscatter reflection factor: -10 dB (linear)
                               % "small" passive reflection. Bump positive

% --- Noise ---------------------------------------------------------------
P_noise = 1e-15;    % AWGN power per IQ sample (W).
