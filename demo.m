
clear,clc;
addpath(genpath('./'));
% 设定缺失率
pr = [0.9,0.7,0.5,0.3,0.1];
% 设定数据集路径
datapath = ".\datasets\";
%datanames = {"NGs","ORL_mtv","COIL20","CCV","Caltech101-all","NUSWIDEOBJ","cifar10"};
datanames = {"ORL_mtv"};
%profile on;
for dddd = 1:length(datanames)
    % 选择数据集
    dataname = datanames{dddd};
    fprintf("---------------------------------------"+dataname+"--------------------------------------- \n");
    for i = 1:length(pr)
        % 加载数据集
        path = datapath+dataname+"/"+dataname+"_per"+num2str(pr(i))+".mat";
        load(path,'data','truelabel','index');
        gt = truelabel{1};
        n = length(gt);
        v = length(truelabel);
        cls_num = length(unique(gt));

        % 数据预处理
        tic;
        [X1, ind] = findindex(data, index);
        time1 = toc;

        % 设定最好的结果
        BestRes = zeros(1,9);
        BestStd = zeros(1,9);

        % 遍历参数
        Grid = [];
        ATime= [];

        % 参数设置
        parameter = set_parameter(dataname);
        options.d_k = 3;
        
        options.alpha = parameter(i,1);
        options.lamdba = parameter(i,2);
        options.delta = parameter(i,3);
        options.gamma = parameter(i,4);
        options.q = parameter(i,5);
        options.omega1 = parameter(i,6);
        options.omega2 = parameter(i,7);
        options.omega3 = parameter(i,8);
        % 模型训练
        tic;
        [Q,S,G,E,Z,obj,iter,R1,R2,R3] = TCPS_IMC(X1, gt, ind, options);
        [UU,~,V]=svd(G','econ');
        F = UU(:,1:cls_num);
        GG = F ./ (repmat(sqrt(sum(F .^ 2, 2)), 1, cls_num));
        time2 = toc;

        % 设定随机数，保证实验可以复现
        rng('default');
        rng(6666);

        % 评估
        results = zeros(20,9);
        tic;
        for kk = 1:20
            pY = kmeans(GG, cls_num, 'maxiter', 1000, 'replicates', 20, 'emptyaction', 'singleton');
            kres = Clustering9Measure(gt, pY);
            results(kk,:) = kres;
        end
        time3 = toc;

        % 计算结果
        RES = mean(results,1);
        STD = std(results,[],1);
        time = time1+time2+time3/20;
        BestQ = Q;
        BestZ = Z;
        BestF = F;
        BestS = S;
        BestE = E;
        BestG = G;
        BestGG = GG;
        BestObj = obj;
        Bestiter = iter;
        BestR1 = R1;
        BestR2 = R2;
        BestR3 = R3;
        % 打印结果
        fprintf(dataname+'[%d%%]-th acc:%.4f+-%.4f, MIhat:%.4f+-%.4f, Purity:%.4f+-%.4f time:%.4f iter:%.d ', ...
            pr(i)*100,RES(1),STD(1),RES(2),STD(2),RES(3),STD(3),time,iter);
        fprintf("alpha:%.4f lamdba:%.4f delta:%.4f gamma:%.4f anchor:%.4f omega1:%.4f omega2:%.4f omega3:%.4f \n", ...
            options.alpha,options.lamdba,options.delta,options.gamma,options.q,options.omega1,options.omega2,options.omega3);

        % 存放这次参数的结果
        ress = {RES(1),RES(2),RES(3),RES(4),RES(5),RES(6),RES(7),RES(8),RES(9),...
            STD(1),STD(2),STD(3),STD(4),STD(5),STD(6),STD(7),STD(8),STD(9),...
            time,length(obj),options.alpha,options.lamdba,options.delta,options.gamma,options.q,options.omega1,options.omega2,options.omega3};

        % 存放最好的结果
        path = "./Result/"+dataname+"/"+ dataname+"_per"+num2str(pr(i))+".mat";
        save(path,"RES","STD","BestQ","BestF","BestE","BestZ","BestS","BestG","BestGG","BestObj","Bestiter","results","BestR1","BestR2","BestR3");

        rep_res(i,:) = RES;
        rep_std(i,:) = STD;
    end
    % 保存结果
    path = "./Result/"+dataname+"/";
    path = path + dataname;
    path = path+'_res.mat';
    save(path,'rep_res','rep_std');
end
%profile off;
%profile viewer;