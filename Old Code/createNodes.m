

function nodes = createNodes(numNodes)
    % Preallocate an array of Node objects
    nodes(numNodes) = Node();  % Preallocate for speed
    
    for k = 1:numNodes
        % You can customize each node's parameters here if needed
        nodes(k) = Node();  % Default constructor generates random x, y, and bitString
    end
end
