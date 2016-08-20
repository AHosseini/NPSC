function Samples=initiateFCGS(params)
N=params.N;  % Number of Samples
Samples=[];
for i=1:N
    sample.K=0;
    sample.num=[];
    sample.phi=[];
    Samples=[Samples;sample];
end
end