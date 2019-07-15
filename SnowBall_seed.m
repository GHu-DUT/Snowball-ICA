function [S_seed,iq]= SnowBall_seed(data,Comp,method,NumSub)
% PURPOSE
% Seed creation of Snowball ICA
%
% INPUTS
% data:      (matrix) the data to be decomposed
% Comp:      (scalar) number of extracted components for seed creation part
% method:    (string) 'FastICA'/'InfomaxICA'
% NumSub:    (scalar) number of subjects to be analyzed
%
% OUTPUTS
% S_seed:    (matrix/vector) estimated seed(s)
% iq:        (vector) stability index of seed(s)

% ver 1.1 030519 GQ

runs = 10;
sizeD = size(data);
NumScan = sizeD(2)/NumSub;
ind = randperm(NumSub);
for isSub = 1:NumSub
    data_ICA = data(:,(ind(isSub)-1)*NumScan+1:ind(isSub)*NumScan);
    [coeff,score,latent] = pca(data_ICA);
    [~,kurt_ind]=sort(zscore(kurtosis(score).*latent'),'descend');
%     score = score(:,kurt_ind);
    data_ICA = score(:,1:Comp);
    [S,W,iq,step]= RunICA(data_ICA,runs,Comp,method);
    [~,iq_ind] = sort(iq,'descend');
    S_seed = S(iq_ind(1:sum(iq>0.9)),:);
    if iq(iq_ind(1))>0.9
        break;
    end
end
end