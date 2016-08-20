function [sample,z]=removeClassifier(sample,Z,z)
for k=Z+1:sample.K
    sample.phi(k-1)=sample.phi(k);
    sample.num(k-1,:)=sample.num(k,:);
end
sample.phi(end)=[];
sample.num(end,:)=[];
sample.K=sample.K-1;
if nargin>2
    z(z>Z)=z(z>Z)-1;
end
end