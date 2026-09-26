function [val] = getB(val,ExistIndex,i)
    %删除缺失行
    val(:,ExistIndex(:,i) == 0) = 0;
end