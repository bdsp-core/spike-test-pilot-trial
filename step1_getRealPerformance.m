clc;close all;
clear;

%% data path  
addpath('./Callbacks/')
dataDir='./Data-DeIDed/';
resDir='./Outputs/';
if exist(resDir,'dir')~=7
    mkdir(resDir)
end

%% parameters
thr=4;
maxErr=0.01;
hdr={'pre-sen','pre-fpr','pre-acc','pre-cali','pre-auc','pre-bias','pre-noise','post-sen','post-fpr','post-acc','post-cali','post-auc','post-bias','post-noise'};
subject_ID={[4,5,6,8,15,18];        % N=6 for G1 (jj)
            [2,11,12,13,16,19,21];  % N=7 for G2 (centaur)
            [1,3,7,9,10,14,17,20]}; % N=8 for G3 (control)
        
%% main loop
for group_id=1:3
    subject_id=subject_ID{group_id};
    
    % get list of files (pre- and post-study tests)    
    files1=struct2cell(dir([dataDir,'/pre-study-test/G',num2str(group_id),'/*.mat']))';
    files2=struct2cell(dir([dataDir,'/post-study-test/G',num2str(group_id ),'/*.mat']))';
    files=[files1(:,[1 2]);files2(:,[1 2])];
    K=size(files,1);

    % compute performance metrics
    sen=NaN(K,1);fpr=NaN(K,1);acc=NaN(K,1);cal=NaN(K,1);noise=NaN(K,1);bias=NaN(K,1);auc=NaN(K,1);cal_yy=NaN(K,1000);
    for k=1:K      
        % read labels
        tmp=load([files{k,2},'/',files{k,1}]);
        gt=tmp.y;gt(gt<0)=0;
        y_human=tmp.y_human;

        % compute real metrics (discard 4-vote events)
        [sen(k),fpr(k),acc(k)]=fcn_getSenFprAcc(gt,y_human,thr);
        
        % compute calibration index
        [cal_xx,cal_yy(k,:),cal(k)]=fcn_caliParametric(gt,y_human);

        % fit a simple latent-trait model
        [bias(k),noise(k),~,~,auc(k)]=fcn_fitROC(fpr(k),sen(k),maxErr,1);
    end

    % export results
    PerformanceT=[sen,fpr,acc,cal,auc,bias,noise];
    T=[PerformanceT(1:K/2,:),PerformanceT(K/2+1:end,:)];
    cal_yy_pre=cal_yy(1:K/2,:);cal_yy_pos=cal_yy(K/2+1:end,:); 
	save([resDir,'Performance_G',num2str(group_id),'.mat'],'T','hdr','cal_yy_pre','cal_yy_pos','cal_xx','subject_id')
end
