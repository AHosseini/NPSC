function estimatedLabels=classifyAdFCGS(Samples, data, params)
n = size(data,1);
N = params.N;
z=zeros(N,n);
Nu=0;
for i=1:N
    z(i,:)=unsupervisedInitializeZ(Samples(i),data,params);
    fprintf('UZ: ');
    for j=1:n
        fprintf('%d ',z(i,j));
    end
    fprintf('\n');
    if sum(z(i,:)~=z(i,1))>0
       Nu=Nu+1;
    end
    % fprintf('Unsupervised Gibbs Cycle for sample %d Completed\n',i);
end
% fprintf('Non-Uniform percentage:%2.2f\n',Nu/N);
% Estimating Labels
estimatedLabels=zeros(n,1);
for i=1:n
%     fprintf('%d\n',i);
    estimatedLabels(i)=aggregateLabels(z(:,i),Samples,data(i,:),params);
end
end