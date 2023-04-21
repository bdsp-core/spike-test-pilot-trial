clc;close all;
clear;

fn='./Figure3.png';

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

%% get figure
figure('units','normalized','position',[0.1 0.1 0.4 0.8]);
subplot(3,1,1)
hold on;
    plot(8.0,5,'v','markersize',10,'markerfacecolor',[1 1 1],'markeredgecolor',[0 0 0],'linewidth',1);plot(8.0,4,'s','markersize',12,'markerfacecolor',[1 1 1],'markeredgecolor',[0 0 0],'linewidth',1);
    text(8.3,5,'Residents test #1','horizontalalignment','left');text(8.3,4,'Residents test #2','horizontalalignment','left');   
    text(-1.0,5.4,'CONTROL','horizontalalignment','left')
    plot(bias_pre3,log(noise_pre3),'v','markersize',10,'markerfacecolor',[0.7,0.7,0.7],'markeredgecolor',[0 0 0]);
    plot(bias_pos3,log(noise_pos3),'s','markersize',12,'markerfacecolor',[0.7,0.7,0.7],'markeredgecolor',[0 0 0]);
    xlim([-2 12]);ylim([-1.0 5.3]);grid on
    xlabel('threshold \theta');ylabel('noise \sigma (dB)');
hold off

subplot(3,1,2)
hold on;
    text(-1.0,5.4,'INTERVENTION #1','horizontalalignment','left')
    plot(bias_pre1,log(noise_pre1),'v','markersize',10,'markerfacecolor',[0.000 0.447 0.741],'markeredgecolor',[0 0 0]);
    plot(bias_pos1,log(noise_pos1),'s','markersize',12,'markerfacecolor',[0.000 0.447 0.741],'markeredgecolor',[0 0 0]);
    xlim([-2 12]);ylim([-1.0 5.3]);grid on
    xlabel('threshold \theta');ylabel('noise \sigma (dB)');
hold off

subplot(3,1,3)
hold on;
    text(-1.0,5.4,'INTERVENTION #2','horizontalalignment','left')
    plot(bias_pre2,log(noise_pre2),'v','markersize',10,'markerfacecolor',[0.466 0.674 0.188],'markeredgecolor',[0 0 0]);
    plot(bias_pos2,log(noise_pos2),'s','markersize',12,'markerfacecolor',[0.466 0.674 0.188],'markeredgecolor',[0 0 0]);
    xlim([-2 12]);ylim([-1.0 5.3]);grid on
    xlabel('threshold \theta');ylabel('noise \sigma (dB)');
hold off

%% export image
set(gcf,'color','w');
exportgraphics(gcf,fn,'Resolution',300);
close all;
