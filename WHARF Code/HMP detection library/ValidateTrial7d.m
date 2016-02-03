function [  ] = ValidateTrial7d( models, trial_data, file_name, debug_mode )

    % Define default value for flag debugMode as false
    if nargin < 4 || isempty(debug_mode)
        debug_mode = 0;
    end
	% Define constants
    res_folder = 'Data\RESULTS\';
    % Set result file names
    resultFileName = [res_folder 'RES_' files(k).name];
    graph_file_name = [res_folder 'GRAPH_' file_name(1:end-4)];
    graph_file_nameDTW = [res_folder 'GRAPHDTW_' file_name(1:end-4)];
    % transform the trial into a stream of samples
    current_data = trial_data(2:7,1:end);   % remove timestamp data
    numSamples = size(current_data, 2);
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
    min_window_size = min(models_size);
    window_size = max(models_size);
    
    % create an array with the models thresholds
    thresholds = zeros(1, numModels);
    for m=1:1:numModels
        thresholds(1, m) = models(m).threshold;
    end
    
    % Since two hands have same number of samples for a specific trial, get
    % number of samples from left hand.
    num_samples = size(trial_data, 2);
    % If number of samples in trial is smaller than window size, ignore
    % trial
    if num_samples < min_window_size
        disp(['Trial ' file_name(1:end-4) ' data is smaller than one of the models, so we cant run it. Will skip it!']);
        return;
    end
    
    % initialize the results arrays
    dist = zeros(1, numModels);
    hand_possibilities = zeros(1, numModels, 1);
    possibilities = zeros(1, numModels);
    
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
%         label = num2str(possibilities(j,1));
%         for m=2:1:numModels
%             label = [label,' ',num2str(possibilities(j,m))];
%         end
%         label = [label,'\n'];
%         resultFile = fopen(resultFileName,'a');
%         fprintf(resultFile,label);
%         fclose(resultFile);

        % plot the possibilities curves for the models
        x = min_window_size:1:numSamples;
    if debug_mode
        h1 = figure; set(h1,'Visible', 'on');
    else
        h1 = figure; set(h1,'Visible', 'off');
    end
            plot(x,possibilities(min_window_size:end,:));
            h1 = legend(models(:).name,numModels);
            set(h1,'Interpreter','none')
            print(graph_file_name, '-deps');
            print(graph_file_name, '-dpng');
    if debug_mode
        h2 = figure; set(h2,'Visible', 'on');
    else
        h2 = figure; set(h2,'Visible', 'off');
    end
            plot(x,possibilities_DTW(min_window_size:end,:));
            h2 = legend(models(:).name,numModels);
            set(h2,'Interpreter','none')
            print(graph_file_nameDTW, '-deps');
            print(graph_file_nameDTW, '-dpng');
            
        clear possibilities hand_possibilities hand_dist;
end