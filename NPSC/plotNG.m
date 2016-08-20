function plotNG(mu0,betta,a,b)
% N=1000;
% lambda=zeros(N,1);
% mu=zeros(N,1);
% for i=1:N
%     lambda(i)=random('Gamma',a,1/b);
%     mu(i)=normrnd(mu0,1/(betta*lambda(i)));
% end

mu=24:0.01:94;
lambda=0.001:5e-5:0.007;

% [Mu,Lambda]=meshgrid(mu,lambda);
% A=a*ones(size(Mu));
% B=b*ones(size(Mu));
% Mu0=mu0*ones(size(Mu));
% Betta=betta*ones(size(Mu));
% P=gampdf(Lambda,A,1./B);
% P=P.*normpdf(Mu,Mu0,(Betta.*Lambda).^(-1));
% surf(Mu,Lambda,P);
plot(lambda,gampdf(lambda,a*ones(size(lambda)),1/b*ones(size(lambda))));
figure;
plot(mu,normpdf(mu,mu0*ones(size(mu0)),sqrt(b/a*ones(size(mu0)))));
end