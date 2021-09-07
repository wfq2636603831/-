
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
Pian_Duan=cell(count_section,1);   %Ԫ����count_section����ÿ������һ��Ƭ��
for i=1:1:count_section
    Pian_Duan{i,1}=data(point(i)+1:point(i+1),:);
end
%%
col=10;
title={'1Ƭ��','2ƽ���ٶ�','3ƽ����ʻ�ٶ�','4����ʱ���','5ƽ�����ٶ�','6ƽ�����ٶ�','7����ʱ���','8����ʱ���','9�ٶȱ�׼��','10���ٶȱ�׼��'};
feature=zeros(count_section,col);   %count_section���˶�ѧƬ����
for i=1:1:count_section
    feature(i,1)=i;
end

for i=1:1:count_section
    pianduan=Pian_Duan{i};
    num=length(pianduan);   %Ƭ�γ�
    av=sum(pianduan(:,3))/num;   %ƽ���ٶ�
    aa=sum(pianduan(:,4))/num;
    sumV=0;  %�ǵ����ٶȺ�
    m=0;  %�ǵ��ٸ���
    num_ia=0; %���ٸ���
    sum_ia=0;  %���ٶȺ�
    num_da=0; %���ٸ���
    sum_da=0; %���ٶȺ�
    V_pingfangcha=0;
    A_pingfangcha=0;
    for j=1:1:num
        if(pianduan(j,2)==1)  %f�ǵ���
            m=m+1;
            sumV=sumV+pianduan(j,3);
        end
        if(pianduan(j,4)>0.1)   %����
            num_ia=num_ia+1;
            sum_ia=sum_ia+pianduan(j,4);
        end
        if(pianduan(j,4)<-0.1)   %����
            num_da=num_da+1;
            sum_da=sum_da+pianduan(j,4);
        end
        V_pingfangcha=V_pingfangcha+(pianduan(j,3)-av)^2;
        A_pingfangcha=A_pingfangcha+(pianduan(j,4)-aa)^2;
    end
    adv=sumV/sum(pianduan(:,2));   %ƽ����ʻ�ٶ�
    slow_per=1-m/num;   %����ʱ���
    aia=sum_ia/num_ia;  %ƽ�����ٶ�
    ada=sum_da/num_da;      %ƽ�����ٶ�
    ia_time_per=num_ia/num;     %����ʱ���
    da_time_per=num_da/num;     %����ʱ���
    Vstd=sqrt(V_pingfangcha/(num-1));   %�ٶȱ�׼��
    Astd=sqrt(A_pingfangcha/(num-1));      %���ٶȱ�׼��
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
