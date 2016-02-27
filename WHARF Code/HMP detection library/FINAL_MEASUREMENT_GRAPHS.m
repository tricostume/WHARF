load('1454599282520A_Swp_2_Jessica_VAL.mat')
figure;
subplot(3,2,1); plot(single_trial_data{1,1}(2,:));
axis([0 2000 -25 15]);
title('Trial 1: Left hand. Acceleration x')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,3); plot(single_trial_data{1,1}(3,:));
axis([0 2000 -25 17]);
title('Trial 1: Left hand. Acceleration y')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,5); plot(single_trial_data{1,1}(4,:))
axis([0 2000 -17 20]);
title('Trial 1: Left hand. Acceleration z')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,2); plot(single_trial_data{1,2}(2,:))
axis([0 2000 -17 25]);
title('Trial 1: Right hand. Acceleration x')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,4); plot(single_trial_data{1,2}(3,:))
axis([0 2000 -20 20]);
title('Trial 1: Right hand. Acceleration y')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,6); plot(single_trial_data{1,2}(4,:))
axis([0 2000 -17 20]);
title('Trial 1: Right hand. Acceleration z')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
set(gcf, 'Color', [1,1,1]);
%%
load('1454596734380A_WO-RfF-FCoT-OCC_VAL_Massimiliano.mat')
figure;
subplot(3,2,1); plot(single_trial_data{1,1}(2,:));
%axis([0 2000 -25 15]);
title('Trial 1: Left hand. Acceleration x')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,3); plot(single_trial_data{1,1}(3,:));
%axis([0 2000 -25 17]);
title('Trial 1: Left hand. Acceleration y')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,5); plot(single_trial_data{1,1}(4,:))
%axis([0 2000 -17 20]);
title('Trial 1: Left hand. Acceleration z')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,2); plot(single_trial_data{1,2}(2,:))
%axis([0 2000 -17 25]);
title('Trial 1: Right hand. Acceleration x')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,4); plot(single_trial_data{1,2}(3,:))
%axis([0 2000 -20 20]);
title('Trial 1: Right hand. Acceleration y')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
subplot(3,2,6); plot(single_trial_data{1,2}(4,:))
%axis([0 2000 -17 20]);
title('Trial 1: Right hand. Acceleration z')
xlabel('Time sample []')
ylabel('Acceleration [m/s^2]')
set(gcf, 'Color', [1,1,1]);
%%

