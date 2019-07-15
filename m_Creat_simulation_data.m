clc
clear
close all

tic
%%
load Mask.mat;
load AverageComp.mat;
AverageComp = AverageComp(2:end,Mask);
NumSample = 1000;
A = randn(NumSample,29);
mkdir data;
for isSub = 1:3
    data = A*AverageComp+0.1*randn(NumSample,sum(Mask(:)));
    data = data';
    save(['data' filesep 'Sub' num2str(isSub,'%02d')],'data','-v7.3');
end
%%
toc