function [S_seed,iq]= SnowBall_seed_Sub(Comp,method,Seed_DIR,file,isSub)
% PURPOSE
% Seed creation of Snowball ICA
%
% INPUTS
%
% Comp:      (scalar) number of extracted components for seed creation part
% method:    (string) 'FastICA'/'InfomaxICA'
% Seed_DIR:  (string) the location of warehouse
% file:      (struct) list of input subject
% isSub:     (scalar) the subject to be used for seed creation
%
% OUTPUTS
% S_seed:    (matrix/vector) estimated seed(s)
% iq:        (vector) stability index of seed(s)

% ver 1.1 030519 GQ

load([Seed_DIR filesep file(isSub).name]);
data_ICA = data;
[coeff,score,latent] = pca(data_ICA);
[S,W,iq,step]= RunICA(data_ICA,10,Comp,method);
[~,iq_ind] = sort(iq,'descend');
numSeed = sum(iq>0.9);
S_seed = S(iq_ind(1:numSeed),:);