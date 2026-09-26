function [Q,S,G,E,Z,obj,iter,R1,R2,R3] = TCPS_IMC(X,Y,ExistIndex,options)

% 拉格朗日乘数
options.mu = 0.1;
options.max_mu = 1e10;
options.pho_mu = 2;
mu = options.mu;                        % 拉格朗日乘子
pho_mu = options.pho_mu;
max_mu = options.max_mu;

num_of_clusters = length(unique(Y));    % 真实聚类数

d_k = options.d_k*num_of_clusters;      % 投影的维度 (d_k*c)
q = options.q*num_of_clusters;          % 锚点的个数（q*c）

alpha = options.alpha;
lambda = options.lamdba;                % 张量核范数的参数

gamma = options.gamma;                  % 不一致图的参数
delta = options.delta;                  % 部分一致图的参数
omega1 = options.omega1;                  % 一致图的权重
omega2 = options.omega2;                  % 部分一致图的权重
omega3 = options.omega3;                  % 特异图的权重
epsilon = 1e-3;
% 初始化
[Z,A,E,Q,S,G,P,W_bar,D,Y_1,Y_2,Y_3,v,k] = initOther(X,q,d_k);

% 开始迭代
T = 30;
obj = zeros(1,T);
R1 = zeros(1,T);
R2 = zeros(1,T);
R3 = zeros(1,T);

for iter = 1:T
    % 更新锚图
    Z = updateZ(X,P,A,E,Z,S,Q,ExistIndex,W_bar,Y_1,Y_2,alpha,mu,omega1,omega2,omega3,v);

    % TNN
    [W_bar,Y_1] = updateW(Z,Y_1,lambda,mu,v);

    % 更新投影矩阵
    P = updateP(X,A,Z,ExistIndex,v);

    % 更新锚点
    A = updateA(X,P,Z,ExistIndex,v);

    % 更新完全一致图
    S = updateS(Z,Q,E,G,Y_2,mu,omega1,omega2,omega3,v);

    % 更新部分一致图
    Q = updateQ(Z,S,Q,E,G,D,Y_2,Y_3,mu,omega1,omega2,omega3,v,k);

    % 更新完全不一致图
    E = updateE(Z,S,Q,E,G,Y_2,gamma,mu,omega1,omega2,omega3,v);
    
    % 更新融合图
    G = updateG(S,Q,E,omega1,omega2,omega3,v);

    % 哈达玛积
    [D,Y_3] = updateD(Q,D,Y_3,delta,mu,v);

    % 更新Y_2

    for i = 1:v
        Y_2{i} = Y_2{i}+mu*(Z{i} - (omega1*S+omega2*Q{i}+omega3*E{i}));
    end

    % 更新拉格朗日乘子
    mu = min(mu*pho_mu,max_mu);

    % 计算损失
    term1 = 0;
    tpQ = 0;
    tpE = 0;
    term3=0;
    term4=0;
    term5=0;
    for iv = 1:v
        term1 = term1 + norm(getB(P{iv}*X{iv},ExistIndex,iv)-getB(A{iv}*Z{iv},ExistIndex,iv),'fro')^2;
        tpQ = tpQ+Q{iv};
        tpE = tpE+E{iv};
        term3=term3+norm(Z{iv}-W_bar{iv}+Y_1{iv}/mu,'fro')^2;
        term4=term4+norm(Z{iv}-(omega1*S+omega2*Q{iv}+omega3*E{iv})+Y_2{iv}/mu,'fro')^2;
        term5=term5+norm(Q{iv}-D{iv}+Y_3{iv}/mu,'fro')^2;
    end
    for iv = 1:v
        K{iv} = Q{iv}./tpQ;
    end
    term2 = norm((G-(omega1*S+omega2*1/v*tpQ+omega3*1/v*tpE)),'fro')^2;
    term1 = alpha*term1;
    term3 = mu/2*term3;
    term4 = mu/2*term4;
    term5 = mu/2*term5;
    termLoss = term1+term2+term3+term4+term5;
    obj(iter) = termLoss;
    
    % 计算收敛约束条件
    r1 = 0;
    r2 = 0;
    r3 = 0;
    for iv = 1:v
        r1 = r1+max(abs(Z{iv} - W_bar{iv}),[], 'all');
        r2 = r2+max(abs(Z{iv} - (omega1*S+omega2*Q{iv}+omega3*E{iv})),[], 'all');
        r3 = r3+max(abs(Q{iv} - D{iv}),[], 'all');
    end

    R1(iter) = r1;
    R2(iter) = r2;
    R3(iter) = r3;
    
    if (iter>=2) && R1(iter)<=epsilon && R2(iter)<=epsilon && R3(iter)<=epsilon || iter>=T || obj(iter) < 1e-10
        break;
    end

end
end
