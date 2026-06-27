function nodes = placeNodes2D(N, range_min, range_max, mode)
% placeNodes2D  Place N backscatter Node objects in 2D at random positions.
%
%   nodes = placeNodes2D(N, range_min, range_max, mode)
%
% Inputs:
%   N         : number of tags
%   range_min : min tag-to-reader distance (m)
%   range_max : max tag-to-reader distance (m)
%   mode      : 'fixed'  -> same positions every run (deterministic seed)
%               'random' -> different positions every run
%
% Output:
%   nodes : 1xN array of Node objects


%Create a seed for the random positioning of nodes
    if nargin < 4 || isempty(mode), mode = 'fixed'; end

    switch lower(mode)
        case 'fixed'
            s = RandStream('twister', 'Seed', 7);
        case 'random'
            s = RandStream('twister', 'Seed', 'shuffle');
        otherwise
            error('placeNodes2D:badMode', '(got ''%s'').', mode);
    end

%Assigning position based on seeds
    nodes(N) = Node();
    for n = 1:N
        th = 2*pi*rand(s);                                 %assigning angle to nodes
        r  = range_min + (range_max - range_min)*rand(s);  %assigning radius
        nodes(n) = Node(r*cos(th), r*sin(th));
    end
end
