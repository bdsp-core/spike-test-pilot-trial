clc;close all;
clear;

fn='./Figure2.png';

%% read data
tmp=load('./Outputs/Performance_G1.mat');
T=tmp.T;
sen_pre1=T(:,1);fpr_pre1=T(:,2);acc_pre1=T(:,3);cal_pre1=T(:,4);auc_pre1=T(:,5);bias_pre1=T(:,6);noise_pre1=T(:,7);sen_pos1=T(:,8);fpr_pos1=T(:,9);acc_pos1=T(:,10);cal_pos1=T(:,11);auc_pos1=T(:,12);bias_pos1=T(:,13);noise_pos1=T(:,14);

tmp=load('./Outputs/Performance_G2.mat');
T=tmp.T;
sen_pre2=T(:,1);fpr_pre2=T(:,2);acc_pre2=T(:,3);cal_pre2=T(:,4);auc_pre2=T(:,5);bias_pre2=T(:,6);noise_pre2=T(:,7);sen_pos2=T(:,8);fpr_pos2=T(:,9);acc_pos2=T(:,10);cal_pos2=T(:,11);auc_pos2=T(:,12);bias_pos2=T(:,13);noise_pos2=T(:,14);

tmp=load('./Outputs/Performance_G3.mat');
T=tmp.T;
sen_pre3=T(:,1);fpr_pre3=T(:,2);acc_pre3=T(:,3);cal_pre3=T(:,4);auc_pre3=T(:,5);bias_pre3=T(:,6);noise_pre3=T(:,7);sen_pos3=T(:,8);fpr_pos3=T(:,9);acc_pos3=T(:,10);cal_pos3=T(:,11);auc_pos3=T(:,12);bias_pos3=T(:,13);noise_pos3=T(:,14);

%% combine and compute
gg=[repmat({'Control'},1,length(sen_pre3)),repmat({'Intervension #1'},1,length(sen_pre1)),repmat({'Intervension #2'},1,length(sen_pre2))];
sen_pre=[sen_pre3;sen_pre1;sen_pre2];sen_pos=[sen_pos3;sen_pos1;sen_pos2];
fpr_pre=[fpr_pre3;fpr_pre1;fpr_pre2];fpr_pos=[fpr_pos3;fpr_pos1;fpr_pos2];
acc_pre=[acc_pre3;acc_pre1;acc_pre2];acc_pos=[acc_pos3;acc_pos1;acc_pos2];
cal_pre=[cal_pre3;cal_pre1;cal_pre2];cal_pos=[cal_pos3;cal_pos1;cal_pos2];
auc_pre=[auc_pre3;auc_pre1;auc_pre2];auc_pos=[auc_pos3;auc_pos1;auc_pos2];
bias_pre=[bias_pre3;bias_pre1;bias_pre2];bias_pos=[bias_pos3;bias_pos1;bias_pos2];
noise_pre=[noise_pre3;noise_pre1;noise_pre2];noise_pos=[noise_pos3;noise_pos1;noise_pos2];

d_acc=acc_pos-acc_pre; 
d_tpr=sen_pos-sen_pre; 
d_fpr=fpr_pos-fpr_pre;
d_cali=abs(cal_pos)-abs(cal_pre);
d_auc=auc_pos-auc_pre;
d_noise=log(noise_pos)-log(noise_pre);
d_bias=abs(bias_pos)-abs(bias_pre);

Y=[d_acc,d_auc,d_tpr,d_fpr,d_cali,d_bias,d_noise]; 
strs1={'A. ','B. ','C. ','D. ','E. ','F.','G.'};strs2={'Accuracy','AUC','TPR','FPR','|Calibration index|','|Bias|','Noise'};

%% get figure
f=figure('units','normalized','position',[0.1198 0.0741 0.6719 0.7667]);set(f,'MenuBar','none');set(f,'ToolBar','none');
ax={subplot('position',[.010 .710 .300 .250]);subplot('position',[.365 .710 .270 .250]);subplot('position',[.690 .710 .270 .250]);subplot('position',[.010 .380 .300 .250]);subplot('position',[.365 .380 .270 .250]);subplot('position',[.690 .380 .270 .250]);subplot('position',[.010 .050 .300 .250]);};
for i=1:size(Y,2)
  h=boxplot(ax{i},Y(:,i),gg,'Notch','off','Widths',0.5);set(h,{'linew'},{1.5});
  xlimts=get(ax{i},'xlim');ylimts=get(ax{i},'ylim');  
  text(ax{i},xlimts(1),ylimts(2),[strs1{i},'\Delta',strs2{i}],'verticalalignment','bottom','horizontalalignment','left','fontsize',18) 
  set(ax{i},'fontsize',8,'box','off')
end

%% export image
set(gcf,'color','w');
exportgraphics(gcf,fn,'Resolution',300)
close all

