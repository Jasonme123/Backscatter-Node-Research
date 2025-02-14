function m = backscatterSymbolGen(nodes, Tb, t)

    a_temp = nodes.bitString;  %Generated Binary String
    tau_temp = nodes.tau;      %Propagation Delay
    gamma_temp = nodes.tau;    %Clock Phase Delay
    
    % Replace any 0 with -1.
    a_temp(a_temp == 0) = -1;
    
    % Check that all symbols are 1 or -1.
    if any(abs(a_temp) ~= 1)
        error("All symbol values must be either 1 or -1.");
    end
    
    % Preallocate output vector.
    m = zeros(size(t));
    
    % Optionally, warn if time vector doesn't cover all symbols.
    if t(end) < length(a_temp) * Tb
        warning('Time vector t does not cover the entire symbol sequence.');
    end
    
    % Loop over each symbol and assign it to the corresponding time interval.
    for k = 1:length(a_temp)
        mask = (t >= ((tau_temp/2) + gamma_temp) + (k-1)*Tb) & (t < ((tau_temp/2) + gamma_temp) + k*Tb);
        m(mask) = a_temp(k);
    end
end
