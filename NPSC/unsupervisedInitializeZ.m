function z=unsupervisedInitializeZ(sample,data,params)
K=sample.K;
n=size(data,1);
z=zeros(n,1);
for i=1:n
    logProbs=zeros(K+1,1);
    for k=1:K
        logProbs(k)=log(sum(sample.num(k,:)))+unsupervisedLogLikelihood(data(i,:),sample.phi(k),params);
    end
        logProbs(K+1)=log(params.alpha)+unsupervisedLogLikelihood(data(i,:),params.phi,params);
    [~,z(i)]=max(logProbs);
end
end