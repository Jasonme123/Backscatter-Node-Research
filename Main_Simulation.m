%% Main_Simulation.m  -- top-level driver. Just flags + scenario calls.

clear; close all; clc;

% ---- Flags -------------------------------------------------------------
PLACEMENT_MODE = 'fixed';   % 'fixed'  -> same positions each run
                            % 'random' -> different positions each run
N_TAGS         = 3;
RANGE_MIN      = 3;         % meters, min tag-to-reader distance
RANGE_MAX      = 10;        % meters, max tag-to-reader distance

% ---- Common parameters -------------------------------------------------
sim_params; 

% ---- Place nodes -------------------------------------------------------
nodes  = placeNodes2D(N_TAGS, RANGE_MIN, RANGE_MAX, PLACEMENT_MODE);
true_d = arrayfun(@(nd) nd.range, nodes);

% ---- Per-tag link-budget / SNR diagnostic ------------------------------
lambda_c   = c / fc;
Pr_per_tag = link.Pt * link.refl .* (lambda_c ./ (4*pi*true_d)).^4;

fprintf('\nPer-tag link budget @ fc = %.3f GHz, P_noise = %.2e W:\n', fc/1e9, P_noise);
for n = 1:numel(nodes)
    Pr_dBm = 10*log10(Pr_per_tag(n)/1e-3);
    if P_noise > 0
        snr_str = sprintf('%7.2f dB', 10*log10(Pr_per_tag(n)/P_noise));
    else
        snr_str = '    Inf (noise-free)';
    end
    fprintf('  Tag %d   d = %6.2f m   Pr = %7.2f dBm   SNR = %s\n', ...
        n, true_d(n), Pr_dBm, snr_str);
end

% ---- Run scenarios -----------------------------------------------------
scenario_pbr_rssi;
scenario_pbr_only;
