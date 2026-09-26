function P = updateP(X,A,Z,ExistIndex,v)
P = cell(1,v);
for i=1:v
    [U,~,V] = svd(getB(A{i}*Z{i},ExistIndex,i)*X{i}',"econ");
    P{i} = U*V';
end
end