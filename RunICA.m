function [S, W,iq,step] = RunICA(data,runs,Comp,Method)
% PURPOSE
% ICA decomposition
%
% INPUTS
% data: (matrix) the data(Row<line) to be decomposed,
% runs: (scalar) the runs of fastICA
% Comp: (scalar) number of extracted component
% Method: (string) FastICA or InfomaxICA
%
% OUTPUTS
% S: (matrix) estimated components
% W: (matrix) unmixing matrix
% iq: (vector) stability index
% step: (scalar) number of iterations to converge

% ver 1.1 030519 GQ

%%
[coeff, score, latent] = pca(data);
%%
for comp = Comp
    X=score(:,1:comp)';
    switch Method
        case 'FastICA'
            [sR,step]=icassoEst('both', X,runs, 'lastEig', comp, 'g','tanh', ...
                'approach', 'symm');
        case 'InfomaxICA'
            [sR,step]=icassoEst_infomaxICA('both',X ,runs, 'lastEig', comp, 'g', 'tanh', ...
                'approach', 'symm');
        otherwise
            disp('Unknow method.');
    end
    %%
    if runs>1
        sR=icassoExp(sR);
        [iq,A,W,S] = icassoShow(sR,'L',comp,'colorlimit',[.8 .9]);
    else
        W = sR.W{1};
        S = W*sR.signal;
        iq = [];
    end
end
