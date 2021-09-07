clc;clear;
%转换时间格式，取数据
data11=transform_time('./文件1.xlsx','./shuju1.xlsx');
%对时间不连续点且间隔小于等于4s，插值
[suminsertnum1,data11X]=insertV('./shuju1.xlsx','./shuju1xx.xlsx',4); 
%统计插值后的间断点数和索引
[break_num1,break_ind1]=search_break('./shuju1xx.xlsx');
%% 计算每段的加速度，每一点的加速度等于下一秒速度减去此刻的速度，最后一秒的速度等于前一秒的速度
n=length(data11X);
point=[0;break_ind1;n];
accele=zeros(n,1);
for i=1:1:break_num1+1  %一共break_num1段
    for j=1:1:(point(i+1)-point(i))-1  %每段里有(point(i+1)-point(i))秒（点）
        a=data11X(point(i)+j+1,2)-data11X(point(i)+j,2);
        accele(point(i)+j)=a;
    end
    accele(point(i)+j+1)=a;
end
clear a i j;
data111X=[data11X,accele]; %加入第三列：加速度
xlswrite('./shuju1xx.xlsx',{'加速度'},1,'C1');
xlswrite('./shuju1xx.xlsx',accele,1,'C2');
%%
