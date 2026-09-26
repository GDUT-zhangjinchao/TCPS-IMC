function [T] = updateT(term)
    [q, n] = size(term);
    T = zeros(q,n);
    for i=1:n
        T(:,i) = EProjSimplex_new(term(:,i));
    end
end
