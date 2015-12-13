function [ trials_data ] = GetTimeSyncedData(  )
%GETTIMESYNCEDDATA Summary of this function goes here
%   Detailed explanation goes here

    % LOAD THE DELTA TIME BETWEEN WATCHES FOR SYNCHRONIZATION
    load delta_time_sync.mat

    % Get all trials data
    trials_data = ReadValidationFiles();
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
end

