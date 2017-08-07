function [ ] = plot_models( gr_points, gr_sigma, b_points, b_sigma,name )
% DISPLAY THE RESULTS
% Load models_and_thresholds.mat and call the function as
% plot_models(models(1).gP, models(1).gS, models(1).bP, models(1).bS, models(1).name)
set(0,'defaultfigurecolor',[1 1 1])
gravity = gr_points;
body = b_points;
numGMRPoints = size(body,2)
summand=3;
% display the GMR results for the GRAVITY and BODY ACC. features projected
% over 3 2D domains (time + mono-axial acceleration)
darkcolor = [0.8 0 0];
lightcolor = [1 0.7 0.7];
fig=figure,
    % gravity
    % time and gravity acceleration along x
    subplot(3,2,1);
    
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*gr_sigma(:,:,i));
        maximum(i) = gr_points(2,i) + sigma(1,1);
        minimum(i) = gr_points(2,i) - sigma(1,1);
    end
    patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(gr_points(1,:),gr_points(2,:),'-','linewidth',3,'color',darkcolor);
    axis([min(gravity(1,:)) max(gravity(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated gravity (D=2)');
    % time and gravity acceleration along y
    subplot(3,2,3);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*gr_sigma(:,:,i));
        maximum(i) = gr_points(3,i) + sigma(2,2);
        minimum(i) = gr_points(3,i) - sigma(2,2);
    end
    patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(gr_points(1,:),gr_points(3,:),'-','linewidth',3,'color',darkcolor);
    axis([min(gravity(1,:)) max(gravity(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated gravity (D=3)');
    ylabel('acceleration [m/s^2]');
    % time and gravity acceleration along z
    subplot(3,2,5);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*gr_sigma(:,:,i));
        maximum(i) = gr_points(4,i) + sigma(3,3);
        minimum(i) = gr_points(4,i) - sigma(3,3);
    end
    patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(gr_points(1,:),gr_points(4,:),'-','linewidth',3,'color',darkcolor);
    axis([min(gravity(1,:)) max(gravity(1,:)) min(minimum)-1 max(maximum)+1]);
    title ('Correlated gravity (D=4)');
    xlabel('time [samples]');
    % body
    % time and body acc. acceleration along x
    subplot(3,2,2);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*b_sigma(:,:,i));
        maximum(i) = b_points(2,i) + sigma(1,1);
        minimum(i) = b_points(2,i) - sigma(1,1);
    end
    patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(b_points(1,:),b_points(2,:),'-','linewidth',3,'color',darkcolor);
    axis([min(body(1,:)) max(body(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated body (D=2)');
    % time and body acc. acceleration along y
    subplot(3,2,4);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*b_sigma(:,:,i));
        maximum(i) = b_points(3,i) + sigma(2,2);
        minimum(i) = b_points(3,i) - sigma(2,2);
    end
    patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(b_points(1,:),b_points(3,:),'-','linewidth',3,'color',darkcolor);
    axis([min(body(1,:)) max(body(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated body (D=3)');
    % time and body acc. acceleration along z
    subplot(3,2,6);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*b_sigma(:,:,i));
        maximum(i) = b_points(4,i) + sigma(3,3);
        minimum(i) = b_points(4,i) - sigma(3,3);
    end
    patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(b_points(1,:),b_points(4,:),'-','linewidth',3,'color',darkcolor);
    axis([min(body(1,:)) max(body(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated body (D=4)');
    xlabel('time [samples]');
    res_folder = 'Data\K-GROUPS\TRAINING\SET_5\';
    graph_file_name = [res_folder 'GRAPH_' name '1'];
    print(fig, graph_file_name, '-dpng');
 %---------------------------------------------------------------------
 %---------------------------------------------------------------------
 % SECOND GRAPH
 
 fig2=figure,
    % gravity
    % time and gravity acceleration along x
    subplot(3,2,1);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*gr_sigma(:,:,i));
        maximum(i) = gr_points(5,i) + sigma(1,1);
        minimum(i) = gr_points(5,i) - sigma(1,1);
    end
    patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(gr_points(1,:),gr_points(5,:),'-','linewidth',3,'color',darkcolor);
    axis([min(gravity(1,:)) max(gravity(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated gravity (D=5)');
    % time and gravity acceleration along y
    subplot(3,2,3);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*gr_sigma(:,:,i));
        maximum(i) = gr_points(6,i) + sigma(2,2);
        minimum(i) = gr_points(6,i) - sigma(2,2);
    end
    patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(gr_points(1,:),gr_points(6,:),'-','linewidth',3,'color',darkcolor);
    axis([min(gravity(1,:)) max(gravity(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated gravity (D=6)');
    ylabel('acceleration [m/s^2]');
    % time and gravity acceleration along z
    subplot(3,2,5);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*gr_sigma(:,:,i));
        maximum(i) = gr_points(7,i) + sigma(3,3);
        minimum(i) = gr_points(7,i) - sigma(3,3);
    end
    patch([gr_points(1,1:end) gr_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(gr_points(1,:),gr_points(7,:),'-','linewidth',3,'color',darkcolor);
    axis([min(gravity(1,:)) max(gravity(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated gravity (D=7)');
    xlabel('time [samples]');
    % body
    % time and body acc. acceleration along x
    subplot(3,2,2);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*b_sigma(:,:,i));
        maximum(i) = b_points(5,i) + sigma(1,1);
        minimum(i) = b_points(5,i) - sigma(1,1);
    end
    patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(b_points(1,:),b_points(5,:),'-','linewidth',3,'color',darkcolor);
    axis([min(body(1,:)) max(body(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated body (D=5)');
    % time and body acc. acceleration along y
    subplot(3,2,4);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*b_sigma(:,:,i));
        maximum(i) = b_points(6,i) + sigma(2,2);
        minimum(i) = b_points(6,i) - sigma(2,2);
    end
    patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(b_points(1,:),b_points(6,:),'-','linewidth',3,'color',darkcolor);
    axis([min(body(1,:)) max(body(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated body (D=6)');
    % time and body acc. acceleration along z
    subplot(3,2,6);
    for i=1:1:numGMRPoints
        sigma = sqrtm(3.*b_sigma(:,:,i));
        maximum(i) = b_points(7,i) + sigma(3,3);
        minimum(i) = b_points(7,i) - sigma(3,3);
    end
    patch([b_points(1,1:end) b_points(1,end:-1:1)], [maximum(1:end) minimum(end:-1:1)], lightcolor);
    hold on;
    plot(b_points(1,:),b_points(7,:),'-','linewidth',3,'color',darkcolor);
    axis([min(body(1,:)) max(body(1,:)) min(minimum)-summand max(maximum)+summand]);
    title ('Correlated body (D=7)');
    xlabel('time [samples]');
    graph_file_name = [res_folder 'GRAPH_' name '2'];
    print(fig2, graph_file_name, '-dpng');
end