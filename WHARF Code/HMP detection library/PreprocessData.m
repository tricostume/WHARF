function [ processed_data ] = PreprocessData( folder )
%PreprocessData file loads the data received from the accelerometer and one
%by one on a graph. Then you have to pan the graphs as requried. After that
%you trim the data.
% left 1 right 2
% raw_data {trial,side}
    % Constants declaration.
    left_index = 1;
    right_index = 2;

    % Read the accelerometers data files and get longest trial size
    raw_data = GetTrialsData(folder);
    num_files = length(raw_data);
    [max_size, max_index] = max(cellfun('size', raw_data, 2));
    max_trial_size = max_size(1);

    % Get first data trial
    data1_left = raw_data{1, left_index};
    data1_right = raw_data{1, right_index};
    
    % Plot data from first trial
    close all
    x = 1:size(data1_left, 2);
    ax(1) = subplot(3,1,1);plot(x,data1_left(2,:), x, data1_right(2,:)); hold on;
    title('Check if this is your desired data');
    ax(2) = subplot(3,1,2);plot(x,data1_left(3,:), x, data1_right(3,:));
    ax(3) = subplot(3,1,3);plot(x,data1_left(4,:), x, data1_right(4,:));
    linkaxes(ax,'x');
    pause;
    close all;

    % Initialize sets that will hold data from all trials
    left_x_set = [[];[data1_left(2,1:end), zeros(1,max_trial_size - size(data1_left,2))]];
    right_x_set = [data1_right(2,1:end), zeros(1,max_trial_size - size(data1_right,2))];
    left_y_set = [data1_left(3,1:end), zeros(1,max_trial_size - size(data1_left,2))];
    right_y_set = [data1_right(3,1:end), zeros(1,max_trial_size - size(data1_right,2))];
    left_z_set = [data1_left(4,1:end), zeros(1,max_trial_size - size(data1_left,2))];
    right_z_set = [data1_right(4,1:end), zeros(1,max_trial_size - size(data1_right,2))];
    
    % Loop through each trial
    for i = 2:1:num_files
        % Get next data trial
        data_left = raw_data{i,left_index};
        data_right = raw_data{i,right_index};
        
        % Plot initial trial data, other trials will be compared to this
        % one
        figure(2)=gcf;
        clf(figure(2))
        plot(left_x_set(1,:));
        hold on;
        plot(right_x_set(1,:));
        axis1 = figure(2).CurrentAxes;
        
        % Plot data of current trial with the initial
        axis_pos = axis1.Position; % position of first axes
        axis2 = axes('Position',axis_pos,...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'Color','none');
        hold on;
        plot(axis2, data_left(2,:), 'g');
        plot(axis2, data_right(2,:), 'k');
        % Allow axes panning and wait for user to synchronize data between
        % different trials
        title('Pan until desired overlapping and pres ENTER')
        xlim([0 max_trial_size])
        h=pan;
        h.ActionPreCallback = @myprecallback;
        h.ActionPostCallback = @mypostcallback;
        h.Motion = 'horizontal';
        h.Enable = 'on';
        pause;
        
        % Get data panning info
        x_limits = xlim;

        % Pan new data according to x_limits
        if x_limits(1) < 0
            x_limits(1) = abs(floor(x_limits(1)));
            data_left = [zeros(4,x_limits(1)) data_left(1:end,1:end)];
            data_right = [zeros(4,x_limits(1)) data_right(1:end,1:end)];
        elseif x_limits(1) == 0
            x_limits(1) = 1;
            data_left = data_left(1:end,ceil(x_limits(1)):end);
            data_right = data_right(1:end,ceil(x_limits(1)):end);
        else
            data_left = data_left(1:end,ceil(x_limits(1)):end);
            data_right = data_right(1:end,ceil(x_limits(1)):end);
        end
        
        % Add new trial panned data to set
        left_x_set = [left_x_set; [data_left(2,1:end), zeros(1,max_trial_size-size(data_left,2))]];
        left_y_set = [left_y_set; [data_left(3,1:end), zeros(1,max_trial_size-size(data_left,2))]];
        left_z_set = [left_z_set; [data_left(4,1:end), zeros(1,max_trial_size-size(data_left,2))]];
        right_x_set = [right_x_set; [data_right(2,1:end), zeros(1,max_trial_size-size(data_right,2))]];
        right_y_set = [right_y_set; [data_right(3,1:end), zeros(1,max_trial_size-size(data_right,2))]];
        right_z_set = [right_z_set; [data_right(4,1:end), zeros(1,max_trial_size-size(data_right,2))]];
    end
    
    % Plot all panned trials' data together
    for i=1:size(left_x_set,1)
        subplot(3,1,1); hold on;
        plot(left_x_set(i,:));
        plot(right_x_set(i,:));
        subplot(3,1,2); hold on;
        plot(left_y_set(i,:));
        plot(right_y_set(i,:));
        subplot(3,1,3); hold on;
        plot(left_z_set(i,:));
        plot(right_z_set(i,:));
    end
    % Cut data on the left and right based on user input
    title('Choose cutting LEFT and RIGHT edges')
    [cutx,~] = ginput(2);
    left_x_set = left_x_set(1:end,ceil(cutx(1)):ceil(cutx(2)));
    left_y_set = left_y_set(1:end,ceil(cutx(1)):ceil(cutx(2)));
    left_z_set = left_z_set(1:end,ceil(cutx(1)):ceil(cutx(2)));
    right_x_set = right_x_set(1:end,ceil(cutx(1)):ceil(cutx(2)));
    right_y_set = right_y_set(1:end,ceil(cutx(1)):ceil(cutx(2)));
    right_z_set = right_z_set(1:end,ceil(cutx(1)):ceil(cutx(2)));
  
    % Return cut data
    processed_data.left.x = left_x_set;
    processed_data.right.x = right_x_set;
    processed_data.left.y = left_y_set;
    processed_data.right.y = right_y_set;
    processed_data.left.z = left_z_set;
    processed_data.right.z = right_z_set;
    processed_data.size = length(left_x_set(1,:)); 
    
function myprecallback(obj,evd)
    disp('A pan is about to occur.');

%
function mypostcallback(obj,evd)
    newLim = xlim
    disp('callback')
%msgbox(sprintf('The new X-Limits are [%.2f,%.2f].',newLim));
%assignin('base', 'x_limits', newLim);
