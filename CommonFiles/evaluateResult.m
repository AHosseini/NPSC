function measures=evaluateResult(Labels,PredictedLabels, batchSize,MethodName)
n=size(Labels,1);
T=ceil(n/batchSize);
measures.precision=zeros(T-1,1);
measures.recall=zeros(T-1,1);
measures.accuracy=zeros(T-1,1);
measures.F1=zeros(T-1,1);
totalNumber=0;
trueNumber=0;
alpha=0.95;
for t=1:T-1
index=(t)*batchSize+1:min((t+1)*batchSize,n);
totalNumber=totalNumber*alpha+length(index);
trueNumber=trueNumber*alpha+sum(Labels(index)==PredictedLabels(index));
%measures.accuracy(t)=mean(Labels(index)==PredictedLabels(index))*100;
measures.accuracy(t)=trueNumber/totalNumber*100;
measures.precision(t)= sum(PredictedLabels(index)==2 & Labels(index)==PredictedLabels(index))/sum(PredictedLabels(index)==2)*100;
measures.recall(t)= sum(Labels(index)==2 & Labels(index)==PredictedLabels(index))/sum(Labels(index)==2)*100;
measures.F1(t)=2*measures.precision(t)*measures.recall(t)/(measures.precision(t)+measures.recall(t));
end
measures.totalAccuracy=mean(Labels==PredictedLabels)*100;
measures.totalPrecision= sum(PredictedLabels==2 & Labels==PredictedLabels)/sum(PredictedLabels==2)*100;
measures.totalRecall= sum(Labels==2 & Labels==PredictedLabels)/sum(Labels==2)*100;
measures.totalF1=2*measures.totalPrecision*measures.totalRecall/(measures.totalPrecision+measures.totalRecall);
q=sum(Labels==Labels(1))/length(Labels);
pStar=q^2+(1-q)^2;
measures.totalKappa=evaluate_kappa(PredictedLabels, Labels);
labeled_curves(1:T-1,measures.accuracy(:)','labels',MethodName)
end
