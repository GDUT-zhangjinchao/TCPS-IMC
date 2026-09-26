function [indicator, X] = initializeAnchor(X,q)
%% Input
%%%         X               The feature of views with m_v * n 
%%%                         and `n` be the number of sample
%%%         
%%%         q               The number of anchors selected from each view
%%%
%% Ouput
%%%         indicator       An indicator of clusters
    V = length(X);
    N = size(X{1},2);
    XX = [];
    indicator = zeros(q,N);
    for p = 1 : V
        X{p} = mapstd(X{p},0,1);
        XX = [XX;X{p}];
    end
    [XU,~,~]=svds(XX',q);
    [IDX,~] = kmeans(XU,q, 'MaxIter',100,'Replicates',10);
    for i = 1:N
        indicator(IDX(i),i) = 1;
    end
end