function [thr,sig,sen,fpr,auc,err]=fcn_fitROCm(FPR,SEN,maxErr,verbose)
    maxSigma=5;
    err=inf;c=1;
    while round(100*err)/100>maxErr
        [err,sig,thr,sen,fpr,auc]=fcn_latentTraitModelm(FPR,SEN,maxSigma); 
        disp([repmat(' ',1,c-1),'noise ceiling at ',num2str(maxSigma),' - err:',num2str(err)])
        if round(100*err)/100<=maxErr
            break
        else 
            maxSigma=maxSigma+5;
        end 
    end
    if verbose
        figure
        hold on; 
            plot(fpr,sen,'k',FPR,SEN,'o','linewidth',1,'markersize',10,'MarkerFaceColor','r');
            axis([0 1 0 1]);axis square;grid on;box off;
            xlabel('FPR');ylabel('TPR');
            drawnow
        hold off; 
        set(gcf,'color','w')
    end
end
