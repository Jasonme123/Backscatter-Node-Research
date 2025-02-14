Total_time = .1;
fs = 1e-7;
t = 0:fs:Total_time-fs;  % single-chirp time vector
Tb = 1e-5;

numNodes = 10;
nodes = createNodes(numNodes);

% Display properties of the first node:
fprintf('Node Coordinates: (%.2f, %.2f)\n', nodes(1).x, nodes(1).y);
fprintf('Round-trip delay (tau): %e s\n', nodes(1).tau);
fprintf('First 20 bits of bitString: %s\n', num2str(nodes(1).bitString(1:20)));

% Display properties of the first node:
fprintf('Node Coordinates: (%.2f, %.2f)\n', nodes(2).x, nodes(2).y);
fprintf('Round-trip delay (tau): %e s\n', nodes(2).tau);
fprintf('First 20 bits of bitString: %s\n', num2str(nodes(2).bitString(1:20)));


nodes(1).bitwaveformString = backscatterSymbolGen(nodes(1).bitString,Tb,t);

plot(nodes(1).bitwaveformString);

