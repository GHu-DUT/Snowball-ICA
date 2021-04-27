clc
clear
close all
%dbstop if error
%profile on -memory

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
ItComp = 10;
Run = 0;
spatial_maps = [];
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
    [ALLS,S_ref] = SnowBall_collection(data_AllSub_seed,S_seed',ItComp,'FastICA');
    %% Save results
    spatial_maps = [spatial_maps S_ref];
    Run = Run+1;
    save([Resultdir filesep 'Run#' num2str(Run) '.mat'],'spatial_maps','-v7.3');
   %% Remove estimated components
    [tc, spatial] = snowball_dual_regress(data_AllSub, spatial_maps);
    data_AllSub_seed = data_AllSub-(tc*spatial)';
end
%%
toc
%profsave(profile('info'),pwd)
%profile off