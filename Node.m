classdef Node
    % Node Class representing a backscatter node in an FMCW radar simulation.
    
    properties
        x          % x-coordinate (meters, between 1 and 100)
        y          % y-coordinate (meters, between 1 and 100)
        attenuation  % Scaling factor for the reflected signal
        data       % Modulation data (e.g., +1 or -1, can be scalar or vector)
        bitString  % A random binary sequence (1000 bits long)
        bitwaveformString %Time domin binary sequence
        gamma      %clock delay
    end
    
    properties (Dependent)
        tau        % Round-trip delay computed from distance (using x and y)
    end
    
    methods
        % Constructor: Creates a new Node object
        function obj = Node(x, y, data, attenuation, bitString, bitwaveformString, gamma)
            % If x or y are not provided, generate random coordinates between 1 and 100.
            if nargin < 2 || isempty(x) || isempty(y)
                x = 1 + (100-1)*rand();
                y = 1 + (100-1)*rand();
            end
            
            % If modulation data is not provided, default to +1.
            if nargin < 3 || isempty(data)
                data = 1;
            end
            
            % If amplitude is not provided, default to 1.
            if nargin < 4 || isempty(attenuation)
                attenuation = 1;
            end
            
            % If bitString is not provided, generate a random binary vector of length 1000.
            if nargin < 5 || isempty(bitString)
                bitString = randi([0, 1], 1, 100);
            end

            % Time Domain Waveform.
            if nargin < 6 || isempty(bitwaveformString)
                bitwaveformString =  0;
            end

            % Clock Phase Delay between radar clock and node clock.
            if nargin < 7 || isempty(bitwaveformString)
                % random Delay between 1e-7 and 1e-9
                %gamma =  1e-7 + (1e-9 - 1e-7) * rand(); 
                gamma = 0;
            end
            obj.x = x;
            obj.y = y;
            obj.data = data;
            obj.attenuation = attenuation;
            obj.bitString = bitString;
            obj.bitwaveformString = bitwaveformString;
            obj.gamma = gamma;
        end
        
        % Getter for the dependent property tau
        % Computes the round-trip delay based on the Euclidean distance from (0,0)
        function tau = get.tau(obj)
            c = 3e8;  % Speed of light in m/s
            R = sqrt(obj.x^2 + obj.y^2);
            tau = 2 * R / c;
        end
    end
end
