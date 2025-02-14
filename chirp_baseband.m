function x = chirp_baseband(BW, Tp, t)
%CHIRP_BASEBAND Generate a baseband FMCW chirp from 0 to BW over [0, Tp].
%
%   x = chirp_baseband(BW, Tp, t) creates a complex exponential
%   that linearly sweeps in frequency from 0 to BW (Hz) over
%   the time interval [0, Tp]. The vector t is the time array.

    alpha = BW / Tp;  % slope (Hz/s)
    % purely baseband sweep: exp(j * pi * alpha * t^2)
    x = exp(1i * pi * alpha * t.^2) ...
        .* (heaviside(t) - heaviside(t - Tp));
end
