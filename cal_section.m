%������Ǵ���õ�����,���ٲ�����180s��ÿһ�δӵ��ٿ�ʼ
%cont_section=�˶�ѧƬ����
%section=�ڼ���Ƭ��
%N:�������õ�������
clc;clear;
t1=clock;
[data,txt]=xlsread('./shuju1_X_cl_a_v0_180.xlsx');
n=length(data);
[break_num,break_ind]=search_break('./shuju1_X_cl_a_v0_180.xlsx'); %break_num���ϵ㣬������break_ind
GPS_V=data(:,2);
daisu=data(:,5); %���ٵ�Ϊ0
section=zeros(n,1);
point=[0;break_ind;n];
k=0;   %ÿһ����Ƭ����
used_k=0;
count_section=0;   %���˶�ѧƬ����
Opoint=zeros(n,1);
for i=1:1:break_num+1   %����
    for j=1:1:(point(i+1)-point(i))-1   %ÿ��������
        if((daisu(point(i)+j)==1)&&(daisu(point(i)+j+1)==0))
            k=k+1;
            Opoint(k)=point(i)+j;   %Ƭ�ο�ʼ������
            if(k==1)
                long=j;
            else
                long=point(i)+j-Opoint(k-1);
            end
            if(long>19)    %���ȴﵽ20������Ϊ�˶�ѧƬ��
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
%% �Ѳ���Ƭ���ڵ�����ɾ��
for i=1:1:n
    if(section(n-i+1)==0)
        data(n-i+1,:)=[];
    end
end
section=data(:,6);    
%%
title={'ʱ��','GPS����','���ٶ�','select','daisu','section'};
xlswrite('./shuju1_finished.xlsx',title,1,'A1');
xlswrite('./shuju1_finished.xlsx',data,1,'A2');
N=length(data);   %�������õ�������
fprintf('��������ʱ�䣺%f\n',etime(clock,t1));
