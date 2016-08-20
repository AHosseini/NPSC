function z=supervisedInitializeZ(sample, data, labels, params, isFirstBatch)
K=sample.K;
n=size(data,1);
z=zeros(n,1);
if isFirstBatch
    z(1)=1;
    for i=2:n
        z(i) = randi(max(z(1:i-1))+1,1,1);
    end
    return;
end
for i=1:n
    logProbs=zeros(K+1,1);
    for k=1:K
        logProbs(k)=log(sum(sample.num(k,:)))+supervisedLogLikelihood(data(i,:), labels(i), sample.phi(k), params);
    end
    logProbs(K+1)=log(params.alpha)+supervisedLogLikelihood(data(i,:), labels(i), params.phi, params);
    [~,z(i)]=max(logProbs);
end
end