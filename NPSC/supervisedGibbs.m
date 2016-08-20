function sample=supervisedGibbs(sample, data, labels, params, t)
n=size(data,1);
place=mod(t,params.delta)+1;
sample.num(:,place)=0;
for k=sample.K:-1:1
    if sum(sample.num(k,:))==0
        sample=removeClassifier(sample,k);
    end
end
z=supervisedInitializeZ(sample, data, labels, params, t==1);
sample=supervisedAddDataToModel(sample, data, labels, z, params,place);
for iter=1:params.Iter
    for i=1:n
        oldZ=z(i);
        %Removing the data from the old Table
        [sample,z]=supervisedRemoveDataFromModel(sample, z, oldZ, data(i,:), labels(i), params, place);
        logProbs=zeros(sample.K+1,1);
        for k=1:sample.K
            logProbs(k)=log(sum(sample.num(k,:)))+supervisedLogLikelihood(data(i,:), labels(i), sample.phi(k), params);
        end
        logProbs(sample.K+1)=log(params.alpha)+supervisedLogLikelihood(data(i,:), labels(i), params.phi, params);
        probs=evaluateProbs(logProbs);
        z(i)=find(mnrnd(1,probs)==1);
        sample=supervisedAddDataToModel(sample, data(i,:), labels(i), z(i), params, place);
    end
    %     for i=1:n
    %         fprintf('%d ',z(i));
    %     end
    %     fprintf('\n');
    % fprintf('  Supervised Gibbs Iteration %d Completed\n',iter);
end
%fprintf('%d\n',z~=z(1));
% for i=1:n
%     for j=i+1:n
%         if(z(i)==z(j) && labels(i)~=labels(j))
%             fprintf('%d %d\n',i,j);
%             pause;
%         end
%     end
% end


% fprintf('Sz: ');
% for i=1:n
%     fprintf('%d ',z(i));
% end
% fprintf('\n');
% % 
% Uz=unsupervisedInitializeZ(sample,data,params);
% fprintf('Uz: ');
% for i=1:n
%     fprintf('%d ',Uz(i));
% end
% fprintf('\n');


% for i=1:n
%     if(z(i)<=sample.K)
%         phi=sample.phi(z(i));
%     else
%         phi=params.phi;
%     end
%     fprintf('%f ',supervisedLogLikelihood(data(i,:), labels(i), phi, params));
% end
% fprintf('\n      ');
%
% for i=1:n
%     fprintf('%f ',supervisedLogLikelihood(data(i,:), labels(i), params.phi , params));
% end
% fprintf('\n');
%
% for k=1:sample.K
%     for c=1:2
%         fprintf('%d %d:',k,c);
%         for i=1:n
%             fprintf('%2.1f ',supervisedLogLikelihood(data(i,:), labels(i), sample.phi(k), params));
%         end
%         fprintf('\n');
%     end
% end
% fprintf('%d     ',sample.K+1);
% for i=1:n
%     fprintf('%f ',unsupervisedLogLikelihood(data(i,:), params.phi, params));
% end
% fprintf('\n');
end
