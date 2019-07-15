%PURPOSE
%
%To Show simulation results.

clc
clear
close all

tic
%%
load AverageComp.mat;
load Mask.mat;
AverageComp = AverageComp(2:end,Mask);
cont = 0;
Comp = 29;figure;
Coeff(1:29) = nan;
for isComp = 1:Comp
  load(['Result_snowball' filesep 'Comp#' num2str(isComp) '.mat'],'spatial_maps');
    [rho, ind]= max(abs(corr(spatial_maps,AverageComp')));
    if rho>0.5
        Coeff(ind) = rho;
        cont = cont+1;
        subplot(5,6,ind)
        S_map = zeros(148,148);
        S_map(Mask) = spatial_maps;
        imagesc(S_map);colormap(jet);axis equal;axis off;
        title(['#' num2str(isComp) ' \rho=' num2str(rho)],'fontsize',24);
    end
end
%%
toc