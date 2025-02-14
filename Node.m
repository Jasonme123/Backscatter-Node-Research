classdef Node
    % Node Class representing a backscatter node in an FMCW radar simulation.
    
    properties
        R          % Range (distance) in meters
        amplitude  % Scaling factor for the reflected signal
        data       % Modulation data (e.g., +1 or -1, can be scalar or vector)
    end
    
    properties (Dependent)
        tau        % Round-trip delay computed from R
    end
    
    methods
        % Constructor: Creates a new Node object
        function obj = Node(R, data, amplitude)
            if nargin < 3
                amplitude = 1;  % Default amplitude if not provided
            end
            obj.R = R;
            obj.data = data;
            obj.amplitude = amplitude;
        end
        
        % Getter for the dependent property tau
        function tau = get.tau(obj)
            c = 3e8;         % Speed of light in m/s
            tau = 2 * obj.R / c;
        end
        
        % reflect method: Simulates the node reflecting the transmitted chirp.
        % tx_chirp: the transmitted chirp signal (vector)
        % t: time vector corresponding to tx_chirp
        %
        % The method returns the reflected signal which is a delayed and modulated
        % copy of the transmitted chirp.
        function y = reflect(obj, tx_chirp, t)
            % Compute the delayed time vector
            t_delayed = t - obj.tau;
            
            % Use interpolation to simulate the delay.
            % Any t_delayed values outside t's range are set to 0.
            delayed_chirp = interp1(t, tx_chirp, t_delayed, 'linear', 0);
            
            % Apply the node's modulation and amplitude scaling.
            % If data is a scalar (e.g., +1 or -1) then multiply directly.
            % (You could extend this to support symbol-by-symbol modulation.)
            y = obj.amplitude * delayed_chirp * obj.data;
        end
    end
end
