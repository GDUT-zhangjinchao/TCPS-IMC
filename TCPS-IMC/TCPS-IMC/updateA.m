function [A] = updateA(X,P,Z,ExistIndex,v)
A = cell(1,v);
tpZ = 0;
for i=1:v
    tpZ = tpZ+Z{i};
end
for  i = 1 : v
    [U,~,V] = svd(getB(P{i}*X{i},ExistIndex,i)*1/v*tpZ',"econ");
    A{i} = U*V';
end
end