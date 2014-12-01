function varargout = HMPdetector(varargin)
% *GUI* HMPdetector
%
% -------------------------------------------------------------------------
% Author: Barbara Bruno (dept. DIBRIS, University of Genova, ITALY)
%
% This code is the implementation of the algorithms described in the
% papers "Human motion modeling and recognition: a computational approach"
% (modelling part) and "Analysis of human behavior recognition algorithms
% based on acceleration data" (classification part).
%
% I would be grateful if you refer to the papers in any academic
% publication that uses this code or part of it.
% Here are the BibTeX reference:
% @inproceedings{Bruno12,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa and T. Vernazza and R. Zaccaria",
% title = "Human motion modeling and recognition: a computational approach",
% booktitle = "Proceedings of the 8th {IEEE} International Conference on Automation Science and Engineering ({CASE} 2012)",
% address = "Seoul, Korea",
% year = "2012",
% month = "August"
% }
% @inproceedings{Bruno13,
% author = "B. Bruno and F. Mastrogiovanni and A. Sgorbissa and T. Vernazza and R. Zaccaria",
% title = "Analysis of human behavior recognition algorithms based on acceleration data",
% booktitle = "Proceedings of the IEEE International Conference on Robotics and Automation (ICRA 2013)",
% address = "Karlsruhe, Germany",
% month = "May",
% year = "2013"
% }
% -------------------------------------------------------------------------
%
% HMPdetector is a graphical user interface for the creation and validation
% of Human Motion Primitives (HMP) models based on the WHARF Data Set.
% (free download at: https://github.com/fulviomas/WHARF)
%
% With HMPdetector you can:
% - choose which model(s) to build
% - choose any combination of available models for trial validation
% - add, update and remove models
% - add, update and remove validation trials
%
% Input:
%   NONE REQUIRED
%
% Output:
%   - [figures] will appear in embbeded boxes
%   - [validation results] will be saved in 'Data/RESULTS'
%
% Example:
%   hHMPdetector
 
% VARIABLES DECLARATION & INITIALIZATION
ALLflag = 0;
model_name = '';
folder = '';
scale = 1.5;  % experimentally set scaling factor for the threshold
TrialFileName = '';
TrialPathName = '';
models(1) = struct('name','','gP',0,'gS',0,'bP',0,'bS',0,'threshold',0);
activeModels(1) = struct('active','');
numModels = 0;

% INITIALIZATION TASKS
% create the HMPdetector GUI and hide it until initialization is done
screen_size = get(0,'ScreenSize');
left_edge = 0;
bottom_edge = 0;
width = screen_size(3)/1.5;
height = screen_size(4)/1.8;
HMPcode_handle = figure('MenuBar','figure',...
                        'Name','HMPdetector',...
                        'NumberTitle','off',...
                        'Position',[left_edge,bottom_edge,width,height],...
                        'Resize','on',...
                        'Toolbar','figure',...
                        'Units','pixels',...
                        'Visible','off');
defaultBackground = get(0,'defaultUicontrolBackgroundColor');
set(HMPcode_handle,'Color',defaultBackground);

% CONSTRUCT THE COMPONENTS
% create the "Model Builder" panel
panel_ModelBuilder = uipanel('Parent',HMPcode_handle,...
                             'Title','Model Builder',...
                             'FontSize',9,...
                             'BorderWidth',1.5,...
                             'Position',[.01 .01 .29 .99]);

% create the "Results" panel
panel_Results = uipanel('Parent',HMPcode_handle,...
                        'Title','Results',...
                        'FontSize',9,...
                        'BorderWidth',1.5,...
                        'Position',[.31 .51 .38 .49]);

% create the "Classifier" panel
panel_Classifier = uipanel('Parent',HMPcode_handle,...
                           'Title','Classifier',...
                           'FontSize',9,...
                           'BorderWidth',1.5,...
                           'Position',[.7 .01 .29 .99]);

% create the "Instructions" panel
panel_Instructions = uipanel('Parent',HMPcode_handle,...
                             'Title','Instructions',...
                             'FontSize',9,...
                             'BorderWidth',1.5,...
                             'Position',[.31 .18 .38 .32]);
                                                  
% write the Instructions
text_Instr = uicontrol(panel_Instructions,'Style','text',...
                       'FontUnits','normalized',...
                       'FontSize',.07,...
                       'String',{'In the Model Builder:';
                       '1) Select the HMP to model (or ALL)';
                       '2) Build (& go for a coffee!)';
                       '3) View model: Model projections appear in the HMP model box.';'';
                       'In the Classifier:';
                       '1) Browse to the validation trial to test';
                       '2) View: Trial axes readings appear in the Validation trial box.';
                       '3) Analyze (& go for lunch!):';
                       '    Models possibilities appear in the Possibilities box.'},...
                       'HorizontalAlignment','left',...
                       'Units','normalized',...
                       'Position',[.05 .05 .9 .9]);

% create the "Authors" panel
panel_Authors = uipanel('Parent',HMPcode_handle,...
                        'Title','Authors',...
                        'FontSize',9,...
                        'BorderWidth',1.5,...
                        'Position',[.31 .01 .38 .16]);

% create the "Logo" axes
axes_Logo = axes('Parent',panel_Authors,...
                 'Position',[.01 .05 .13 .95]);
% add the UniGE logo
imshow('Logo/logo_unige.gif');
                    
% write the Authors
text_Auth = uicontrol(panel_Authors,'Style','text',...
                      'FontUnits','normalized',...
                      'FontSize',.15,...
                      'String',{'Barbara Bruno, Fulvio Mastrogiovanni, Antonio Sgorbissa';
                      'Department of Computer Engineering, Bioengineering, Robotics and Systems Engineering - DIBRIS';
                      'University of Genova';
                      'via Opera Pia 13, 16145, Genova, Italia'},...
                      'HorizontalAlignment','left',...
                      'Units','normalized',...
                      'Position',[.15 .05 .8 .9]);

% create the popup "HMP" in the "Model Builder" panel
text_HMP = uicontrol(panel_ModelBuilder,'Style','text',...
                     'FontUnits','normalized',...
                     'FontSize',.5,...
                     'String','HMP to model:',...
                     'HorizontalAlignment','left',...
                     'Units','normalized',...
                     'Position',[.05 .94 .9 .05]);
popup_HMP = uicontrol(panel_ModelBuilder,'Style','popupmenu',...
                      'FontUnits','normalized',...
                      'FontSize',.5,...
                      'String',{'ALL','Climb the stairs','Drink from a glass','Get up from the bed','Pour water in a glass','Sit down on a chair','Stand up from a chair','Walk'},...
                      'Value',1,...
                      'Units','normalized',...
                      'Position',[.05 .91 .9 .05],...
                      'Callback',{@callback_HMP});

% create the pushbutton "Build" in the "Model Builder" panel
pushbutton_Build = uicontrol(panel_ModelBuilder,'Style','pushbutton',...
                             'FontUnits','normalized',...
                             'FontSize',.5,...
                             'String','Build',...
                             'Units','normalized',...
                             'Position',[.05 .83 .9 .05],...
                             'Callback',{@callback_Build});

% create the pushbutton "View model" in the "Model Builder" panel
pushbutton_ViewModel = uicontrol(panel_ModelBuilder,'Style','pushbutton',...
                                 'FontUnits','normalized',...
                                 'FontSize',.5,...
                                 'String','View model',...
                                 'Units','normalized',...
                                 'Position',[.05 .75 .9 .05],...
                                 'Callback',{@callback_ViewModel});

% create the panel environment for the figures of "Model Builder"
figure_ModelBuilder = uipanel('Parent',panel_ModelBuilder,...
                              'Title','HMP model',...
                              'FontSize',8,...
                              'BorderWidth',1,...
                              'Tag','figureModel',...
                              'Units','normalized',...
                              'Position',[.05 .02 .9 .7]);

% create the panel environment for the figures of "Results"
figure_Results = uipanel('Parent',panel_Results,...
                         'Title','Possibilities',...
                         'FontSize',8,...
                         'BorderWidth',1,...
                         'Tag','figureModel',...
                         'Units','normalized',...
                         'Position',[.05 .05 .9 .94]);

% create the pushbutton "Select trial" in the "Classifier" panel
pushbutton_SelTrial = uicontrol(panel_Classifier,'Style','pushbutton',...
                                'FontUnits','normalized',...
                                'FontSize',.5,...
                                'String','Select validation trial...',...
                                'Units','normalized',...
                                'Position',[.05 .91 .9 .05],...
                                'Callback',{@callback_SelTrial});

% create the pushbutton "View" in the "Classifier" panel
pushbutton_View = uicontrol(panel_Classifier,'Style','pushbutton',...
                            'FontUnits','normalized',...
                            'FontSize',.5,...
                            'String','View',...
                            'Units','normalized',...
                            'Position',[.05 .83 .9 .05],...
                            'Callback',{@callback_View});

% create the pushbutton "Analyze" in the "Classifier" panel
pushbutton_Analyze = uicontrol(panel_Classifier,'Style','pushbutton',...
                               'FontUnits','normalized',...
                               'FontSize',.5,...
                               'String','Analyze',...
                               'Units','normalized',...
                               'Position',[.05 .75 .9 .05],...
                               'Callback',{@callback_Analyze});

% create the panel environment for the figures of "Classifier"
figure_Classifier = uipanel('Parent',panel_Classifier,...
                            'Title','Validation trial',...
                            'FontSize',8,...
                            'BorderWidth',1,...
                            'Tag','figureTrial',...
                            'Units','normalized',...
                            'Position',[.05 .02 .9 .7]);

% INITIALIZATION TASKS
% move the GUI to the center of the screen
movegui(HMPcode_handle,'center')
% make the GUI visible
set(HMPcode_handle,'Visible','on');

% CALLBACKS
% callback of popup "HMP"
function callback_HMP(source,eventdata)
    % identify which HMP was selected
    str = get(source, 'String');
    val = get(source,'Value');
    % set the modelling folder to the corresponding one
    switch str{val};
        case 'ALL'
            ALLflag = 1;
        case 'Climb the stairs'
            ALLflag = 0;
            model_name = 'Climb_stairs';
            folder = 'Data\MODELS\Climb_stairs_MODEL\';
        case 'Drink from a glass'
            ALLflag = 0;
            model_name = 'Drink_glass';
            folder = 'Data\MODELS\Drink_glass_MODEL\';
        case 'Get up from the bed'
            ALLflag = 0;
            model_name = 'Getup_bed';
            folder = 'Data\MODELS\Getup_bed_MODEL\';
        case 'Pour water in a glass'
            ALLflag = 0;
            model_name = 'Pour_water';
            folder = 'Data\MODELS\Pour_water_MODEL\';
        case 'Sit down on a chair'
            ALLflag = 0;
            model_name = 'Sitdown_chair';
            folder = 'Data\MODELS\Sitdown_chair_MODEL\';
        case 'Stand up from a chair'
            ALLflag = 0;
            model_name = 'Standup_chair';
            folder = 'Data\MODELS\Standup_chair_MODEL\';
        case 'Walk'
            ALLflag = 0;
            model_name = 'Walk';
            folder = 'Data\MODELS\Walk_MODEL\';
    end
end

% callback of pushbutton "Build"
function callback_Build(source,eventdata)
    if(ALLflag == 1)
        % build model of Climb_stairs
        model_name = 'Climb_stairs';
        folder = 'Data\MODELS\Climb_stairs_MODEL\';
        [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
        threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
        models(1) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
        activeModels(1) = struct('active',{model_name});
        clear TMgP TMgS TMbP TMbS
        % build model of Drink_glass
        model_name = 'Drink_glass';
        folder = 'Data\MODELS\Drink_glass_MODEL\';
        [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
        threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
        models(2) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
        activeModels(2) = struct('active',{model_name});
        clear TMgP TMgS TMbP TMbS
        % build model of Getup_bed
        model_name = 'Getup_bed';
        folder = 'Data\MODELS\Getup_bed_MODEL\';
        [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
        threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
        models(3) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
        activeModels(3) = struct('active',{model_name});
        clear TMgP TMgS TMbP TMbS
        % build model of Pour_water
        model_name = 'Pour_water';
        folder = 'Data\MODELS\Pour_water_MODEL\';
        [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
        threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
        models(4) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
        activeModels(4) = struct('active',{model_name});
        clear TMgP TMgS TMbP TMbS
        % build model of Sitdown_chair
        model_name = 'Sitdown_chair';
        folder = 'Data\MODELS\Sitdown_chair_MODEL\';
        [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
        threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
        models(5) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
        activeModels(5) = struct('active',{model_name});
        clear TMgP TMgS TMbP TMbS
        % build model of Standup_chair
        model_name = 'Standup_chair';
        folder = 'Data\MODELS\Standup_chair_MODEL\';
        [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
        threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
        models(6) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
        activeModels(6) = struct('active',{model_name});
        clear TMgP TMgS TMbP TMbS
        % build model of Walk
        model_name = 'Walk';
        folder = 'Data\MODELS\Walk_MODEL\';
        [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
        threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
        models(7) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
        activeModels(7) = struct('active',{model_name});
        numModels = 7;
        clear TMgP TMgS TMbP TMbS
    else
        % if this is the first model, build it
        if(numModels == 0)
            numModels = 1;
            [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
            threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
            models(1) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
            activeModels(1) = struct('active',{model_name});
            clear TMgP TMgS TMbP TMbS
        else
            % check if the model already exists
            updatePosition = 0;
            for i=1:1:numModels
                if(strcmp(activeModels(i).active,model_name))
                    updatePosition = i;
                end
            end
            % if the model already exists, update it
            if(updatePosition ~= 0)
                [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
                threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
                models(updatePosition) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
                clear TMgP TMgS TMbP TMbS
            % if the model does not exist, build it
            else
                numModels = numModels+1;
                [TMgP TMgS TMbP TMbS] = GenerateModel(folder);
                threshold = ComputeThreshold(TMgP,TMgS,TMbP,TMbS,scale);
                models(numModels) = struct('name',{model_name},'gP',TMgP,'gS',TMgS,'bP',TMbP,'bS',TMbS,'threshold',threshold);
                activeModels(numModels) = struct('active',{model_name});
                clear TMgP TMgS TMbP TMbS
            end
        end
    end
end

% callback of pushbutton "ViewModel"
function callback_ViewModel(source,eventdata)
    gr_points = 0;
    gr_sigma = 0;
    b_points = 0;
    b_sigma = 0;
    UPDATEflag = 0;
    % check if the model already exists
    for i=1:1:numModels
        if(strcmp(activeModels(i).active,model_name))
            gr_points = models(i).gP;
            gr_sigma = models(i).gS;
            b_points = models(i).bP;
            b_sigma = models(i).bS;
            numGMRPoints = size(models(i).gP,2);
            UPDATEflag = 1;
            break;
        end
    end
    % if the model doesn't exist, clear all axes
    if(UPDATEflag == 0)
        s1=subplot(3,2,1,'Parent',figure_ModelBuilder);
        cla %clear axes
        s2=subplot(3,2,3,'Parent',figure_ModelBuilder);
        cla %clear axes
        s3=subplot(3,2,5,'Parent',figure_ModelBuilder);
        cla %clear axes
        s4=subplot(3,2,2,'Parent',figure_ModelBuilder);
        cla %clear axes
        s5=subplot(3,2,4,'Parent',figure_ModelBuilder);
        cla %clear axes
        s6=subplot(3,2,6,'Parent',figure_ModelBuilder);
        cla %clear axes
        return;
    % else, draw the model
    else
        % display the GMR results for the GRAVITY and BODY ACC. features projected
        % over 3 2D domains (time + mono-axial acceleration)
        darkcolor = [0.8 0 0];
        lightcolor = [1 0.7 0.7];
        % gravity
        % time and gravity acceleration along x
        s1=subplot(3,2,1,'Parent',figure_ModelBuilder);
        cla %clear axes
        for i=1:1:numGMRPoints
            sigma = sqrtm(3.*gr_sigma(:,:,i));
            maximum(i) = gr_points(2,i) + sigma(1,1);
            minimum(i) = gr_points(2,i) - sigma(1,1);
        end
        patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
        hold on;
        plot(s1,gr_points(1,:),gr_points(2,:),'-','linewidth',3,'color',darkcolor);
        title ('gravity - x axis');
        % time and gravity acceleration along y
        s2=subplot(3,2,3,'Parent',figure_ModelBuilder);
        cla %clear axes
        for i=1:1:numGMRPoints
            sigma = sqrtm(3.*gr_sigma(:,:,i));
            maximum(i) = gr_points(3,i) + sigma(2,2);
            minimum(i) = gr_points(3,i) - sigma(2,2);
        end
        patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
        hold on;
        plot(s2,gr_points(1,:),gr_points(3,:),'-','linewidth',3,'color',darkcolor);
        title ('gravity - y axis');
        ylabel('acceleration [m/s^2]');
        % time and gravity acceleration along z
        s3=subplot(3,2,5,'Parent',figure_ModelBuilder);
        cla %clear axes
        for i=1:1:numGMRPoints
            sigma = sqrtm(3.*gr_sigma(:,:,i));
            maximum(i) = gr_points(4,i) + sigma(3,3);
            minimum(i) = gr_points(4,i) - sigma(3,3);
        end
        patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
        hold on;
        plot(s3,gr_points(1,:),gr_points(4,:),'-','linewidth',3,'color',darkcolor);
        title ('gravity - z axis');
        xlabel('time [samples]');
        % body
        % time and body acc. acceleration along x
        s4=subplot(3,2,2,'Parent',figure_ModelBuilder);
        cla %clear axes
        for i=1:1:numGMRPoints
            sigma = sqrtm(3.*b_sigma(:,:,i));
            maximum(i) = b_points(2,i) + sigma(1,1);
            minimum(i) = b_points(2,i) - sigma(1,1);
        end
        patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
        hold on;
        plot(s4,b_points(1,:),b_points(2,:),'-','linewidth',3,'color',darkcolor);
        title ('body - x axis');
        % time and body acc. acceleration along y
        s5=subplot(3,2,4,'Parent',figure_ModelBuilder);
        cla %clear axes
        for i=1:1:numGMRPoints
            sigma = sqrtm(3.*b_sigma(:,:,i));
            maximum(i) = b_points(3,i) + sigma(2,2);
            minimum(i) = b_points(3,i) - sigma(2,2);
        end
        patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
        hold on;
        plot(s5,b_points(1,:),b_points(3,:),'-','linewidth',3,'color',darkcolor);
        title ('body - y axis');
        % time and body acc. acceleration along z
        s6=subplot(3,2,6,'Parent',figure_ModelBuilder);
        cla %clear axes
        for i=1:1:numGMRPoints
            sigma = sqrtm(3.*b_sigma(:,:,i));
            maximum(i) = b_points(4,i) + sigma(3,3);
            minimum(i) = b_points(4,i) - sigma(3,3);
        end
        patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
        hold on;
        plot(s6,b_points(1,:),b_points(4,:),'-','linewidth',3,'color',darkcolor);
        title ('body - z axis');
        xlabel('time [samples]');
    end
end

% callback of pushbutton "Select trial"
function callback_SelTrial(source,eventdata)
    [TrialFileName,TrialPathName] = uigetfile('*.txt','Select validation trial');
end

% callback of pushbutton "View"
function callback_View(source,eventdata)
    % READ THE ACCELEROMETER DATA FILE
    trial = [TrialPathName TrialFileName];
    dataFile = fopen(trial,'r');
    data = fscanf(dataFile,'%d\t%d\t%d\n',[3,inf]);

    % CONVERT THE ACCELEROMETER DATA INTO REAL ACCELERATION VALUES
    % mapping from [0..63] to [-14.709..+14.709]
    noisy_x = -14.709 + (data(1,:)/63)*(2*14.709);
    noisy_y = -14.709 + (data(2,:)/63)*(2*14.709);
    noisy_z = -14.709 + (data(3,:)/63)*(2*14.709);

    % REDUCE THE NOISE ON THE SIGNALS BY MEDIAN FILTERING
    n = 3;      % order of the median filter
    x = medfilt1(noisy_x,n);
    y = medfilt1(noisy_y,n);
    z = medfilt1(noisy_z,n);
    numSamples = length(x);

    % DISPLAY THE RESULTS
    time = 1:1:numSamples;
    s1 = subplot(3,1,1,'Parent',figure_Classifier);
    plot(s1,time,x,'-');
    axis([0 numSamples -14.709 +14.709]);
    title('Filtered accelerations along the x axis');
    s2 = subplot(3,1,2,'Parent',figure_Classifier);
    plot(s2,time,y,'-');
    axis([0 numSamples -14.709 +14.709]);
    ylabel('acceleration [m/s^2]');
    title('Filtered accelerations along the y axis');
    s3 = subplot(3,1,3,'Parent',figure_Classifier);
    plot(s3,time,z,'-');
    axis([0 numSamples -14.709 +14.709]);
    xlabel('time [samples]');
    title('Filtered accelerations along the z axis');
    
    fclose(dataFile);
end

% callback of pushbutton "Analyze"
function callback_Analyze(source,eventdata)
    % DEFINE THE VALIDATION PARAMETERS
    % compute the size of the sliding window
    % (size of the largest model + 64 samples)
    models_size = zeros(1,numModels);
    for m=1:1:numModels
        models_size(m) = size(models(m).bP,2)+64;
    end
    window_size = max(models_size);
    % create an array with the models thresholds
    thresholds = zeros(1,numModels);
    for m=1:1:numModels
        thresholds(m) = models(m).threshold;
    end
    % initialize the results arrays
    dist = zeros(1,numModels);
    possibilities = zeros(1,numModels);

    % ANALYZE THE VALIDATION TRIAL
    % transform the trial into a stream of samples
    trial = [TrialPathName TrialFileName];
    currentFile = fopen(trial,'r');
    currentData = fscanf(currentFile,'%d\t%d\t%d\n',[3,inf]);
    numSamples = length(currentData(1,:));
    % create the log file
    res_folder = 'Data\RESULTS\';
    resultFileName = [res_folder 'RES_' TrialFileName];
    % initialize the window of data to be used by the classifier
    window = zeros(window_size,3);
    numWritten = 0;
    for j=1:1:numSamples
        current_sample = currentData(:,j);
        % update the sliding window with the current sample
        [window numWritten] = CreateWindow(current_sample,window,window_size,numWritten);
        % analysis is meaningful only when we have enough samples
        if (numWritten >= window_size)
            % compute the acceleration components of the current window of samples
            [gravity body] = AnalyzeActualWindow(window,window_size);
            % compute the difference between the actual data and each model
            for m=1:1:numModels
                dist(m) = CompareWithModels(gravity(1:models_size(m)-64,:),body(1:models_size(m)-64,:),models(m).gP,models(m).gS,models(m).bP,models(m).bS);
            end
            % classify the current data
            possibilities(j,:) = Classify(dist,thresholds);
        else
            possibilities(j,:) = zeros(1,numModels);
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
    fclose(currentFile);
    % plot the possibilities curves for the models
    x = window_size:1:numSamples;
    s1 = subplot(1,1,1,'Parent',figure_Results);
    plot(s1,x,possibilities(window_size:end,:));
    h = legend(models(:).name,numModels);
    set(h,'Interpreter','none')
    clear possibilities;
end

% UTILITY FUNCTIONS

end