% PCA
%feature_title={'1Ƭ��','2ƽ���ٶ�','3ƽ����ʻ�ٶ�','4����ʱ���','5ƽ�����ٶ�','6ƽ�����ٶ�',
% '7����ʱ���','8����ʱ���','9�ٶȱ�׼��','10���ٶȱ�׼��'};
clc;clear;
[feature,title]=xlsread('./feature.xlsx');
%feature=feature(:,2:end); 
%[coeff,score,latent,tsquare]=pca(feature);
feature=feature(:,2:4); 