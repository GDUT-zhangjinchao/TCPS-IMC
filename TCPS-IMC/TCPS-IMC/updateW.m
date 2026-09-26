function [W_bar,Y_1] = updateW(Z,Y_1,lambda,mu,v)
% 构造张量
W = cell(1,v);
for i = 1:v
    W{i} = Z{i};
end

W_tensor = cat(3,W{:,:});
Y_tensor = cat(3,Y_1{:,:});

% 执行TNN
Ten = shiftdim(W_tensor + Y_tensor/mu, 2);
[W_bar_tensor, ~] = prox_tnn(Ten, lambda/mu);
W_bar_tensor = shiftdim(W_bar_tensor, 1);

% 构造
Y_tensor = Y_tensor + mu*(W_tensor - W_bar_tensor);

%转为矩阵
W_bar = cell(1,v);
for i = 1:v
    Y_1{i} = Y_tensor(:,:,i);
    W_bar{i} = W_bar_tensor(:,:,i);
end
end
