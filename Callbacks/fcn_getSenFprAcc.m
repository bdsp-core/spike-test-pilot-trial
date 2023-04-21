function [sen,fpr,acc] = fcn_getSenFprAcc(gt,y_human,thr)
    sen=sum(gt>thr&y_human==1)/sum(gt>thr);
    fpr=sum(gt<thr&y_human==1)/sum(gt<thr);
    acc=(sum(gt>thr&y_human==1)+sum(gt<thr&y_human==0))/sum(gt~=thr);
end