function sample=supervisedAddDataToModel(sample, data, labels, z, params, place)
oldK=sample.K;
M1=params.M1;
M2=params.M2;
sample.K=max(sample.K,max(z));
for k=1:sample.K
    dataK=data(z==k,:);
    labelsK=labels(z==k);
    sampleN=size(dataK,1);
    if(sampleN==0)
        continue;
    end
    if(k<=oldK)
        phi=sample.phi(k);
    else
        phi=params.phi;
    end
    % Updating Parameters of the Prior Distribution of Discrete Features
    if(M1>0)
        for j=1:sampleN
            indices=convertToIndex(rows(phi.gamma{1}),dataK(j,1:M1));
            phi.gamma{labelsK(j)}(indices)=phi.gamma{labelsK(j)}(indices)+1;
        end
    end
    if(M2>0)
        % Updating Prior Distribution of Continuouse Features
        for c=1:params.C
            Nc=sum(labelsK==c);
            if Nc==0
                continue;
            end
            if(Nc==1)
                meanData=dataK(labelsK==c,M1+1:end);
                varData=0;
            else
                meanData=mean(dataK(labelsK==c,M1+1:end));
                varData=(var(dataK(labelsK==c,M1+1:end))*(Nc-1));%sum((dataK(labelsK==c,M1+1:end)-repmat(meanData,Nc,1)).^2);
            end
            phi.b(c,:)=phi.b(c,:)+0.5*varData+(Nc*phi.betta(c,:).*(meanData-phi.mu0(c,:)).^2)./(2*(phi.betta(c,:)+Nc));
            phi.mu0(c,:)=(phi.betta(c,:).*phi.mu0(c,:)+Nc*meanData)./(phi.betta(c,:)+Nc);
            phi.a(c,:)=phi.a(c,:)+Nc/2;
            phi.betta(c,:)=phi.betta(c,:)+Nc;
        end
    end
    for c=1:params.C
          Nc=sum(labelsK==c);
          phi.py(c)=phi.py(c)+Nc;
    end
    if(k<=oldK)
        % Updating Number of members of the k'th Mixture
        sample.num(k,place)=sample.num(k,place)+sampleN;
        sample.phi(k)=phi;
    else
        if(oldK==0 && k==1)
            sample.num=zeros(1,params.delta);
            sample.num(place)=sampleN;
            sample.phi=phi;
        else
            newNum=zeros(1,params.delta);
            newNum(place)=sampleN;
            sample.num=[sample.num;newNum];
            sample.phi=[sample.phi;phi];
        end
    end
end
end