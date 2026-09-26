function [paramater ] =set_parameter(dataname)
%%
%% alpha, lambda, delta, gamma, m, omega1, omega2, omega3
if(dataname == "ORL_mtv")
    % 参数设置
    paramater(1,:) = [1e-2,2^-2,1e1,1e-3,1,0.5,0.3,0.2]; %90配对
    paramater(2,:) = [1e-2,2^-3,10,10,1,0.5,0.3,0.2]; %70配对
    paramater(3,:) = [1e-1,2^1,1,1e-1,1,0.5,0.3,0.2]; %50配对
    paramater(4,:) = [1,2^4,10,1,1,0.5,0.3,0.2]; %30配对
    paramater(5,:) = [1e-2,2^-3,10,1,1,0.5,0.3,0.2]; %10配对
end
end
