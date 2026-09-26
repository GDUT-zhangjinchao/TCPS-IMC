function [Z,A,E,Q,S,G,P,W_bar,D,Y_1,Y_2,Y_3,v,K] = initOther(X,q,d_k)
    % 初始化
    v = length(X);
    % 预分配所有元胞数组
    Z = cell(1,v);
    A = cell(1,v);
    E = cell(1,v);
    Q = cell(1,v);
    W_bar = cell(1,v);
    D = cell(1,v);
    Y_1 = cell(1,v);
    Y_2 = cell(1,v);
    Y_3 = cell(1,v);
    P = cell(1,v);
    for i = 1:v
        [d,nn] = size(X{i});
        W_bar{i} = zeros(q,nn);
        Y_1{i} = zeros(q,nn);
        Y_2{i} = zeros(q,nn);
        Y_3{i} = zeros(q,nn);
        P{i} = zeros(d_k,d);
        A{i} = zeros(d_k,q);
        D{i} = zeros(q,nn);
        E{i} = zeros(q,nn);
        Q{i} = zeros(q,nn);
        Z{i} = (zeros(q,nn));
        K{i} = ones(q,nn) * 1/v;
    end
    G = zeros(q,nn);
    S = zeros(q,nn);
end