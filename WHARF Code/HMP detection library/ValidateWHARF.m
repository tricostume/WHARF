% -------------------------------------------------------------------------
% Author: Barbara Bruno (dept. DIBRIS, University of Genova, ITALY)
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

% LOAD THE MODELS OF THE HMP IN HMPDATASET
% (models of the known activities and classification thresholds)
load models_and_thresholds.mat

% DEFINE THE VALIDATION FOLDER TO BE USED
folder = 'Data\VALIDATION\';

% DEFINE CONSTANTS
model_hands = {'left_hand', 'right_hand'};

% DEFINE THE VALIDATION PARAMETERS
% compute the size of the sliding window
% (size of the largest model + 64 samples)
numModels = length(models);
numHands = size(model_hands, 2);
models_size = zeros(1, numModels);
for m=1:1:numModels
    % Left hand model should have same size as hight hand, so just get one
    % of them
    models_size(m) = size(models(m).left_hand.bP,2)+64;
end
window_size = max(models_size);
% create an array with the models thresholds
thresholds = zeros(numHands, numModels);
for m=1:1:numModels
    for hand_index=1:numHands
        thresholds(hand_index, m) = models(m).(model_hands{hand_index}).threshold;
    end
end
% initialize the results arrays
hand_dist = zeros(numHands, numModels);
hand_possibilities = zeros(1, numModels, numHands);
possibilities = zeros(1, numModels);

% ANALYZE THE VALIDATION TRIALS ONE BY ONE, SAMPLE BY SAMPLE
files = [dir([folder,'*_Left.txt'])';
         dir([folder,'*_Right.txt'])'];
% Get number of data entries. Number of left and right files should be the
% same
for i=1:1:numFiles
    % create the log file
    res_folder = 'Data\RESULTS\';
    resultFileName = [res_folder 'RES_' files(1, i).name];
    for hand_index=1:1:numHands
        % transform the trial into a stream of samples
        current_file = fopen([folder files(hand_index, i).name],'r');
        current_data = fscanf(current_file,'a;%ld;%f;%f;%f\n',[4,inf]);
        current_data = current_data(2:4,1:end);   % remove timestamp data
        numSamples = length(current_data(1,:));
        % initialize the window of data to be used by the classifier
        window = zeros(window_size,3);
        numWritten = 0;
        for j=1:1:numSamples
            % update the sliding window with the current sample
            [window numWritten] = CreateWindow(current_sample,window,window_size,numWritten);
            % analysis is meaningful only when we have enough samples
            if (numWritten >= window_size)
                % compute the acceleration components of the current window of samples
                [gravity, body] = AnalyzeActualWindow(window,window_size);
                % compute the difference between the actual data and each model
                for m=1:1:numModels
                    model = models(m).(model_hands{hand_index});
                    hand_dist(hand_index, m) = CompareWithModels(gravity(1:models_size(m)-64,:),body(1:models_size(m)-64,:),model.gP,model.gS,model.bP,model.bS);
                end
                % classify the current data
                hand_possibilities(j,:, hand_index) = Classify(hand_dist(hand_index, :),thresholds(hand_index, :));
            else
                hand_possibilities(j,:, hand_index) = zeros(1,numModels);
            end
        end
        % log the classification results in the log file
        label = num2str(possibilities(j,1));
        for m=2:1:numModels
            label = [label,' ',num2str(possibilities(j,m))];
        end
        label = [label,'\n'];
        resultFile = fopen(resultFileName,'a');
        fprintf(resultFile,label);
        fclose(resultFile);
    end
    % plot the possibilities curves for the models
    x = window_size:1:numSamples;
    figure,
        plot(x,possibilities(window_size:end,:));
        h = legend(models(:).name,numModels);
        set(h,'Interpreter','none')
    clear possibilities;
end