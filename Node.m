classdef Node
    % Node  Backscatter tag in a 2D ranging simulation.
    % Holds just the 2D position. 
    properties
        x   % x-coordinate (m)
        y   % y-coordinate (m)
    end

    properties (Dependent)
        range   % Distance from origin (m)
    end

    methods
        function obj = Node(x, y)
            if nargin < 2 || isempty(x) || isempty(y)
                x = 0;
                y = 0;
            end
            obj.x = x;
            obj.y = y;
        end

        function R = get.range(obj)
            R = sqrt(obj.x^2 + obj.y^2);
        end
    end
end
