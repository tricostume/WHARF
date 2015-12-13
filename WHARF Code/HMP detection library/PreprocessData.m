function [ numSamples x_set y_set z_set ] = PreprocessData( folder )
%PreprocessData file loads the data received from the accelerometer and one
%by one on a graph. Then you have to pan the graphs as requried. After that
%you trim the data.

    % READ THE ACCELEROMETER DATA FILES
    ub=1000; %buffer (assumed)
    files = dir([folder,'*.txt']);
    numFiles = length(files);
    dataFiles = zeros(1,numFiles);
    x_set=[];
    y_set=[];
    z_set=[];
    i=1;

    dataFiles(i) = fopen([folder files(i).name],'r');
    data1 = fscanf(dataFiles(i),'a;%ld;%f;%f;%f\n',[4,inf]);
    %figure(1);
        ax(1)=subplot(3,1,1);plot(data1(2,:)); hold on;
        title('Select left and right cuts');
        ax(2)=subplot(3,1,2);plot(data1(3,:));
        ax(3)=subplot(3,1,3);plot(data1(4,:));
        linkaxes(ax,'x');
        pause;
        cutx=[4 size(data1,2)-4];
    %[cutx,~] = ginput(2);
       data1 = data1(1:end,ceil(cutx(1)):ceil(cutx(2))); 
        x_set=[x_set;[data1(2,1:end),zeros(1,ub-size(data1,2))]];
        y_set=[y_set;[data1(3,1:end),zeros(1,ub-size(data1,2))]];
        z_set=[z_set;[data1(4,1:end),zeros(1,ub-size(data1,2))]];
        close all;
    for i=2:1:numFiles
        dataFiles(i) = fopen([folder files(i).name],'r');
        data = fscanf(dataFiles(i),'a;%ld;%f;%f;%f\n',[4,inf]);

        disp('Choose cutting edges (first left, then right)...');
        %clf(figure(1)); 
        figure(2)=gcf;
        clf(figure(2))
        plot(x_set(1,:));
        title('Select left and right cuts');
        %ax(2)=subplot(3,1,2);plot(y_set(1,:));
        %ax(3)=subplot(3,1,3);plot(z_set(1,:));

        axi1 = figure(2).CurrentAxes;
        axi1_pos = axi1.Position; % position of first axes
        ax2 = axes('Position',axi1_pos,...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'Color','none');
        hold on;
        plot(ax2,data(2,:),'r'); 
        xlim([0 1000])
        h=pan;
        h.ActionPreCallback = @myprecallback;
        h.ActionPostCallback = @mypostcallback;
        h.Motion = 'horizontal';
        h.Enable = 'on';

        pause;
        x_limits = xlim;

        if x_limits(1) < 0
            x_limits(1) = abs(floor(x_limits(1)));
            data = [zeros(4,x_limits(1)) data(1:end,1:end)]; 
        elseif x_limits(1) == 0
                x_limits(1)=1;
                data = data(1:end,ceil(x_limits(1)):end);
        else
       data = data(1:end,ceil(x_limits(1)):end); 
        end
        x_set=[x_set;[data(2,1:end),zeros(1,ub-size(data,2))]];
        y_set=[y_set;[data(3,1:end),zeros(1,ub-size(data,2))]];
        z_set=[z_set;[data(4,1:end),zeros(1,ub-size(data,2))]];
    end
    %
    for i=1:size(x_set,1)
    subplot(3,1,1); hold on;
    plot(x_set(i,:));
    subplot(3,1,2); hold on;
    plot(y_set(i,:));
    subplot(3,1,3); hold on;
    plot(z_set(i,:));
    end
    [cutx,~] = ginput(1);
    x_set = x_set(1:end,1:cutx);
    y_set = y_set(1:end,1:cutx);
    z_set = z_set(1:end,1:cutx);
    numSamples = length(x_set(:,1));
    
function myprecallback(obj,evd)
    disp('A pan is about to occur.');

%
function mypostcallback(obj,evd)
    newLim = xlim
    disp('callback')
%msgbox(sprintf('The new X-Limits are [%.2f,%.2f].',newLim));
%assignin('base', 'x_limits', newLim);
