function [sample,z]=supervisedRemoveDataFromModel(sample, z, oldZ, data, label, params, place)
M1=params.M1;
M2=params.M2;
sample.num(oldZ,place)=sample.num(oldZ,place)-1;
if(sum(sample.num(oldZ,:))==0)
    [sample,z]=removeClassifier(sample,oldZ,z);
    return;
end

if(M1>0)
    indices=convertToIndex(rows(params.phi.gamma{1}),data(1:M1));
    sample.phi(oldZ).gamma{label}(indices)=sample.phi(oldZ).gamma{label}(indices)-1;
end
if M2>0
    phi=sample.phi(oldZ);
    a=phi.a(label,:);
    b=phi.b(label,:);
    betta=phi.betta(label,:);
    mun=phi.mu0(label,:);
    x=data(M1+1:end);
    
    a=a-0.5;
    betta=betta-1;
    mu0=((1+betta).*mun-x)./betta;
    b=b-(betta.*(x-mu0).^2)./(2*(1+betta));
    
    sample.phi(oldZ).betta(label,:)=betta;
    sample.phi(oldZ).a(label,:)=a;
    sample.phi(oldZ).mu0(label,:)=mu0;
    sample.phi(oldZ).b(label,:)=b;
end

sample.phi(oldZ).py(label)=sample.phi(oldZ).py(label)-1;
end