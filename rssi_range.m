function [d_est, d_per_ch] = rssi_range(I, Q, freqs, link)
% rssi_range  RSSI-based range from one or more channels (averaged).
%
%   [d_est, d_per_ch] = rssi_range(I, Q, freqs, link)
%
% Inputs:
%   I, Q  : 1xN vectors of I/Q samples (one per channel)
%   freqs : 1xN vector of channel center frequencies (Hz)
%   link  : same struct passed to backscatter_link (Pt, refl)
%
% Outputs:
%   d_est    : averaged distance estimate (m)
%   d_per_ch : 1xN vector of per-channel distance estimates (m)
%
% Method:
%   Invert the simplified backscatter link
%       Pr = Pt * refl * (lambda/(4*pi*d))^4
%   to get
%       d = ( Pt * refl * lambda^4 / ((4*pi)^4 * Pr) )^(1/4)
%
%   Assumes Pt and refl are calibrated/known.

    c = 3e8;
    Pr  = I.^2 + Q.^2;                         % per-channel measured power
    lam = c ./ freqs;

    num = link.Pt .* link.refl .* lam.^4;
    den = (4*pi)^4 .* Pr;

    d_per_ch = (num ./ den).^(1/4);
    d_est    = mean(d_per_ch);
end
