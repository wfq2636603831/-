clc;clear;
%ת��ʱ���ʽ��ȡ����
data11=transform_time('./�ļ�1.xlsx','./shuju1.xlsx');
%��ʱ�䲻�������Ҽ��С�ڵ���4s����ֵ
[suminsertnum1,data11X]=insertV('./shuju1.xlsx','./shuju1xx.xlsx',4); 
%ͳ�Ʋ�ֵ��ļ�ϵ���������
[break_num1,break_ind1]=search_break('./shuju1xx.xlsx');
%% ����ÿ�εļ��ٶȣ�ÿһ��ļ��ٶȵ�����һ���ٶȼ�ȥ�˿̵��ٶȣ����һ����ٶȵ���ǰһ����ٶ�
n=length(data11X);
point=[0;break_ind1;n];
accele=zeros(n,1);
for i=1:1:break_num1+1  %һ��break_num1��
    for j=1:1:(point(i+1)-point(i))-1  %ÿ������(point(i+1)-point(i))�루�㣩
        a=data11X(point(i)+j+1,2)-data11X(point(i)+j,2);
        accele(point(i)+j)=a;
    end
    accele(point(i)+j+1)=a;
end
clear a i j;
data111X=[data11X,accele]; %��������У����ٶ�
xlswrite('./shuju1xx.xlsx',{'���ٶ�'},1,'C1');
xlswrite('./shuju1xx.xlsx',accele,1,'C2');
%%
