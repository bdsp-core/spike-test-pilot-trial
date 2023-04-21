function [minErr,the,sig,sen,fpr]=fcn_latentTraitModel(x,y,maxSigma)
    N=1E4;K=1E3;minErr=inf;
    z=linspace(1/N,1-1/N,N);z=log(z./(1-z));
    gt=z(z~=0);gt=(gt>0); 
    for i=1:K
        sigma=rand*maxSigma;             
        n=randn(size(z))*sigma;
        z_prime=z+n;
        mn=min(z_prime)-1/K;mx=max(z_prime)+1/K; 
        th=linspace(mn,mx,K);se=NaN(K, 1);fp=NaN(K, 1);    
        for ii=1:K
           pr=(z_prime>th(ii));
           se(ii)=sum(pr==1&gt==1)/sum(gt==1); 
           fp(ii)=sum(pr==1&gt==0)/sum(gt==0); 
        end
        [d,jj]=min(sqrt((x-fp).^2+(y-se).^2)); 
        if d<minErr    
            minErr=d;   
            the=th(jj);sig=sigma;fpr=fp;sen=se;        
        end   
    end
end
