clc
clear
close all

tic
%% Parameters need to be modified
InPut_DIR = 'data';
isComp = 1;
NumScan = 1000;
Resultdir = 'Result_snowball';
%%
file = dir([InPut_DIR filesep '*.mat']);
NumSub = length(file);
mkdir(Resultdir);
Comp = 10;
ItComp = 20;
cont = 0;
%% tips for reducing run time
if isComp == 1
    Seed_DIR = 'Seed';
    mkdir(Seed_DIR);
    copyfile(InPut_DIR,Seed_DIR);
    mkdir tmp;
    for isSub = 1:NumSub
        load([Seed_DIR filesep file(isSub).name]);
        for isScan = 1:NumScan
            cont = cont+1;
            isScandata = data(:,isScan);
            save(['tmp' filesep 'isScan' num2str(cont,'%010d')],'isScandata','-v7.3');
        end
    end
end
%%
while 1
    SubInd = randperm(NumSub);
    %% Seed creation
    for isSub = SubInd
        [S_seed,iq]= SnowBall_seed_Sub(Comp,'FastICA',Seed_DIR,file,isSub);
        if max(iq)>0.9
            break;
        end
    end
    if isSub==SubInd(end) && max(iq)<=0.9
        break;
    end
    %% Information collection
    [ALLS,S_ref] = SnowBall_collection_Sub(S_seed',ItComp,'FastICA',NumSub,NumScan);
    %% Remove estimated Component
    for isSub = 1:NumSub
        load([Seed_DIR filesep file(isSub).name]);
        [tc, spatial_maps] = snowball_dual_regress(data, S_ref);
        data = data-(tc*spatial_maps)';
        save([Seed_DIR filesep file(isSub).name],'data','-v7.3');
    end
    %% Save results
    for i = 1:size(S_ref,2)
        spatial_maps = S_ref(:,i);
        save([Resultdir filesep 'Comp#' num2str(isComp) '.mat'],'spatial_maps','-v7.3');
        isComp = isComp+1;
    end
end
%% Delet temporal files
rmdir Seed s;
rmdir tmp s;
%%
toc