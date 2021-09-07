% PCA
%feature_title={'1片段','2平均速度','3平均行驶速度','4怠速时间比','5平均加速度','6平均减速度',
% '7加速时间比','8减速时间比','9速度标准差','10加速度标准差'};
clc;clear;
[feature,title]=xlsread('./feature.xlsx');
%feature=feature(:,2:end); 
%[coeff,score,latent,tsquare]=pca(feature);
feature=feature(:,2:4); 