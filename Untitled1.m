clc;clear;
%ת��ʱ���ʽ��ȡ����
num1=transform_time('./�ļ�1.xlsx','./shuju1.xlsx');
num2=transform_time('./�ļ�2.xlsx','./shuju2.xlsx');
num3=transform_time('./�ļ�3.xlsx','./shuju3.xlsx');
%��ʱ�䲻�������Ҽ��С�ڵ���4s����ֵ
[suminsertnum1,num11]=insertV('./shuju1.xlsx','./shuju1xx.xlsx',4); 
[suminsertnum2,num22]=insertV('./shuju2.xlsx','./shuju2xx.xlsx',4); 
[suminsertnum3,num33]=insertV('./shuju3.xlsx','./shuju3xx.xlsx',4); 
%ͳ�Ʋ�ֵ��ļ�ϵ���������
[break_num1,break_ind1]=search_break('./shuju1xx.xlsx');
[break_num2,break_ind2]=search_break('./shuju2xx.xlsx');
[break_num3,break_ind3]=search_break('./shuju3xx.xlsx');