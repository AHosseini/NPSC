function [estimatedLabels]=AdFCGS(data, labels, params)
Samples=initiateFCGS(params);
estimatedLabels=zeros(params.n,1);
maxT=ceil(params.n/params.BatchSize);
accuracy=zeros(maxT,1);
for t=1:maxT
    batchIndex=(t-1)*params.BatchSize+1:min(t*params.BatchSize,params.n);
    batchData=data(batchIndex,:);
    batchLabels=labels(batchIndex);
    
    if(t>1)
        observedIndex=1:min((t-1)*params.BatchSize,params.n);

        observedData=data(observedIndex,:);
        observedLabels=labels(observedIndex);
        observedSize=length(observedIndex);
            
        py1=(sum(observedLabels==1)+1)/(observedSize+2);
        params.phi.py=10*[py1,1-py1];                           %Warning: Change it if the number of classes is more than 2

        %params.phi.py=0.002*1/params.C*ones(params.C,1);
        if(params.M1>0)
            ConcentrationParameter=100;
            %params.discreteLength=dataset.discreteLength;
            % Setting the Dirichlet parameters
            for c=1:params.C
                if(sum(observedLabels==c)==0)
                    continue;
                end
                params.phi.gamma{c}=zeros(params.M1,max(params.discreteLength)); % In order to speed up the code, we assumed that all discreteLengths are equal
                for i=1:params.M1
                    for j=1:params.discreteLength(i)
                        params.phi.gamma{c}(i,j)=ConcentrationParameter*(sum(observedData(observedLabels==c,i)==j)+1)/(sum(observedLabels==c)+2);
                    end
                end
            end
        end
        if(params.M2>0)
            % The Gaussian-Gamma parameters
            for c=1:params.C
                if(sum(observedLabels==c)==0)
                    continue;
                end
                params.phi.mu0(c,:)=mean(observedData(observedLabels==c,params.M1+1:end));
                params.phi.b(c,:)=var(observedData(observedLabels==c,params.M1+1:end));
            end
        end
    end
    
    estimatedLabels(batchIndex)=classifyAdFCGS(Samples, batchData, params);
    accuracy(t)=sum(estimatedLabels(batchIndex)==batchLabels)/params.BatchSize*100;
    %afterLearningLabels=classifyFCGS(Samples, batchData, params);
    fprintf('Ys: ');
    for j=1:length(batchIndex)
        fprintf('%d' ,estimatedLabels(batchIndex(j)));
    end
    fprintf('\n');
    fprintf('Ts: ');
    for j=1:length(batchIndex)
        fprintf('%d ',batchLabels(j));
    end
    fprintf('\n');
    fprintf('Accuracy in batch %d is %2.2f%% and the number of 1 labels is %d\n',t,accuracy(t),sum(batchLabels==1));
    meanAccuracy=mean(accuracy(1:t));
    fprintf('Mean Accuracy until batch %d is %2.2f%%\n',t,meanAccuracy);
    Samples=updateAdFCGS(Samples, batchData, batchLabels, params, t);
    for k=1:params.N
        fprintf('Number of concepts is %d\n',Samples(k).K);
        for i=1:Samples(k).K
            fprintf('num(%d)=%2.2f  ',i,sum(Samples(k).num(i,:)));
        end
        fprintf('\n');
    end
    %trainAcc=sum(afterLearningLabels==batchLabels)/params.BatchSize*100;
    %fprintf('Train Accuracy in batch %d is %2.2f%% and the number of 1 labels is %d\n',t,trainAcc,sum(batchLabels==1));
    %pause;
end
end
