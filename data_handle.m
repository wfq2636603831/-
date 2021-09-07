clc;clear;
t1=clock;
%ת��ʱ���ʽ��ȡ����
data11=transform_time('./�ļ�1.xlsx','./shuju1.xlsx');
%��ʱ�䲻�������Ҽ��С�ڵ���5s����ֵ
[suminsertnum1,data11X]=insertV('./shuju1.xlsx','./shuju1_X.xlsx',5); 
%ͳ�Ʋ�ֵ��ļ�ϵ���������
[break_num,break_ind]=search_break('./shuju1_X.xlsx');  %��ϵ������������
%% ����ÿ�εļ��ٶȣ�ÿһ��ļ��ٶȵ�����һ���ٶȼ�ȥ�˿̵��ٶȣ����һ����ٶȵ���ǰһ����ٶ�
n=length(data11X); %��ֵ�����������
point=[0;break_ind;n]; 
accele=zeros(n,1);
for i=1:1:break_num+1  %һ��break_num1��
    for j=1:1:(point(i+1)-point(i))-1  %ÿ������(point(i+1)-point(i))�루�㣩
        a=data11X(point(i)+j+1,2)-data11X(point(i)+j,2);
        accele(point(i)+j)=a;
    end
    accele(point(i)+j+1)=a;
end
clear a i j;
data111X=[data11X,accele]; %��������У����ٶ�
xlswrite('./shuju1_X.xlsx',{'���ٶ�'},1,'C1');
xlswrite('./shuju1_X.xlsx',accele,1,'C2');
%% ������ٶ��쳣
[a_num,a_ind]=abnormal_accele(accele);
for i=1:1:a_num   %�쳣���ٶ���������ֵ
    accele(a_ind(i))=(accele(a_ind(i)-1)+accele(a_ind(i))+accele(a_ind(i)+1))/3;
end
clear a_num a_ind;
[a_num1,a_ind1]=abnormal_accele(accele); %�������ٶ���Ȼ���ϸ������������
data111X(:,3)=[];
data111X(:,3)=accele;
xlswrite('./shuju1_X.xlsx',accele,1,'C2');
%ɾ�����ٶ���Ȼ���ϸ������
for i=1:1:a_num1
    data111X(a_ind1(a_num1-i+1),:)=[];
end
clear a_num1 a_ind1 accele;
title={'ʱ��','GPS����','���ٶ�'};
xlswrite('./shuju1_X_cl_a.xlsx',title,1,'A1');
xlswrite('./shuju1_X_cl_a.xlsx',data111X,1,'A2'); %�Ѿ�ɾ���˼��ٶ��쳣������
%%  ɾ��ÿ�θտ�ʼ������󣬲��ǵ��ٵģ�v<10�ġ�
n=length(data111X);  %�Ѿ�ɾ���˼��ٶ��쳣������
[break_num2,break_ind2]=search_break('./shuju1_X_cl_a.xlsx');
GPS_V=data111X(:,2);
select=ones(n,1);
point2=[0;break_ind2;n];
for i=1:1:break_num2+1   %��break_num2+1����    %ǰ�˲��ǵ��ٵ�
    for j=1:1:(point2(i+1)-point2(i))
        if(GPS_V(point2(i)+j)>10)
            select(point2(i)+j)=0;
        else
            break;
        end
    end
end
for i=1:1:break_num2+1   %��break_num2+1����  %��˲��ǵ��ٵ�
    for j=1:1:(point2(i+1)-point2(i))
        if(GPS_V(point2(i+1)-j+1)>10)
            select(point2(i+1)-j+1)=0;
        else
            break;
        end
    end
end
clear i j;
data111X=[data111X,select]; %select=0�Ĵ���ÿ�θտ�ʼ������󣬲��ǵ��ٵġ�
for i=1:1:n    %��select=0������ɾ��
    if (select(n-i+1)==0)
        data111X((n-i+1),:)=[];
    end
end
%% �ѵ��ٳ���180s�Ĳ���ɾ��,��ǰ����ɾ
n=length(data111X);  %ɾ��ÿ�ο�ʼ���ǵ��ٵ�����
title(1,4)={'select'};
xlswrite('./shuju1_X_cl_a_v0.xlsx',title,1,'A1');
xlswrite('./shuju1_X_cl_a_v0.xlsx',data111X,1,'A2');
[break_num3,break_ind3]=search_break('./shuju1_X_cl_a_v0.xlsx'); %ɾ���쳣���ٶȺ�ÿ�ο�ʼ���ǵ��ٵ�����֮��
GPS_V=data111X(:,2);
point3=[0;break_ind3;n];
k=0;%����ʱ������
select=ones(n,1); %1��������0������
daisu=ones(n,1); % 0:���٣��ٶ�С���ӽ�0��
for i=1:1:break_num3+1   %��
    long=point3(i+1)-point3(i);  %ÿ�γ���
    for j=1:1:long
        if(GPS_V(point3(i)+j)<10)
            k=k+1;
            daisu(point3(i)+j)=0; %����״̬
            if(k>180)
                select(point3(i)+j-180)=0; %�ӵ��ٿ�ʼ��ɾ
            end
        else
            k=0;
        end
    end
end
clear i j k long;
data111X=[data111X(:,1:3),select,daisu]; %select=0�Ĵ�����180s�Ĳ��֣�daisu=0�����ٲ��֡�
for i=1:1:n    %��select=0������ɾ��
    if (select(n-i+1)==0)
        data111X((n-i+1),:)=[];
    end
end  
clear i;
n_180=length(data111X);  %ɾ�����ٳ���180s������
title(1,5)={'daisu'};
xlswrite('./shuju1_X_cl_a_v0_180.xlsx',title,1,'A1')
xlswrite('./shuju1_X_cl_a_v0_180.xlsx',data111X,1,'A2')
[break_num4,break_ind4]=search_break('./shuju1_X_cl_a_v0_180.xlsx');%ɾ�����ٳ���180s��
t2=clock;
fprintf('��������ʱ�䣺%f\n',etime(clock,t1));
