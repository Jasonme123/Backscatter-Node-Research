function d_est = pbr_range(I1, Q1, I2, Q2, df)
% pbr_range  Phase-based range from one pair of adjacent channels.
%
%   d_est = pbr_range(I1, Q1, I2, Q2, df)
%
% Inputs:
%   I1, Q1 : I/Q sample at frequency f1
%   I2, Q2 : I/Q sample at frequency f2 = f1 + df
%   df     : channel spacing (Hz)
%
% Output:
%   d_est : estimated round-trip distance (m)
%
% Method (FD-PDoA, single channel pair):
%   The unwrapped round-trip phase is phi = -4*pi*f*d/c.
%   Across two adjacent channels:
%       Delta_phi = -4*pi*df*d/c
%   So d = c * |Delta_phi| / (4*pi*df) = lambda_e * |Delta_phi| / (4*pi),
%   with lambda_e = c/df.
%
%   The unambiguous range is c/(2*df) = lambda_e/2.
%   For df = 1 MHz this is 150 m.

    c = 3e8;
    lambda_e = c / df;

    phi1 = atan2(Q1, I1);                      % wrapped, [-pi, pi)
    phi2 = atan2(Q2, I2);

    % Wrap the difference into [0, 2*pi) so that distance comes out positive.
    dphi = mod(phi1 - phi2, 2*pi);

    d_est = lambda_e / (4*pi) * dphi;
end
