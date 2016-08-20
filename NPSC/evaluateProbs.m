function probs=evaluateProbs(logProbs)
mx=max(logProbs);
logProbs=logProbs-mx;
logProbs(logProbs<-300)=-Inf;
probs=exp(logProbs)/sum(exp(logProbs));
end