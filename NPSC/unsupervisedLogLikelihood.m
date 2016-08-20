function logLikelihood=unsupervisedLogLikelihood(data,phi,params)
likelihoods=zeros(params.C,1);
for i=1:params.C
    likelihoods(i)=supervisedLogLikelihood(data,i,phi,params);
end
mx=max(likelihoods);
likelihoods=likelihoods-mx;
logLikelihood=mx+log(sum(exp(likelihoods)));
end