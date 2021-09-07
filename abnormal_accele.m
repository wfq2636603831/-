%统计加速度异常的数量num和索引ind
function [num,ind]=abnormal_accele(accele)
n=length(accele);
num=0;
ind=zeros(n,1);
for i=1:1:n
    if(accele(i)>4||accele(i)<-7.75)
        num=num+1;
        ind(num)=i;
    end
end
ind=ind(1:num);