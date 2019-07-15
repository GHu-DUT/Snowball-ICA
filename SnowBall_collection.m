function [ALLS,S_ref] = SnowBall_collection(data,S_seed,Comp,method)
% PURPOSE
% Information collection of Snowball ICA
%
% INPUTS
% data:       (matrix) the data to be decomposed
% S_seed:     (matrix/vector) estimated seed(s) by seed creation of ICA
% Comp:       (scalar) number of extracted components for information collection
% method:     (string) 'FastICA'/'InfomaxICA'
%
% OUTPUTS
% ALLS:      (cell) estimated spatial maps by each iteration
% S_ref:     (matrix/vector) final estimated component by Snowball

% ver 1.1 030519 GQ

NumSeed = size(S_seed,2);
S_ref = S_seed;
S_old = zeros(size(S_ref));
sizeD = size(data);
ind = randperm(sizeD(2));
data = data(:,ind);
ALLS = [];
cont = 0;
isScan = 1;
while isScan+Comp-1-NumSeed<=sizeD(2)
    cont = cont+1;
    data_ICA = [S_ref,data(:,isScan:isScan+Comp-1-NumSeed)];
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
% for isScan = 1:Comp-1-NumSeed:sizeD(2)-Comp
%     cont = cont+1;
%     data_ICA = [S_ref,data(:,isScan:isScan+Comp-2)];
%     fprintf('%s\n',['Snowball using ' method ': Round ' num2str(cont)]);
%     [S,W,iq,step]= RunICA(data_ICA,1,Comp,method);
%     rho = corr(S',S_ref);
%     [sort_rho,maxInd] = max(abs(rho));
%     rho_seed = abs(corr(S(maxInd,:)',S_seed));
%     %     if sort_rho(1)>0.5 && rho_seed>0.4
%     if sort_rho(1)>0.5
%         S_ref = S(maxInd,:)';
%         ALLS{isScan} = S_ref;
%         diff = norm(S_ref-S_old);
%         if diff<1e-4
%             break;
%         else
%             S_old = S_ref;
%         end
%     else
%         break;
%     end
% end