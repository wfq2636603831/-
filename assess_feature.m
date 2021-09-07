
clc;clear;
[indata,txt]=xlsread('./shuju1_finished.xlsx');
GPS_V=indata(:,2);
accele=indata(:,3);
daisu=indata(:,5);
section=indata(:,6);
n=length(indata);
data=zeros(n,4);
count_section=section(n);
data(:,1)=section;
data(:,2)=daisu;
data(:,3)=GPS_V;
data(:,4)=accele;
duandian=zeros(count_section-1,1);
k=0;
%%
for i=1:1:n-1
    if (section(i)~=section(i+1))
        k=k+1;
        duandian(k)=i;
    end
end
point=[0;duandian;n];
Pian_Duan=cell(count_section,1);   %元胞，count_section个，每个都是一个片段
for i=1:1:count_section
    Pian_Duan{i,1}=data(point(i)+1:point(i+1),:);
end
%%
col=10;
title={'1片段','2平均速度','3平均行驶速度','4怠速时间比','5平均加速度','6平均减速度','7加速时间比','8减速时间比','9速度标准差','10加速度标准差'};
feature=zeros(count_section,col);   %count_section：运动学片段数
for i=1:1:count_section
    feature(i,1)=i;
end

for i=1:1:count_section
    pianduan=Pian_Duan{i};
    num=length(pianduan);   %片段长
    av=sum(pianduan(:,3))/num;   %平均速度
    aa=sum(pianduan(:,4))/num;
    sumV=0;  %非怠速速度和
    m=0;  %非怠速个数
    num_ia=0; %加速个数
    sum_ia=0;  %加速度和
    num_da=0; %减速个数
    sum_da=0; %减速度和
    V_pingfangcha=0;
    A_pingfangcha=0;
    for j=1:1:num
        if(pianduan(j,2)==1)  %f非怠速
            m=m+1;
            sumV=sumV+pianduan(j,3);
        end
        if(pianduan(j,4)>0.1)   %加速
            num_ia=num_ia+1;
            sum_ia=sum_ia+pianduan(j,4);
        end
        if(pianduan(j,4)<-0.1)   %减速
            num_da=num_da+1;
            sum_da=sum_da+pianduan(j,4);
        end
        V_pingfangcha=V_pingfangcha+(pianduan(j,3)-av)^2;
        A_pingfangcha=A_pingfangcha+(pianduan(j,4)-aa)^2;
    end
    adv=sumV/sum(pianduan(:,2));   %平均行驶速度
    slow_per=1-m/num;   %怠速时间比
    aia=sum_ia/num_ia;  %平均加速度
    ada=sum_da/num_da;      %平均减速度
    ia_time_per=num_ia/num;     %加速时间比
    da_time_per=num_da/num;     %减速时间比
    Vstd=sqrt(V_pingfangcha/(num-1));   %速度标准差
    Astd=sqrt(A_pingfangcha/(num-1));      %加速度标准差
    feature(i,2)=av;
    feature(i,3)=adv;
    feature(i,4)=slow_per;
    feature(i,5)=aia;
    feature(i,6)=ada;
    feature(i,7)=ia_time_per;
    feature(i,8)=da_time_per;
    feature(i,9)=Vstd;
    feature(i,10)=Astd;   
end
xlswrite('./feature.xlsx',title,1,'A1');
xlswrite('./feature.xlsx',feature,1,'A2');
