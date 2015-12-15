%PreprocessWHARF executes the pre-processing of the data. It reads the
%sensory data files and calls the PreprocessData function. The raw data of
%two hands is time synced with respect to each other and also the different
%trials of each hand are synced together. This script saves two mat files
%containing the processed data of left and riht hand.

save_folder = 'Data\PREPROCESSED_DATA\';
model_names = {'OpenCloseCurtains', 'Sweeping', 'FillingCuponTap'};

folders = {'Open_Close_Curtains_MODEL\'; 'Sweeping_MODEL\'; 'Filling_Cup_on_Tap_MODEL\'};

for i=1:size(model_names, 2)
    folder = strcat('Data\MODELS\', folders{i});
    [processed_data] = PreprocessData( folder );
    left_x = processed_data.left.x;
    left_y = processed_data.left.y;
    left_z = processed_data.left.z;
    right_x = processed_data.right.x;
    right_y = processed_data.right.y;
    right_z = processed_data.right.z;
    numSamples = processed_data.size;
    save([save_folder model_names{i} '_PREPROCESSED.mat'], 'numSamples', 'left_x', 'left_y', 'left_z', 'right_x', 'right_y', 'right_z', '-v7.3');
end