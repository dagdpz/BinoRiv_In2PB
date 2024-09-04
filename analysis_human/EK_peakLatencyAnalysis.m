% Author: Ege Kingir (ege.kingir@med.uni-goettingen.de)

% Plots / visualizations for between-task individual peak latency comparisons.

clear all;clc
resolution = 0.25; %time difference (s) between bin edges from which we derive the peak latency of perceptual switches in each subject


for task=1:4
    dataDir = ['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task' num2str(task) '\meanMedians'];
    dataFile = [dataDir '\individualHistogramPeaks_allChanges_resolution' num2str(resolution)];
    load(dataFile);
    allTasks_allPeaks{task,1} = taskApeaks;
    taskApeakArray = table2array(taskApeaks(:,1));
    allPeaks_pStats{task,1} = signrank(taskApeakArray,2.5,"tail","left");
    clear taskApeaks
end

task_1vs2 = signrank(allTasks_allPeaks{1, 1}.taskA_peakTime, allTasks_allPeaks{2, 1}.taskA_peakTime);
task_3vs2 = signrank(allTasks_allPeaks{3, 1}.taskA_peakTime, allTasks_allPeaks{2, 1}.taskA_peakTime);
task_4vs2 = signrank(allTasks_allPeaks{4, 1}.taskA_peakTime, allTasks_allPeaks{2, 1}.taskA_peakTime);

% subject 3 was automatically excluded from the paired tests above, but we also want to exclude that subject from the plots:
allTasks_allPeaks{1, 1}.taskA_peakTime(3) = nan;
allTasks_allPeaks{2, 1}.taskA_peakTime(3) = nan;
allTasks_allPeaks{3, 1}.taskA_peakTime(3) = nan;
allTasks_allPeaks{4, 1}.taskA_peakTime(3) = nan;

%% draw the between-task paired raincloud plots comparing the peak values of the individual histograms:

taskA_number=4;
taskB_number=2;

if taskA_number==1
    taskColor = [0.3 0.5 0.9];
elseif taskA_number==3
    taskColor = [0.7 0.4 0.7];
elseif taskA_number==4
    taskColor = [0.5 0.7 0.4];
end
taskColor2 = [0.8 0.4 0.4]; %color for task 2 figures
var1 = allTasks_allPeaks{taskA_number, 1}.taskA_peakTime;
var2 = allTasks_allPeaks{taskB_number, 1}.taskA_peakTime;
var12 = [{var1}; {var2}];

%check for normality of each sample
% h_n1 = kstest(var1);
% h_n2 = kstest(var2);

p = signrank(var1,var2);
figure

h1 = rm_raincloud(var12,taskColor,0,'ks',[],0.17);

h1.p{2,1}.FaceColor= taskColor2; %face color for the second patch
h1.s{2,1}.MarkerFaceColor= taskColor2; %marker taskColor for the second category
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = taskColor2;

yticklabels({['Task ' num2str(taskB_number)],['Task ' num2str(taskA_number)]}) %inverted because of the rm_raincloud function plot orientation!

% Also match individual data points
hold on
for i=1:size(var1,1)
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

% Plot three lines as your significance line
% 1
hold on
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{1,1}.YData) mean(h1.s{2,1}.YData)];
plot(Xv,Yv,"k-");
hold on
% 2
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.3 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{1,1}.YData) mean(h1.s{1,1}.YData)];
plot(Xv,Yv,"k-");
% 3
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.3 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{2,1}.YData) mean(h1.s{2,1}.YData)];
plot(Xv,Yv,"k-");

hold on
pF = round(p,3);
text(max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.7,(mean(h1.s{1,1}.YData)+mean(h1.s{2,1}.YData))/2,['p = ',num2str(pF)],"FontSize",36,"HorizontalAlignment","center",'FontWeight','bold');
xlim([-2 7])
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5])
set(gca,'FontSize',48)
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PSL Peak Points (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Task ' num2str(taskA_number) ' vs. Task ' num2str(taskB_number) ': Peak PSL Probability'])
hold off

fig_dir = 'S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\figures';
filename = [fig_dir '/combined_PSL_peaks_compare' 'Task_' num2str(taskA_number) '_vsTask_' num2str(taskB_number) '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combined_PSL_peaks_compare' 'Task_' num2str(taskA_number) '_vsTask_' num2str(taskB_number) '.png'];
saveas(gcf,filename)

