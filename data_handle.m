clc;clear;
t1=clock;
%转换时间格式，取数据
data11=transform_time('./文件1.xlsx','./shuju1.xlsx');
%对时间不连续点且间隔小于等于5s，插值
[suminsertnum1,data11X]=insertV('./shuju1.xlsx','./shuju1_X.xlsx',5); 
%统计插值后的间断点数和索引
[break_num,break_ind]=search_break('./shuju1_X.xlsx');  %间断点的数量和索引
%% 计算每段的加速度，每一点的加速度等于下一秒速度减去此刻的速度，最后一秒的速度等于前一秒的速度
n=length(data11X); %插值后的总数据量
point=[0;break_ind;n]; 
accele=zeros(n,1);
for i=1:1:break_num+1  %一共break_num1段
    for j=1:1:(point(i+1)-point(i))-1  %每段里有(point(i+1)-point(i))秒（点）
        a=data11X(point(i)+j+1,2)-data11X(point(i)+j,2);
        accele(point(i)+j)=a;
    end
    accele(point(i)+j+1)=a;
end
clear a i j;
data111X=[data11X,accele]; %加入第三列：加速度
xlswrite('./shuju1_X.xlsx',{'加速度'},1,'C1');
xlswrite('./shuju1_X.xlsx',accele,1,'C2');
%% 处理加速度异常
[a_num,a_ind]=abnormal_accele(accele);
for i=1:1:a_num   %异常加速度最近三点均值
    accele(a_ind(i))=(accele(a_ind(i)-1)+accele(a_ind(i))+accele(a_ind(i)+1))/3;
end
clear a_num a_ind;
[a_num1,a_ind1]=abnormal_accele(accele); %处理后加速度仍然不合格的数量和索引
data111X(:,3)=[];
data111X(:,3)=accele;
xlswrite('./shuju1_X.xlsx',accele,1,'C2');
%删除加速度仍然不合格的数据
for i=1:1:a_num1
    data111X(a_ind1(a_num1-i+1),:)=[];
end
clear a_num1 a_ind1 accele;
title={'时间','GPS车速','加速度'};
xlswrite('./shuju1_X_cl_a.xlsx',title,1,'A1');
xlswrite('./shuju1_X_cl_a.xlsx',data111X,1,'A2'); %已经删除了加速度异常的数据
%%  删除每段刚开始，和最后，不是怠速的，v<10的。
n=length(data111X);  %已经删除了加速度异常的数据
[break_num2,break_ind2]=search_break('./shuju1_X_cl_a.xlsx');
GPS_V=data111X(:,2);
select=ones(n,1);
point2=[0;break_ind2;n];
for i=1:1:break_num2+1   %（break_num2+1）段    %前端不是怠速的
    for j=1:1:(point2(i+1)-point2(i))
        if(GPS_V(point2(i)+j)>10)
            select(point2(i)+j)=0;
        else
            break;
        end
    end
end
for i=1:1:break_num2+1   %（break_num2+1）段  %后端不是怠速的
    for j=1:1:(point2(i+1)-point2(i))
        if(GPS_V(point2(i+1)-j+1)>10)
            select(point2(i+1)-j+1)=0;
        else
            break;
        end
    end
end
clear i j;
data111X=[data111X,select]; %select=0的代表每段刚开始，和最后，不是怠速的。
for i=1:1:n    %把select=0的数据删除
    if (select(n-i+1)==0)
        data111X((n-i+1),:)=[];
    end
end
%% 把怠速超过180s的部分删掉,从前往后删
n=length(data111X);  %删除每段开始不是怠速的数据
title(1,4)={'select'};
xlswrite('./shuju1_X_cl_a_v0.xlsx',title,1,'A1');
xlswrite('./shuju1_X_cl_a_v0.xlsx',data111X,1,'A2');
[break_num3,break_ind3]=search_break('./shuju1_X_cl_a_v0.xlsx'); %删除异常加速度和每段开始不是怠速的数据之后
GPS_V=data111X(:,2);
point3=[0;break_ind3;n];
k=0;%怠速时长计数
select=ones(n,1); %1：保留，0：多于
daisu=ones(n,1); % 0:怠速（速度小，接近0）
for i=1:1:break_num3+1   %段
    long=point3(i+1)-point3(i);  %每段长度
    for j=1:1:long
        if(GPS_V(point3(i)+j)<10)
            k=k+1;
            daisu(point3(i)+j)=0; %怠速状态
            if(k>180)
                select(point3(i)+j-180)=0; %从怠速开始后删
            end
        else
            k=0;
        end
    end
end
clear i j k long;
data111X=[data111X(:,1:3),select,daisu]; %select=0的代表超过180s的部分，daisu=0代表怠速部分。
for i=1:1:n    %把select=0的数据删除
    if (select(n-i+1)==0)
        data111X((n-i+1),:)=[];
    end
end  
clear i;
n_180=length(data111X);  %删除怠速超过180s的数据
title(1,5)={'daisu'};
xlswrite('./shuju1_X_cl_a_v0_180.xlsx',title,1,'A1')
xlswrite('./shuju1_X_cl_a_v0_180.xlsx',data111X,1,'A2')
[break_num4,break_ind4]=search_break('./shuju1_X_cl_a_v0_180.xlsx');%删除怠速超过180s后
t2=clock;
fprintf('程序运行时间：%f\n',etime(clock,t1));
