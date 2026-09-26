function [D,Y_3] = updateD(Q,D,Y_3,delta,mu,v)
tp = 0;
for i = 1:v
    tp = tp+ abs(D{i});
end
for i = 1:v
    D{i} = shrink(Q{i}+Y_3{i}/mu, delta*(tp-abs(D{i})) / mu);
    Y_3{i} = Y_3{i} +mu*(Q{i} - D{i});
end
end