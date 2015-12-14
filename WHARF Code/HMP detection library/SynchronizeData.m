function [ trials_data ] = SynchronizeData( subfolder )
%SYNCHRONIZEDATA Summary of this function goes here
%   Detailed explanation goes here
    
    UNSYNCED_DATA_FOLDER = 'Data\UNSYNCED_DATA\';
    MODELS_FOLDER        = 'Data\MODELS\';
    VALIDATION_FOLDER    = 'Data\VALIDATION\';
    
    left_watch = 1;
    right_watch = 2;
    
    folder_pattern = '(Day\d+)_(\w+)_(MODEL|VALIDATION)\\';
    tokens = regexp(subfolder, folder_pattern, 'tokens');
    
    sync_subfolder = [tokens{1}{1} '\'];
    data_name = tokens{1}{2};
    data_type = tokens{1}{3};

    % LOAD THE DELTA TIME BETWEEN WATCHES FOR SYNCHRONIZATION
    % load delta_time_sync.mat
    delta_time = FindWatchesSyncTimeDiff(sync_subfolder);

    % Get all trials data
    [trials_data, trials_names] = ReadValidationFiles([UNSYNCED_DATA_FOLDER subfolder]);
    num_trials = size(trials_data, 1);
    
    for i=1:1:num_trials
        % Get initial time diff
        old_time_diff = trials_data{i, left_watch}(1,1) - trials_data{i,right_watch}(1,1);
        old_time_diff = old_time_diff - delta_time;
        % Get sample that has smallest time diff
        for j=2:min(size(trials_data{i, left_watch}, 2), size(trials_data{i, right_watch}, 2))
            % Get timestamp diff between two watches samples
            time_diffs(1) = trials_data{i, left_watch}(1,j) - trials_data{i,right_watch}(1,1);
            time_diffs(2) = trials_data{i, left_watch}(1,1) - trials_data{i,right_watch}(1,j);
            real_time_diffs = time_diffs - delta_time;
            [~, index] = min(abs(real_time_diffs));
            current_time_diff = real_time_diffs(index);
            % If time diff crossed zero, means it's close to zero 
            if abs(current_time_diff) > abs(old_time_diff)
                break;
            end
            old_time_diff = current_time_diff;
        end
        
        % Trim data based on delta time of reference synchronous data
        if abs(real_time_diffs(1)) < abs(real_time_diffs(2))
            trials_data{i, left_watch} = trials_data{i, left_watch}(:,j-1:end);
        else
            trials_data{i, right_watch} = trials_data{i, right_watch}(:,j-1:end);
        end
        
        % Trim data to make two hands vectors same size
        data_size = min(size(trials_data{i, left_watch}, 2), size(trials_data{i, right_watch}, 2));
        trials_data{i, left_watch} = trials_data{i, left_watch}(:,1:data_size);
        trials_data{i, right_watch} = trials_data{i, right_watch}(:,1:data_size);
    end
    
    switch data_type
        case 'MODEL'
            trials_data = FilterModelData(trials_data);
            trials_folder = [MODELS_FOLDER data_name '_' data_type '\'];
            if ~isdir(trials_folder)
                mkdir(trials_folder);
            end
            for i=1:1:num_trials
                clear single_trial_data;
                single_trial_data{left_watch} = trials_data{i,left_watch};
                single_trial_data{right_watch} = trials_data{i,right_watch};
                save([trials_folder trials_names{i} '.mat'], 'single_trial_data');
            end
        case 'VALIDATION'
            
        otherwise
            disp(['Invalid data type in folder ' subfolder]);
    end
end

function [filtered_data] = FilterModelData( trials_data )
    % median filter parameters
    n = 3;      % order of the median filter
    left_watch = 1;
    right_watch = 2;
    % Filter data for all trials and all axis (x, y, z)
    filtered_data = cell(size(trials_data));
    num_trials = size(trials_data, 1);
    for i=1:1:num_trials
        for j=2:size(trials_data{i, left_watch}, 1)
            filtered_data{i, left_watch}(j,:) = medfilt1(trials_data{i, left_watch}(j,:),n);
            filtered_data{i, right_watch}(j,:) = medfilt1(trials_data{i, right_watch}(j,:),n);
        end
    end
end
