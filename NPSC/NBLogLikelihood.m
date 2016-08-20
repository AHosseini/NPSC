function logLikelihood=NBLogLikelihood(NB, data, label)
logLikelihood=log(NB.Prior(label));
for i=1:size(data,2)
    params=NB.Params(label,i);
    logLikelihood=logLikelihood+log(pdf('Normal',data(i),params{1}(1),params{1}(2)));
end
end