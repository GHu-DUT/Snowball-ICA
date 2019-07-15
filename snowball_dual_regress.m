function [tc, spatial_maps] = snowball_dual_regress(y, X)
% PURPOSE
% Using dual regression approach to compute the spatial maps and time courses
%
% Inputs:
% y - Observations in columns (Voxels by time points)
% X - design matrix (Voxels by components)
%
% Outputs:
% tc - Time courses (Timepoints by components)
% spatial_maps - Spatial maps (Components by voxels)
%

X = snowball_remove_mean(X);
tc = pinv(X)*snowball_remove_mean(y);
tc = tc';
clear X;
% Store mean of timecourses
mean_tc = mean(tc);
% Remove mean of timecourse
tc = snowball_remove_mean(tc);
%% Second step. Fit Time courses at each voxel to get the spatial maps.
try
    spatial_maps = pinv(tc)*snowball_remove_mean(y');
catch
    %% Use less memory usage way to do regression
    % Initialise spatial maps
    spatial_maps = zeros(size(tc, 2), size(y, 1));
    % Loop over voxels
    for nVoxel = 1:size(y, 1)
        bold_signal = detrend(y(nVoxel, :), 0);
        spatial_maps(:, nVoxel) = pinv(tc)*bold_signal(:);
        clear bold_signal;
    end
    % End of loop over voxels
end
clear y;
%% Add mean back to the timecourses
tc = tc + (repmat(mean_tc, size(tc, 1), 1));
