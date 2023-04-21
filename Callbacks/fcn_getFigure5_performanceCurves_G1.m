clc;close all;
clear;

fn='./Figure5.png';
group_id=1;
subject_ID=[4,5,6,8,15,18]; % N=6 for G1 (jj)

%% read data
tmp=load(['./Outputs/fittedROC_G',num2str(group_id),'.mat']);
sen_pre=tmp.sen_pre;fpr_pre=tmp.fpr_pre;auc_pre=tmp.auc_pre;sen_pos=tmp.sen_pos;fpr_pos=tmp.fpr_pos;auc_pos=tmp.auc_pos;

tmp=load(['./Outputs/Performance_G',num2str(group_id),'.mat']);
T=tmp.T;
OP_sen_pre=T(:,1);OP_fpr_pre=T(:,2);OP_sen_pos=T(:,8);OP_fpr_pos=T(:,9);cal_x=tmp.cal_xx;cal_y_pre=tmp.cal_yy_pre;cal_y_pos=tmp.cal_yy_pos;
 
tmp=load('./Callbacks/fittedROC_experts.mat');
sen_exp=tmp.sen;fpr_exp=tmp.fpr;auc_exp=tmp.auc;

tmp=load('./Callbacks/Performance_experts.mat');
T=tmp.T;
OP_sen_exp=T(:,1);OP_fpr_exp=T(:,2);cal_y_exp=tmp.cal_yy;
    
%% get figure
f=figure('units','centimeter' ,'outerposition',[2 2 40 20]);
subplot(1,2,1)
hold on
  title('INTERVENTION #1 - ROC');
  plot(fpr_pre,sen_pre,'color',[0.850 0.325 0.098],'linewidth',2); 
  plot(fpr_pos,sen_pos,'color',[0.000 0.447 0.741],'linewidth',2); 
  plot(fpr_exp,sen_exp,'k','linewidth',2); 
  plot(fpr_exp,sen_exp,'k','linewidth',2); 
  for i=1:length(OP_sen_exp)
    plot(OP_fpr_exp(i),OP_sen_exp(i),'o','markersize',20,'markerfacecolor',[.7,.7,.7],'markeredgecolor','k'); 
  end 
  for i=1:length(OP_sen_pre)
    plot(OP_fpr_pre(i),OP_sen_pre(i),'^','markersize',20,'markerfacecolor',[0.850 0.325 0.098],'markeredgecolor','none');
    plot(OP_fpr_pos(i),OP_sen_pos(i),'s','markersize',25,'markerfacecolor',[0.000 0.447 0.741],'markeredgecolor','none'); 
  end
  for i=1:length(OP_sen_pre)
    text(OP_fpr_pre(i)+.03,OP_sen_pre(i)-.03,['R',num2str(subject_ID(i))],'fontsize',12)
    text(OP_fpr_pos(i)+.03,OP_sen_pos(i)-.03,['R',num2str(subject_ID(i))],'fontsize',12)
  end   
  plot([0.36 0.44] ,[0.30 0.30] ,'k-','linewidth',2);
  plot(0.40,0.30,'o','markersize',20,'markerfacecolor',[0.7 0.7 0.7],'markeredgecolor','k');
  text(0.45,0.30,['Experts (AUC: ',num2str(round(auc_exp*1000)/1000),')'],'horizontalalignment','left','fontsize',12)    
  plot([0.36 0.44] ,[0.22 0.22] ,'color',[0.850 0.325 0.098],'linewidth',2);
  plot(0.40,0.22,'^','markersize',20,'markerfacecolor',[0.850 0.325 0.098],'markeredgecolor','none');
  ss=num2str(round(auc_pre*1000)/1000);
  ss=[ss,repmat('0',1,5-length(ss))];
  text(0.45,0.22,['Residents Test #1 (AUC: ',ss,')'],'horizontalalignment','left','fontsize',12)    
  plot([0.36 0.44] ,[0.16 0.16] ,'color',[0.000 0.447 0.741],'linewidth',2);
  plot(0.40,0.16,'s','markersize',25,'markerfacecolor',[0.000 0.447 0.741],'markeredgecolor','none');
  ss=num2str(round(auc_pos*1000)/1000);
  ss=[ss,repmat('0',1,5-length(ss))];
  text(0.45,0.16,['Residents Test #2 (AUC: ',ss,')'],'horizontalalignment','left','fontsize',12);
  axis square;grid on;box off;
  xlabel('False Positive Rate');ylabel('Sensitivity');
  set(gca,'tickdir','out','fontsize',20); 
hold off;

subplot(1,2,2)
hold on
    title('Calibration Curve')
    plot((0:8)/8,(0:8)/8,'k--')
    for i=1:size(cal_y_exp,1)
    plot(cal_x,cal_y_exp(i,:),'-','markersize',20,'linewidth',2,'color', [0.700 0.700 0.700])
    end
    for i=1:size(cal_y_pre,1)
        plot(cal_x,cal_y_pre(i,:),'-','markersize',20,'linewidth',3,'color', [0.850 0.325 0.098])
    end
    for i=1:size(cal_y_pos,1)
        plot(cal_x,cal_y_pos(i,:),'-','markersize',20,'linewidth',3,'color', [0.000 0.447 0.741])
    end
    axis square;grid on;box off;
    xlabel('Ground Truth');ylabel('Individuals');
    set(gca,'tickdir','out','fontsize',20); 
hold off

%% export image
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 2 2],'color','w'); 
exportgraphics(f,fn,'Resolution',300);
close all;
