function logLikelihood=supervisedLogLikelihood(data, label, phi, params)
M1=params.M1;
M2=params.M2;
logLikelihood=0;

if(M1>0)
    gamma=phi.gamma{label};
    %gamma=log(gamma./repmat(row_sum(gamma),1,cols(gamma)));
    %indices=(1:rows(gamma))+(data(1:M1)-1)*rows(gamma);
    indices=convertToIndex(rows(gamma),data(1:M1));
    logLikelihood=sum(log(gamma(indices)./row_sum(gamma)'));
end

if M2>0
    for i=1:M2
        x=data(i+M1);
        b=phi.b(label,i);
        a=phi.a(label,i);
        betta=phi.betta(label,i);
        newB=b+(betta*(x-phi.mu0(label,i))^2)/(2*(1+betta));
        newA=a+0.5;
        %logg2g=computeGammaFrac(a,newA,params);
        %p=(b^a*gamma(newA))/(sqrt(2*pi*(1+1/betta))*gamma(a)*(newB^newA));
        %p=(gamma(newA)/gamma(a))*((b^a)/(newB^newA))*sqrt(betta/((betta+1)*2*pi));
        %         logg2g=0;
        %         tempa=a;
        %         tempNewA=newA;
        %         while tempa>2
        %             tempa=tempa-1;
        %             tempNewA=tempNewA-1;
        %             logg2g=logg2g+log(tempNewA/tempa);
        %         end
        %         logg2g=logg2g+log(gamma(tempNewA)/gamma(tempa));
        %logLikelihood=logLikelihood+eval(log(gamma(sym(newA))/gamma(sym(a))))+a*log(b)-newA*log(newB)+0.5*log(betta)-0.5*log((betta+1)*2*pi);
        logl=params.logG2G(2*a)+a*log(b)-newA*log(newB)+0.5*log(betta)-0.5*log((betta+1)*2*pi);
        logLikelihood=logLikelihood+logl;
    end
end
% logLikelihood=logLikelihood+log(mvnpdf(data(1+M1:end),phi.mu0(label,:),diag(phi.b(label,:)./phi.a(label,:))));
logLikelihood=logLikelihood+log(phi.py(label)/sum(phi.py));
end