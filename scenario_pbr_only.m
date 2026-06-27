%% scenario_pbr_only  PBR pair only (no RSSI averaging)
%
% Expects in caller workspace:
%   nodes, true_d, freqs, df, pbr_pair, link, P_noise

fprintf('\n=== Scenario: PBR pair only (no RSSI) ===\n');

N = numel(nodes);

% --- Simulate IQ on the PBR pair only ---
I_rx = zeros(N, 2);
Q_rx = zeros(N, 2);
for n = 1:N
    d = true_d(n);
    [I_rx(n,1), Q_rx(n,1), ~] = backscatter_link(d, freqs(pbr_pair(1)), link, P_noise);
    [I_rx(n,2), Q_rx(n,2), ~] = backscatter_link(d, freqs(pbr_pair(2)), link, P_noise);
end

% --- PBR range estimate ---
d_est_pbronly = zeros(N,1);
for n = 1:N
    d_est_pbronly(n) = pbr_range(I_rx(n,1), Q_rx(n,1), ...
                                 I_rx(n,2), Q_rx(n,2), df);
end

% --- Print ---
fprintf('Tag |  True  |  PBR   |  Err   |  %%err\n');
fprintf('----+--------+--------+--------+-------\n');
for n = 1:N
    err = d_est_pbronly(n) - true_d(n);
    fprintf(' %d  | %6.2f | %6.2f | %+6.2f | %+5.1f%%\n', ...
        n, true_d(n), d_est_pbronly(n), err, 100*err/true_d(n));
end

% --- Plot: true positions + estimated range circles ---
figure('Name','PBR only','Color','w');
hold on; grid on; axis equal;
plot(0,0,'kp','MarkerSize',16,'MarkerFaceColor','k');
text(0, 1.5, 'Reader', 'HorizontalAlignment','center');

theta = linspace(0, 2*pi, 200);
colors = lines(N);
for n = 1:N
    plot(nodes(n).x, nodes(n).y, 'o', 'MarkerSize', 10, ...
         'MarkerFaceColor', colors(n,:), 'MarkerEdgeColor','k');
    text(nodes(n).x + 1, nodes(n).y, sprintf('Tag %d', n));
    plot(true_d(n)*cos(theta),        true_d(n)*sin(theta),        '-',  'Color', colors(n,:), 'LineWidth', 0.8);
    plot(d_est_pbronly(n)*cos(theta), d_est_pbronly(n)*sin(theta), '--', 'Color', colors(n,:), 'LineWidth', 1.4);
end
xlabel('x (m)'); ylabel('y (m)');
title('PBR pair only (no RSSI)');
xlim([-RANGE_MAX-5, RANGE_MAX+5]);
ylim([-RANGE_MAX-5, RANGE_MAX+5]);
