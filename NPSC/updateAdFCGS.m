function Samples=updateAdFCGS(Samples, data, labels, params, t)
N = params.N;
lambda=params.lambda;
for i=1:N
    Samples(i).num=Samples(i).num*exp(-lambda);
    Samples(i)=supervisedGibbs(Samples(i), data, labels, params,t);
%     Samples(i)=cleanUpSample(Samples(i));
%     fprintf('Supervised Gibbs Cycle for sample %d Completed\n',i);
end
end