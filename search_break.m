%%����ת��ʱ��������ļ�����ѯʱ��ϵ�ĸ���break_num������break_ind
%��file='./shuju1.xlsx'
function [break_num,break_ind]=search_break(file)
    [num,~]=xlsread(file);
    num=num(:,1);
    n=length(num);
    k=0;
    index=zeros(n,1);
    for i=1:1:n-1
        if((num(i)+1)~=num(i+1))
            k=k+1;
            index(k)=i;
        end
    end
    index=index(1:k);
    break_num=k;
    break_ind=index;
end
