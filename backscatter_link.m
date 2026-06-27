function [I, Q, Pr] = backscatter_link(d, f, link, P_noise)
% backscatter_link  One IQ sample at one frequency for a backscatter tag.
%
%   [I, Q, Pr] = backscatter_link(d, f, link, P_noise)
%
% Inputs:
%   d        : tag-to-reader distance (m)
%   f        : carrier frequency (Hz)
%   link     : struct with fields (linear units):
%                 Pt    -- reader TX power (W)
%                 refl  -- backscatter reflection factor (linear)
%   P_noise  : per-channel noise power at the reader RX (W)
%
% Outputs:
%   I, Q : in-phase and quadrature components of the received baseband sample
%   Pr   : noise-free received power predicted by the link budget (W)
%
% Model (simplified backscatter):
%   Pr = Pt * refl * (lambda/(4*pi*d))^4
%   round-trip phase: phi = -4*pi*f*d/c   (mod 2*pi)
%   IQ sample s = sqrt(Pr) * exp(1j*phi) + n,  n ~ CN(0, P_noise)

    c = 3e8;
    lambda = c / f;

    % Noise-free received power
    Pr = link.Pt * link.refl * (lambda / (4*pi*d))^4;

    % Wrapped round-trip phase
    phi = mod(-4*pi*f*d/c, 2*pi);

    % Clean baseband sample, voltage convention (sqrt(Pr) into 1 ohm)
    s_clean = sqrt(Pr) * exp(1j*phi);

    % Add complex AWGN with total variance P_noise (split across I and Q)
    n = sqrt(P_noise/2) * (randn + 1j*randn);
    s = s_clean + n;

    I = real(s);
    Q = imag(s);
end
