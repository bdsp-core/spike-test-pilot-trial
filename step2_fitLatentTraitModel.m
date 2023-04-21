clc;close all;
clear;

%% data path  
addpath('./Callbacks/')
resDir='./Outputs/';
if exist(resDir,'dir')~=7
    mkdir(resDir)
end

%% main loop
maxErr = 0.10;
for group_id=1:3
    % read data
    tmp=load([resDir,'Performance_G',num2str(group_id),'.mat']);
    T=tmp.T;
    sen_pre=T(:,1);sen_pos=T(:,8);fpr_pre=T(:,2);fpr_pos=T(:,9);

    % fit model
    [thr_pre,sig_pre,sen_pre,fpr_pre,auc_pre,J_pre]=fcn_fitROCm(fpr_pre,sen_pre,maxErr,1);
    [thr_pos,sig_pos,sen_pos,fpr_pos,auc_pos,J_pos]=fcn_fitROCm(fpr_pos,sen_pos,maxErr,1);

    % export result
    save([resDir,'fittedROC_G',num2str(group_id)],'sig_pre','sen_pre','fpr_pre','thr_pre','auc_pre','J_pre','sig_pos','sen_pos','fpr_pos','thr_pos','auc_pos','J_pos');
end
