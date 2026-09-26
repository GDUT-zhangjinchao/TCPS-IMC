function res = shrink(x,a)
   % It is equal to `wthresh(x, 's', a)`
   res=sign(x).*( max(abs(x)-a,0));
end