function [xx,yy,cali_idx]=fcn_caliParametric(gt,y_human)
    K=9;yy=NaN(1,K);
    for j=1:K 
       ii=find(gt==(j-1));yy(j)=100*sum(y_human(ii)==1)/length(ii);
    end
    th=linspace(-20,20,1E3);
    xx=100*(0:8)/8;
    best=inf;best_th=0;
    for j=1:length(th)
        pr=min(xx/100,(1-0.01));
        z=log((pr)./(1-pr))+th(j);
        yh=100./(1+exp(-z));
        cc=sum((yy-yh).^2);
        if cc<best
            best=cc;best_th=th(j);
        end
    end    
    xx=linspace(eps,1-eps,1E3);
    zz=log(xx./(1-xx))+best_th;
    yy=1./(1+exp(-zz));
    dd=yy-xx;
    aa=trapz(xx,dd);
    cali_idx=100*aa/0.5;
end
