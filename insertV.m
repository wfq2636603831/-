%���ksec������ڣ���ƽ����ֵ�����ksec������(��ksec=4)���Ͳ��ٲ�ֵ���Ͱ�����ֶ�,numΪȥ��ͷ��������
%infileΪ��ֵǰ�ļ���outfileΪ��ֵ���ļ�
function [suminsertnum,num]=insertV(infile,outfile,ksec)
    [break_num1,break_ind1]=search_break(infile);
    [num,txt]=xlsread(infile);
    suminsertnum=0;
    %a1=length(num);
    for i=1:1:break_num1
        point=break_ind1(i)+suminsertnum;
        step=num(point+1,1)-num(point,1);
        if(step<ksec+1)
            insertnum=step-1;
            suminsertnum=suminsertnum+insertnum;
            addv=(num(point+1,2)-num(point,2))/step;
            insert=zeros(insertnum,2);
            for j=1:1:insertnum
                insert(j,1)=num(point,1)+j;
                insert(j,2)=num(point,2)+j*addv;
            end
            num=[num(1:point,:);insert;num(point+1:end,:)];
        end
    end
    %a2=length(num)-a1;
    xlswrite(outfile,txt);
    xlswrite(outfile,num,1,'A2');
end
        