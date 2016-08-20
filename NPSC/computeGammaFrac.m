function logg2g=computeGammaFrac(a,newA, params)
if a==1
    logg2g=log(0.5*params.gammaOfHalf);
    return;
end
if a==0.5
    logg2g=-log(params.gammaOfHalf);
    return;
end
if mod(a,1)==0
    logg2g=sum(log(0.5:1:(newA-1)))+log(params.gammaOfHalf)-sum(log(1:(a-1)));
else
    logg2g=sum(log(1:(newA-1)))-sum(log(0.5:1:(a-1)))-log(params.gammaOfHalf);
end
end