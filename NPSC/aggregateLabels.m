function label=aggregateLabels(z,Samples,data,params)
N=params.N;
totalProbs=zeros(params.C,1);
for n=1:N
    if(z(n)<=Samples(n).K)
        phi=Samples(n).phi(z(n));
    else
        phi=params.phi;
    end
    logprobs=zeros(params.C,1);
    for c=1:params.C
        logprobs(c)=supervisedLogLikelihood(data, c, phi, params);
    end
    logprobs=logprobs-max(logprobs);
    probs=exp(logprobs)/sum(exp(logprobs));
    totalProbs=totalProbs+probs;
end
[~,label]=max(totalProbs/N);
%label=max(totalProbs/N);
end