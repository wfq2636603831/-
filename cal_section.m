%输入的是处理好的数据,怠速不超过180s，每一段从怠速开始
%cont_section=运动学片段数
%section=第几个片段
%N:最终有用的数据数
clc;clear;
t1=clock;
[data,txt]=xlsread('./shuju1_X_cl_a_v0_180.xlsx');
n=length(data);
[break_num,break_ind]=search_break('./shuju1_X_cl_a_v0_180.xlsx'); %break_num个断点，索引是break_ind
GPS_V=data(:,2);
daisu=data(:,5); %怠速的为0
section=zeros(n,1);
point=[0;break_ind;n];
k=0;   %每一段里片段数
used_k=0;
count_section=0;   %总运动学片段数
Opoint=zeros(n,1);
for i=1:1:break_num+1   %段数
    for j=1:1:(point(i+1)-point(i))-1   %每段中数据
        if((daisu(point(i)+j)==1)&&(daisu(point(i)+j+1)==0))
            k=k+1;
            Opoint(k)=point(i)+j;   %片段开始的索引
            if(k==1)
                long=j;
            else
                long=point(i)+j-Opoint(k-1);
            end
            if(long>19)    %长度达到20个才作为运动学片段
                used_k=used_k+1;
                count_section=count_section+1;
                if(k==1)
                    ind=(point(i)+1):1:(point(i)+j);
                    section(ind)=count_section;
                else
                    ind=(Opoint(k-1):1:point(i)+j);
                    section(ind)=count_section;
                end
            end
        end 
    end
    k=0;
end
data=[data,section];
% xlswrite('./test1xx_cl_a_v0_180.xlsx',{'section'},1,'F1');
% xlswrite('./test1xx_cl_a_v0_180.xlsx',section,1,'F2');
%% 把不是片段内的数据删掉
for i=1:1:n
    if(section(n-i+1)==0)
        data(n-i+1,:)=[];
    end
end
section=data(:,6);    
%%
title={'时间','GPS车速','加速度','select','daisu','section'};
xlswrite('./shuju1_finished.xlsx',title,1,'A1');
xlswrite('./shuju1_finished.xlsx',data,1,'A2');
N=length(data);   %最终有用的数据数
fprintf('程序运行时间：%f\n',etime(clock,t1));
