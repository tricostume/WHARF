function [  ] = ValidateTrial( models, trial_data, file_name, debug_mode )
%VALIDATETRIAL Summary of this function goes here
%   Detailed explanation goes here

    % Define default value for flag debugMode as false
    if nargin < 4 || isempty(debug_mode)
        debug_mode = 0;
    end
    
    % Define constants
    res_folder = 'Data\RESULTS\';
    model_hands = {'left_hand', 'right_hand'};
    
    % Set result file names
    result_file_name = [res_folder 'RES_' file_name(1:end-4)];
    graph_file_name = [res_folder 'GRAPH_' file_name(1:end-4)];
    
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
    min_window_size = min(models_size);
    window_size = max(models_size);
    % create an array with the models thresholds
    thresholds = zeros(numHands, numModels);
    for m=1:1:numModels
        for hand_index=1:numHands
            thresholds(hand_index, m) = models(m).(model_hands{hand_index}).threshold;
        end
    end
    
    % Since two hands have same number of samples for a specific trial, get
    % number of samples from left hand.
    num_samples = size(trial_data{1}, 2);
    % If number of samples in trial is smaller than window size, ignore
    % trial
    if num_samples < min_window_size
        disp(['Trial ' file_name(1:end-4) ' data is smaller than one of the models, so we cant run it. Will skip it!']);
        return;
    end
    
    % initialize the results arrays
    hand_dist = zeros(numHands, numModels);
    hand_possibilities = zeros(num_samples, numModels, numHands);
    
    for hand_index=1:1:numHands
        % transform the trial into a stream of samples
        current_data = trial_data{hand_index}(2:4,1:end);   % remove timestamp data
        % initialize the window of data to be used by the classifier
        window = zeros(window_size,3);
        numWritten = 0;
        for j=1:1:num_samples
            current_sample = current_data(:,j);
            % update the sliding window with the current sample
            [window, numWritten] = CreateWindow(current_sample,window,window_size,numWritten);
            % analysis is meaningful only when we have enough samples
            if (numWritten >= min_window_size)
                % compute the acceleration components of the current window of samples
                [gravity, body] = AnalyzeActualWindow(window,window_size);
                % compute the difference between the actual data and each model
                for m=1:1:numModels
                    model = models(m).(model_hands{hand_index});
                    % If current window size is bigger than model compute
                    % distance, else set distance to infinite so prob is 0
                    if numWritten > models_size(m)
                        hand_dist(hand_index, m) = CompareWithModels(gravity(end-models_size(m)+1:end-64,:),body(end-models_size(m)+1:end-64,:),model.gP,model.gS,model.bP,model.bS);
                    else
                        hand_dist(hand_index, m) = inf;
                    end
                end
                % classify the current data
                hand_possibilities(j,:, hand_index) = Classify(hand_dist(hand_index, :),thresholds(hand_index, :));
            else
                hand_possibilities(j,:, hand_index) = zeros(1,numModels);
            end
        end
    end

    % Get the full probability for both hands uncorrelated model
    possibilities = hand_possibilities(:,:, 1).*hand_possibilities(:,:, 2);
    
    save(result_file_name, ...
        'possibilities', ...
        'hand_possibilities', ...
        'hand_dist', ...
        '-v7.3');

    % plot the possibilities curves for the models
    x = min_window_size:1:num_samples;
    if debug_mode
        h = figure; set(h,'Visible', 'on');
    else
        h = figure; set(h,'Visible', 'off');
    end
        plot(x,possibilities(min_window_size:end,:));
        % title()
        h = legend(models(:).name,numModels);
        set(h,'Interpreter','none')
        print(graph_file_name, '-deps');
        print(graph_file_name, '-dpng');
    clear possibilities hand_possibilities hand_dist;
end

