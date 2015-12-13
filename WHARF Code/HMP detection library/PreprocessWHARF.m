%PreprocessWHARF executes the pre-processing of the data. It reads the
%sensory data files and calls the PreprocessData function. The
%'preprocessed_data.mat' file is returned containg the preprocessed data.

save_folder = 'Data\PREPROCESSED_DATA\';
model_names = {'OpenCloseCurtains'};

folders = {'Open_Close_Curtains_MODEL\'};

for i=1:size(model_names, 2)
    folder = strcat('Data\MODELS\', folders{i});
    [ numSamples x_set y_set z_set ] = PreprocessData( folder );
    save([save_folder model_names{i} '_PREPROCESSED.mat'], 'x_set', 'y_set', 'z_set', 'numSamples','-v7.3');
end