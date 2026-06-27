%% scenario_pbr_rssi  PBR (one channel pair) + RSSI (averaged over remaining channels)
%
% Expects in caller workspace:
%   nodes, true_d, freqs, df, N_ch, pbr_pair, rssi_idx, link, P_noise

fprintf('\n=== Scenario: PBR pair + RSSI average ===\n');

N = numel(nodes);

% --- Simulate IQ on every channel ---
I_rx = zeros(N, N_ch);
Q_rx = zeros(N, N_ch);
for n = 1:N
    d = true_d(n);
    for k = 1:N_ch
        [I_rx(n,k), Q_rx(n,k), ~] = backscatter_link(d, freqs(k), link, P_noise);
    end
end

% --- Range estimates per tag ---
d_pbr  = zeros(N,1);
d_rssi = zeros(N,1);
for n = 1:N
    d_pbr(n)  = pbr_range(I_rx(n,pbr_pair(1)), Q_rx(n,pbr_pair(1)), ...
                          I_rx(n,pbr_pair(2)), Q_rx(n,pbr_pair(2)), df);
    d_rssi(n) = rssi_range(I_rx(n,rssi_idx),   Q_rx(n,rssi_idx), ...
                          freqs(rssi_idx), link);
end
d_est_pbrrssi = (d_pbr + d_rssi) / 2;

% --- Print ---
fprintf('Tag |  True  |  PBR   |  RSSI  |  Comb. |  Err   |  %%err\n');
fprintf('----+--------+--------+--------+--------+--------+-------\n');
for n = 1:N
    err = d_est_pbrrssi(n) - true_d(n);
    fprintf(' %d  | %6.2f | %6.2f | %6.2f | %6.2f | %+6.2f | %+5.1f%%\n', ...
        n, true_d(n), d_pbr(n), d_rssi(n), d_est_pbrrssi(n), err, ...
        100*err/true_d(n));
end

% --- Plot: true positions + estimated range circles ---
figure('Name','PBR + RSSI','Color','w');
hold on; grid on; axis equal;
plot(0,0,'kp','MarkerSize',16,'MarkerFaceColor','k');
text(0, 1.5, 'Reader', 'HorizontalAlignment','center');

theta = linspace(0, 2*pi, 200);
colors = lines(N);
for n = 1:N
    plot(nodes(n).x, nodes(n).y, 'o', 'MarkerSize', 10, ...
         'MarkerFaceColor', colors(n,:), 'MarkerEdgeColor','k');
    text(nodes(n).x + 1, nodes(n).y, sprintf('Tag %d', n));
    plot(true_d(n)*cos(theta),         true_d(n)*sin(theta),         '-',  'Color', colors(n,:), 'LineWidth', 0.8);
    plot(d_est_pbrrssi(n)*cos(theta),  d_est_pbrrssi(n)*sin(theta),  '--', 'Color', colors(n,:), 'LineWidth', 1.4);
end
xlabel('x (m)'); ylabel('y (m)');
title('PBR pair + RSSI average');
xlim([-RANGE_MAX-5, RANGE_MAX+5]);
ylim([-RANGE_MAX-5, RANGE_MAX+5]);
