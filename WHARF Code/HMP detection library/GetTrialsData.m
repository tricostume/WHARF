function [ trials_data ] = GetTrialsData( folder )
%GETTRIALSDATA Summary of this function goes here
%   Detailed explanation goes here

    % Get all mat files in specified folder and number of trial entries.
    files = dir([folder,'*.mat']);
    num_files = size(files, 1);
    
    % Load data and save it in trials_data
    trials_data = cell(num_files, 2);
    for i=1:num_files
        load([folder files(i).name]);
        trials_data{i,1} = single_trial_data{1,1}; %#ok<*USENS> Remove warning
        trials_data{i,2} = single_trial_data{1,2};
    end
end

