
%generate a symbol

%a_k: Symbol array, a_k belongs to [1,-1]
%Tb: Symbol Period (s)
%t: time array

function m = symbolGen(a_k,Tb,t)
    % Initialize the output vector m to zeros.
    m = zeros(size(t));
    
    % Loop over each symbol in a_k.
    for k = 1:length(a_k)
        if abs(a_k(k)) ~= 1
        error("Symbols values are not all 1 or -1")
        end
        % Define the mask for the time interval for the k-th symbol.
        mask = (t >= (k-1)*Tb) & (t < k*Tb);
        
        % Assign the k-th symbol to the corresponding indices in m.
        m(mask) = a_k(k);
    end
end
