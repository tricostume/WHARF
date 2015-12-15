function [ processed_data ] = PreprocessData( folder )
%PreprocessData file loads the data received from the accelerometer and one
%by one on a graph. Then you have to pan the graphs as requried. After that
%you trim the data.
% left 1 right 2
% raw_data {trial,side}
    % READ THE ACCELEROMETER DATA FILES
    ub=1000; %buffer (assumed)
    raw_data=GetTrialsData(folder);
    numFiles = length(raw_data); 
    dataFiles = zeros(1,numFiles);
    x_set=[];
    y_set=[];
    z_set=[];
    i=1;

    data1l = raw_data{1,1};
    data1r = raw_data{1,2};
    %figure(1);
        x=1:size(data1l, 2);
        ax(1)=subplot(3,1,1);plot(x,data1l(2,:), x, data1r(2,:)); hold on;
        title('Check if this is your desired data');
        ax(2)=subplot(3,1,2);plot(x,data1l(3,:), x, data1r(3,:));
        ax(3)=subplot(3,1,3);plot(x,data1l(4,:), x, data1r(4,:));
        linkaxes(ax,'x');
        pause;

        x_set1=[x_set;[data1l(2,1:end),zeros(1,ub-size(data1l,2))]];
        x_set2=[x_set;[data1r(2,1:end),zeros(1,ub-size(data1r,2))]];
        y_set1=[y_set;[data1l(3,1:end),zeros(1,ub-size(data1l,2))]];
        y_set2=[y_set;[data1r(3,1:end),zeros(1,ub-size(data1r,2))]];
        z_set1=[z_set;[data1l(4,1:end),zeros(1,ub-size(data1l,2))]];
        z_set2=[z_set;[data1r(4,1:end),zeros(1,ub-size(data1r,2))]];
        close all;
    for i=2:1:numFiles
        datal = raw_data{i,1};
        datar = raw_data{i,2};
        
        %clf(figure(1)); 
        figure(2)=gcf;
        clf(figure(2))
        plot(x_set1(1,:)); 
        hold on;
        plot(x_set2(1,:));
        axi1 = figure(2).CurrentAxes;
       
        %ax(2)=subplot(3,1,2);plot(y_set(1,:));
        %ax(3)=subplot(3,1,3);plot(z_set(1,:));
        
        axi1_pos = axi1.Position; % position of first axes
        ax2 = axes('Position',axi1_pos,...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'Color','none');
        hold on;
        plot(ax2,datal(2,:),'g');
        plot(ax2,datar(2,:),'k');
        title('Pan until desired overlapping and pres ENTER')
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
            datal = [zeros(4,x_limits(1)) datal(1:end,1:end)]; 
            datar = [zeros(4,x_limits(1)) datar(1:end,1:end)];
        elseif x_limits(1) == 0
                x_limits(1)=1;
                datal = datal(1:end,ceil(x_limits(1)):end);
                datar = datar(1:end,ceil(x_limits(1)):end);
        else
       datal = datal(1:end,ceil(x_limits(1)):end); 
       datar = datar(1:end,ceil(x_limits(1)):end); 
        end
        x_set1=[x_set1;[datal(2,1:end),zeros(1,ub-size(datal,2))]];
        y_set1=[y_set1;[datal(3,1:end),zeros(1,ub-size(datal,2))]];
        z_set1=[z_set1;[datal(4,1:end),zeros(1,ub-size(datal,2))]];
        x_set2=[x_set2;[datar(2,1:end),zeros(1,ub-size(datar,2))]];
        y_set2=[y_set2;[datar(3,1:end),zeros(1,ub-size(datar,2))]];
        z_set2=[z_set2;[datar(4,1:end),zeros(1,ub-size(datar,2))]];
    end
    %
    for i=1:size(x_set1,1)
    subplot(3,1,1); hold on;
    plot(x_set1(i,:));
    plot(x_set2(i,:));
    subplot(3,1,2); hold on;
    plot(y_set1(i,:));
    plot(y_set2(i,:));
    subplot(3,1,3); hold on;
    plot(z_set1(i,:));
    plot(z_set2(i,:));
    end
    title('Choose cutting LEFT and RIGHT edges')
    [cutx,~] = ginput(2);
    x_set1 = x_set1(1:end,ceil(cutx(1)):ceil(cutx(2)));
    y_set1 = y_set1(1:end,ceil(cutx(1)):ceil(cutx(2)));
    z_set1 = z_set1(1:end,ceil(cutx(1)):ceil(cutx(2)));
    x_set2 = x_set2(1:end,ceil(cutx(1)):ceil(cutx(2)));
    y_set2 = y_set2(1:end,ceil(cutx(1)):ceil(cutx(2)));
    z_set2 = z_set2(1:end,ceil(cutx(1)):ceil(cutx(2)));
  
    processed_data.left.x = x_set1;
    processed_data.right.x = x_set2;
    processed_data.left.y = y_set1;
    processed_data.right.y = y_set2;
    processed_data.left.z = z_set1;
    processed_data.right.z = z_set2;
    processed_data.size = length(x_set1(:,1)); 
    
function myprecallback(obj,evd)
    disp('A pan is about to occur.');

%
function mypostcallback(obj,evd)
    newLim = xlim
    disp('callback')
%msgbox(sprintf('The new X-Limits are [%.2f,%.2f].',newLim));
%assignin('base', 'x_limits', newLim);
