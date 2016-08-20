
clc;
clear;

%%
%datasetName='Spam';          % In order to change the dataset, uncomment the following lines
 datasetName='Elec';
% datasetName='Weather';
load (sprintf('Datasets/%s.mat',datasetName));
load('logg2g');                 % The precomputed values of Gamma function

%% Setting Run Parameters
params.BatchSize=50;           % Number of data in each batch
params.N=1;                    % Number of Samples in each iteration
params.Iter=100;               % Number of Iterations in each cycle
params.logG2G=logg2g;           

%% Setting Model parameters
params.n=size(dataset.data,1);              % Total number of data in dataset
params.M=size(dataset.data,2);              % Number of features of each datum
params.C=dataset.C;                         % Number of classes
params.M1=dataset.M1;                       % Number of Discrete Features
params.M2=dataset.M2;                       % Number of Continouese Features

params.alpha=50;                            % The Concentration Parameter
params.lambda=0.4;                          % The Reduction Factor in RCRP
params.delta=30;                            % The length of history in RCRP

% The Default Base Distribution parameters (G0)
py1=sum(dataset.labels==1)/params.n;
params.phi.py=[0.5,0.5];

if(params.M1>0)
    ConcentrationParameter=1;
    params.discreteLength=dataset.discreteLength;
    % Setting the Dirichlet parameters
    params.phi.gamma=cell(params.C);
    for c=1:params.C
        params.phi.gamma{c}=zeros(params.M1,max(dataset.discreteLength));
        for i=1:params.M1
            for j=1:dataset.discreteLength(i)
                params.phi.gamma{c}(i,j)=1/dataset.discreteLength(i);
            end
        end
    end
end
if(params.M2>0)
    % The Gaussian-Gamma parameters
    params.phi.mu0=zeros(params.C,params.M2);
    params.phi.betta=2*ones(params.C,params.M2);
    params.phi.a=1*ones(params.C,params.M2);
    params.phi.b=ones(params.C,params.M2);
end
params.logGammaOfHalf=log(gamma(0.5));
%% Running Forward Collapsed Gibbs Sampling
tic;
[estimatedLabels]=AdFCGS(dataset.data, dataset.labels , params);
MethodName=cell(1);
MethodName{1}='AdFCGS';
measures=evaluateResult(dataset.labels, estimatedLabels, params.BatchSize,MethodName);
fprintf('Accuracy=%2.2f\n precision=%2.2f\n recall=%2.2f\n F1=%2.2f\n kappa=%2.2f\n time=%2.2f\n',measures.totalAccuracy, measures.totalPrecision, measures.totalRecall, measures.totalF1, measures.totalKappa, toc);
save(sprintf('Results/%s_N_%d_Iter_%d_alpha_%2.2f_lambda_%2.2f_delta_%2.2f.mat',datasetName,params.N,params.Iter,params.alpha,params.lambda,params.delta),'estimatedLabels','measures');