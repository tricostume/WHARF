%THIS SCRIPT IS NOT FULLY EXECUTABLE. THIS NEEDS TO BE MODIFIED.
%PreprocessWHARF executes the pre-processing of the data. It reads the
%sensory data files and calls the PreprocessData function. The
%'preprocessed_data.mat' file is returned containg the preprocessed data.

save_folder = 'Data\PREPROCESSED_DATA\';
model_names = {'OpenCloseCurtains'};

folders = {'Open_Close_Curtains_MODEL\'};

for i=1:size(model_names, 2)
    folder = strcat('Data\MODELS\', folders{i});
    [processed_data] = PreprocessData( folder );
    numSamples=processed_data.size;
    save([save_folder model_names{i} '_PREPROCESSED.mat'], '', '-v7.3');
end