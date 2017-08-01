% -------------------------------------------------------------------------
% Authors: Tiago P M da Silva (dept. DIBRIS, University of Genova, ITALY)
%          Divya Haresh Shah (dept. DIBRIS, University of Genova, ITALY)
%          Ernesto Denicia (dept. DIBRIS, University of Genova, ITALY)
%
% 
% -------------------------------------------------------------------------
% This function is associated to the public dataset WHARF Data Set.
% (free download at: https://github.com/tiagopms/WHARF)
% 
% -------------------------------------------------------------------------
%
% CreateReducedKFolds executes the Creates KFold data reduced to test model
% robustness.

k = 6;
keep_of_five = 4;

% Models to be ran
model_names = {'OpenCloseCurtains', 'Sweeping', 'FillingCuponTap', ...
    'RemovingFromFridge', 'WardrobeOpening'};
folder = 'Data\PREPROCESSED_DATA\';
SAVE_PATH = [folder 'REDUCED\' int2str(keep_of_five) '\'];

% Get and reduce data
for j=1:size(model_names, 2)
    fprintf('Reducing %s model...\n', model_names{j});
    %Getting the required mat file for the model into consideration
    modelfile = strcat(folder, model_names{j}, '_PREPROCESSED.mat');
    
    % EXTRACT THE ACCELEROMETER PREPREOCESSED DATA FROM THE MAT FILES
    processed_data = GetProcessedData(modelfile);
    numSamples = processed_data.size;
    
    downsize = ceil(numSamples * keep_of_five / 5);
    downsampled_data_left_x = zeros(size(processed_data.left.x, 1), ceil(numSamples * keep_of_five / 5));
    downsampled_data_left_y = zeros(size(processed_data.left.y, 1), ceil(numSamples * keep_of_five / 5));
    downsampled_data_left_z = zeros(size(processed_data.left.z, 1), ceil(numSamples * keep_of_five / 5));
    downsampled_data_right_x = zeros(size(processed_data.left.x, 1), ceil(numSamples * keep_of_five / 5));
    downsampled_data_right_y = zeros(size(processed_data.left.y, 1), ceil(numSamples * keep_of_five / 5));
    downsampled_data_right_z = zeros(size(processed_data.left.z, 1), ceil(numSamples * keep_of_five / 5));
    
    count = 0;
    for i=1:numSamples
        if mod(i, 5) < keep_of_five
            count = count + 1;
            downsampled_data_left_x(:, count) = processed_data.left.x(:, i);
            downsampled_data_left_y(:, count) = processed_data.left.y(:, i);
            downsampled_data_left_z(:, count) = processed_data.left.z(:, i);
            downsampled_data_right_x(:, count) = processed_data.right.x(:, i);
            downsampled_data_right_y(:, count) = processed_data.right.y(:, i);
            downsampled_data_right_z(:, count) = processed_data.right.z(:, i);
        end
    end
    
    processed_data.left.x = downsampled_data_left_x;
    processed_data.left.y = downsampled_data_left_y;
    processed_data.left.z = downsampled_data_left_z;
    processed_data.right.x = downsampled_data_right_x;
    processed_data.right.y = downsampled_data_right_y;
    processed_data.right.z = downsampled_data_right_z;
    processed_data.size = downsize;
    processed_data.keep = keep_of_five;
    
    save([SAVE_PATH model_names{j} '_PREPROCESSED.mat'], 'processed_data', '-v7.3');
%     keyboard
end
