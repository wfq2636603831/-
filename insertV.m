%间隔ksec秒或以内，用平均插值。间隔ksec秒以上(如ksec=4)，就不再插值，就按间隔分段,num为去表头以外数据
%infile为插值前文件，outfile为插值后文件
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
        