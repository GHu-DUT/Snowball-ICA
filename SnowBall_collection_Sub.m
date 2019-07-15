function [ALLS,S_ref] = SnowBall_collection_Sub(S_seed,Comp,method,NumSub,NumScan)
% PURPOSE
% Information collection of Snowball ICA
%
% INPUTS
% S_seed:     (matrix/vector) estimated seed(s) by seed creation of ICA
% Comp:       (scalar) number of extracted components for information collection
% method:     (string) 'FastICA'/'InfomaxICA'
% NumSub:     (scalar) the number of subjects to be analyzed
% NumScan:    (scalar) the number of scans for each subject
%
% OUTPUTS
% ALLS:      (cell) estimated spatial maps by each iteration
% S_ref:     (matrix/vector) final estimated component by Snowball

% ver 1.1 030519 GQ


NumSeed = size(S_seed,2);
S_ref = S_seed;
S_old = zeros(size(S_ref));
sizeD(2) = NumSub*NumScan;
ind = randperm(sizeD(2));
ALLS = [];
cont = 0;
isScan = 1;
while isScan+Comp-1-NumSeed<=sizeD(2)
    cont = cont+1;
    data_ICA = S_ref;
    for is = ind(:,isScan:isScan+Comp-1-NumSeed)
        load(['tmp' filesep 'isScan' num2str(is,'%010d')]);
        data_ICA = [data_ICA isScandata];
    end
    isScan = isScan+Comp-NumSeed;
    [S,W,iq,step]= RunICA(data_ICA,1,Comp,method);
    rho = corr(S',S_ref);
    [sort_rho,maxInd] = max(abs(rho));
    rho_seed = mean(max(abs(corr(S(maxInd,:)',S_seed))'));
    fprintf('%s\n',['Snowball using ' method ': Round ' num2str(cont)...
        '  It rho:' num2str(mean(sort_rho))...
        '  Seed rho:' num2str(rho_seed)]);
    if mean(sort_rho)>0.5
        S_ref = S(unique_unsorted(maxInd),:)';
        NumSeed = size(S_ref,2);
        %ALLS{isScan} = S_ref;
%         diff = norm(S_ref-S_old);
%         if diff<1e-4
%             break;
%         else
%             S_old = S_ref;
%         end
    else
        break;
    end
end