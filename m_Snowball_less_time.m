clc
clear
close all

tic
%% load data;
load Mask.mat;
load AverageComp.mat;
AverageComp = AverageComp(2:end,Mask);
NumSample = 1000;
A = randn(NumSample,29);
data = A*AverageComp+0.1*randn(NumSample,sum(Mask(:)));
%% Parameters need to be modified
isComp = 1;
NumSub = 1;
Resultdir = 'Result_snowball';
%%
data_AllSub = data';
mkdir(Resultdir);
data_AllSub_seed = data_AllSub;
Comp = 10;
conflag = 1;
ItComp = 20;
while conflag
    startflag=0;
    %% Snowball ICA
    [S_seed,iq]= SnowBall_seed(data_AllSub_seed,Comp,'FastICA',NumSub);
    if max(iq)>0.9
        conflag=1;
    else
        conflag=0;
        break;
    end
    [ALLS,S_ref] = SnowBall_collection(data_AllSub,S_seed',ItComp,'FastICA');
    %% Remove estimated components
    [tc, spatial_maps] = snowball_dual_regress(data_AllSub_seed, S_ref);
    data_AllSub_seed = data_AllSub_seed-(tc*spatial_maps)';
    spatial_maps = S_ref;
    %% Save results
    for i = 1:size(S_ref,2)
        spatial_maps = S_ref(:,i);
        save([Resultdir filesep 'Comp#' num2str(isComp) '.mat'],'spatial_maps','-v7.3');
        isComp = isComp+1;
    end
end
%%
toc