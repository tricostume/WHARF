% -------------------------------------------------------------------------
% Authors: Tiago P M da Silva (dept. DIBRIS, University of Genova, ITALY)
%          Divya Haresh Shah (dept. DIBRIS, University of Genova, ITALY)
%          Ernesto Denicia (dept. DIBRIS, University of Genova, ITALY)
%          Barbara Bruno (dept. DIBRIS, University of Genova, ITALY)
%
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%
% This code is the implementation of the algorithms described in the
% paper "Analysis of human behavior recognition algorithms based on
% acceleration data".
%
% I would be grateful if you refer to the paper in any academic
% publication that uses this code or part of it.
% Here is the BibTeX reference:
% @inproceedings{Bruno13,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa and T. Vernazza and R. Zaccaria",
% title = "Analysis of human behavior recognition algorithms based on acceleration data",
% booktitle = "Proceedings of the IEEE International Conference on Robotics and Automation (ICRA 2013)",
% address = "Karlsruhe, Germany",
% month = "May",
% year = "2013"
% }
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% This function is associated to the public dataset WHARF Data Set.
% (free download at: https://github.com/fulviomas/WHARF)
% The WHARF Data Set and its rationale are described in the paper "A Public
% Domain Dataset for ADL Recognition Using Wrist-placed Accelerometers".
%
% I would be grateful if you refer to the paper in any academic
% publication that uses this code or the WHARF Data Set.
% Here is the BibTeX reference:
% @inproceedings{Bruno14c,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa",
% title = "A Public Domain Dataset for {ADL} Recognition Using Wrist-placed Accelerometers",
% booktitle = "Proceedings of the 23rd {IEEE} International Symposium on Robot and Human Interactive Communication ({RO-MAN} 2014)",
% address = "Edinburgh, UK",
% month = "August",
% year = "2014"
% }
% -------------------------------------------------------------------------
%
% ValidateWHARF allows to test the models built by the function
% BuildWHARF with the validation trials associated to the same
% dataset. It feeds the Classifier with the samples recorded in one
% validation trial one-by-one, waiting for the completion of the previous
% classification before feeding the Classifier with a new sample.
% So as to validate two handed tasks, it assumes they are independent and
% multiplies their probabilities together to get the probability of the
% joint action.

% LOAD THE MODELS OF THE HMP IN HMPDATASET
% (models of the known activities and classification thresholds)
load models_and_thresholds.mat

% DEFINE THE VALIDATION FOLDER TO BE USED AND GET DATA FROM IT
main_folder = 'Data\VALIDATION\';
% Get list of folders with data to be validated
folders = dir(main_folder);
folders = folders(~ismember({folders.name},{'.','..'}));

% Builds all specified models
for i=1:length(folders)
    folder = [folders(i).name '\'];
    trials_data = GetTrialsData([main_folder folder]);
    % For seven dimensions data must be packed in an only structure 
    % including both hands. Notice time of left hand is imposed on both
    for packing = 1:size(trials_data,1)
        trials_dataT{packing,1}(1:7,:) = [trials_data{packing,1}(1:4,:); ...
                                          trials_data{packing,2}(2:4,:)];
    end
    clear trials_data
    trials_data = trials_dataT;
    clear trials_dataT

    
    % DEFINE THE VALIDATION PARAMETERS
    % compute the size of the sliding window
    % (size of the largest model + 64 samples)
    numModels = length(models);
    %numHands = size(model_hands, 2);
    models_size = zeros(1, numModels);
    for m=1:1:numModels
        % Left hand model should have same size as right hand, so just get one
        % of them
        models_size(m) = size(models(m).bP,2)+64;
    end
    window_size = max(models_size);
    % create an array with the models thresholds
    thresholds = zeros(1, numModels);
    for m=1:1:numModels
        %for hand_index=1:numHands
            thresholds(1, m) = models(m).threshold;
        %end
    end
    % initialize the results arrays
    dist = zeros(1, numModels);
    hand_possibilities = zeros(1, numModels, 1);
    possibilities = zeros(1, numModels);

    % ANALYZE THE VALIDATION TRIALS ONE BY ONE, SAMPLE BY SAMPLE
    files = dir([[main_folder folder], '*.mat'])';
    % Get number of data entries.
    numFiles = size(trials_data, 1);
    for k=1:1:numFiles
        % create the log file
        res_folder = 'Data\RESULTS\';
        resultFileName = [res_folder 'RES_' files(k).name];
   %     for hand_index=1:1:numHands
            % transform the trial into a stream of samples
            current_data = trials_data{k}(2:7,1:end);   % remove timestamp data
            numSamples = size(current_data, 2);
            % If number of samples in trial is smaller than window size, ignore it
            if numSamples < window_size
                disp(['Trial ' int2str(k) ' data is smaller than one of the models, so we cant run it. Will skip it!']);
                continue
            end
            % initialize the window of data to be used by the classifier
            window = zeros(window_size,6);
            numWritten = 0;
            for j=1:1:numSamples
                current_sample = current_data(:,j);
                % update the sliding window with the current sample
                [window, numWritten] = CreateWindow(current_sample,window,window_size,numWritten);
                % analysis is meaningful only when we have enough samples
                if (numWritten >= window_size)
                    % compute the acceleration components of the current window of samples
                    [gravity, body] = AnalyzeActualWindow7d(window,window_size);
                    % compute the difference between the actual data and each model
                    for m=1:1:numModels
                        model = models(m);
                        dist(1, m) = CompareWithModels7d(gravity(1:models_size(m)-64,:),body(1:models_size(m)-64,:),model.gP,model.gS,model.bP,model.bS);
                        dist_DTW(1,m) = CompareWithModels_DTW(gravity(1:models_size(m)-64,:),body(1:models_size(m)-64,:),model.gP,model.gS,model.bP,model.bS);

                    end
                    % classify the current data
                    hand_possibilities(j,:, 1) = Classify(dist(1, :),thresholds(1, :));
                    hand_possibilities_DTW(j,:,1) = Classify(dist_DTW(1, :),thresholds(1, :));
                else
                    hand_possibilities(j,:, 1) = zeros(1,numModels);
                    hand_possibilities_DTW(j,:, 1) = zeros(1,numModels);
                end
            end
      %  end



        % log the classification results in the log file
        possibilities = hand_possibilities(:,:, 1);
        possibilities_DTW = hand_possibilities_DTW(:,:,1);
        label = num2str(possibilities(j,1));
        for m=2:1:numModels
            label = [label,' ',num2str(possibilities(j,m))];
        end
        label = [label,'\n'];
        resultFile = fopen(resultFileName,'a');
        fprintf(resultFile,label);
        fclose(resultFile);

        % plot the possibilities curves for the models
        x = window_size:1:numSamples;
        figure,
            plot(x,possibilities(window_size:end,:));
            plot(x,possibilities_DTW(window_size:end,:));
            h = legend(models(:).name,numModels);
            set(h,'Interpreter','none')
        clear possibilities hand_possibilities hand_dist;
    end
end