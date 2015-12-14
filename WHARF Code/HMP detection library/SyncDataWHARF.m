
% Constants declaration
UNSYNCED_DATA_FOLDER = 'Data\UNSYNCED_DATA\';

% Get list of data to be synced
files = dir(UNSYNCED_DATA_FOLDER);
files = files(~ismember({files.name},{'.','..'}));

% Builds all specified models
for i=1:length(files)
    folder = [files(i).name '\'];
    fprintf('Syncing %s folder...\n', folder);
    % Synchronizes and saves data in specified folder
    SynchronizeData(folder);
end