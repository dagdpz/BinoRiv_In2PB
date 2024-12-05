% Author: Ryo Segawa (whizznihil.kid@gmail.com)
% Contributor: Ege Kingir (ege.kingir@med.uni-goettingen.de)

%% CONTENT %%
%%% 1) Performs the statistical tests to compare median PSLs and peak PSL probabilities across tasks.
%%% 2) Graphs the outputs of these tests.

%% prep

clear all
close all

trial_count = 8;
fig_dir = ['figures'];
mkdir(fig_dir)

subj_num_medians = 0;
table_count_switchEffect = 0;
table_count_FPjEffect = 0;
table_count_SacEffect = 0;
table_count_interaction = 0;

data_dir_task1 = dir('S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task1');
data_dir_task1 = data_dir_task1(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir_task1.name})); % avoid '.' and '..'

%% Load the required median data (binoriv and phys): loads both the "completed" perceptual switch data, and "combined" changes in perception!
% ALSO loads the peak points on the PSL histograms from each individual in each task.

% Load Task 1 meanMedians
medianDir = 'S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task1\meanMedians';
cd(medianDir);
load('meanMedians_trueSwitch');
binoriv_timingsTrue_task1 = taskAsummary.taskA_binoriv_rel_medians;
phys_timingsTrue_task1 = taskAsummary.taskA_phys_rel_medians;
clear taskAsummary
load('meanMedians_allChanges');
binoriv_timingsAll_task1 = taskAsummary.taskA_binoriv_rel_medians;
binoriv_timingsAllFirst_task1 = taskAsummary.taskA_binoriv_first_medians;
% phys_timingsAll_task1 = taskAsummary.taskA_phys_rel_medians;
clear taskAsummary
load('individualHistogramPeaks_allChanges_resolution0.25');
peakTimes_task1 = taskApeaks.taskA_peakTime;
clear taskApeaks allSubj_x allSubj_f resolution

% Load Task 2 meanMedians
medianDir = 'S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task2\meanMedians';
cd(medianDir);
load('meanMedians_trueSwitch.mat');
binoriv_timingsTrue_task2 = taskAsummary.taskA_binoriv_rel_medians;
phys_timingsTrue_task2 = taskAsummary.taskA_phys_rel_medians;
clear taskAsummary
load('meanMedians_allChanges');
binoriv_timingsAll_task2 = taskAsummary.taskA_binoriv_rel_medians;
binoriv_timingsAllFirst_task2 = taskAsummary.taskA_binoriv_first_medians;
% phys_timingsAll_task2 = taskAsummary.taskA_phys_rel_medians;
clear taskAsummary
load('individualHistogramPeaks_allChanges_resolution0.25');
peakTimes_task2 = taskApeaks.taskA_peakTime;
clear taskApeaks allSubj_x allSubj_f resolution

% Load Task 3 meanMedians
medianDir = 'S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task3\meanMedians';
cd(medianDir);
load('meanMedians_trueSwitch');
binoriv_timingsTrue_task3 = taskAsummary.taskA_binoriv_rel_medians;
phys_timingsTrue_task3 = taskAsummary.taskA_phys_rel_medians;
clear taskAsummary
load('meanMedians_allChanges');
binoriv_timingsAll_task3 = taskAsummary.taskA_binoriv_rel_medians;
binoriv_timingsAllFirst_task3 = taskAsummary.taskA_binoriv_first_medians;
% phys_timingsAll_task3 = taskAsummary.taskA_phys_rel_medians;
clear taskAsummary
load('individualHistogramPeaks_allChanges_resolution0.25');
peakTimes_task3 = taskApeaks.taskA_peakTime;
clear taskApeaks allSubj_x allSubj_f resolution

% Load Task 4 meanMedians
medianDir = 'S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task4\meanMedians';
cd(medianDir);
load('meanMedians_trueSwitch');
binoriv_timingsTrue_task4 = taskAsummary.taskA_binoriv_rel_medians;
phys_timingsTrue_task4 = taskAsummary.taskA_phys_rel_medians;
clear taskAsummary
load('meanMedians_allChanges');
binoriv_timingsAll_task4 = taskAsummary.taskA_binoriv_rel_medians;
binoriv_timingsAllFirst_task4 = taskAsummary.taskA_binoriv_first_medians;
% phys_timingsAll_task4 = taskAsummary.taskA_phys_rel_medians;
clear taskAsummary
load('individualHistogramPeaks_allChanges_resolution0.25');
peakTimes_task4 = taskApeaks.taskA_peakTime;
clear taskApeaks allSubj_x allSubj_f resolution


for subj = 1:numel(data_dir_task1)

    
    %% data store
    subj_num_medians = subj_num_medians + 1;

    % Switch effect
    table_count_switchEffect = table_count_switchEffect + 1;
    preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task1(subj),'PCT_rel_comb',binoriv_timingsAll_task1(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task1(subj),'PCT_peakComb',peakTimes_task1(subj)); % PCT: Percept Changed Timing
%     table_count_switchEffect = table_count_switchEffect + 1;
%     preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task1(subj)); % PCT: Percept Changed Timing
    table_count_switchEffect = table_count_switchEffect + 1;
    preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task2(subj),'PCT_rel_comb',binoriv_timingsAll_task2(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task2(subj),'PCT_peakComb',peakTimes_task2(subj)); 
%     table_count_switchEffect = table_count_switchEffect + 1;
%     preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task2(subj)); 

    % FPj effect
    table_count_FPjEffect = table_count_FPjEffect + 1;
    preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task3(subj),'PCT_rel_comb',binoriv_timingsAll_task3(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task3(subj),'PCT_peakComb',peakTimes_task3(subj)); 
%     table_count_FPjEffect = table_count_FPjEffect + 1;
%     preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task3(subj));
    table_count_FPjEffect = table_count_FPjEffect + 1;
    preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task2(subj),'PCT_rel_comb',binoriv_timingsAll_task2(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task2(subj),'PCT_peakComb',peakTimes_task2(subj));
%     table_count_FPjEffect = table_count_FPjEffect + 1;
%     preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task2(subj));
    
    
    % Saccade effect
    table_count_SacEffect = table_count_SacEffect + 1;
    preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task4(subj),'PCT_rel_comb',binoriv_timingsAll_task4(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task4(subj),'PCT_peakComb',peakTimes_task4(subj));
%     table_count_SacEffect = table_count_SacEffect + 1;
%     preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task4(subj));
    table_count_SacEffect = table_count_SacEffect + 1;
    preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task2(subj),'PCT_rel_comb',binoriv_timingsAll_task2(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task2(subj),'PCT_peakComb',peakTimes_task2(subj));
%     table_count_SacEffect = table_count_SacEffect + 1;
%     preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task2(subj));
    
    
    % Interaction
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task1(subj),'PCT_rel_comb',binoriv_timingsAll_task1(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task1(subj),'PCT_peakComb',peakTimes_task1(subj)); 
%     table_count_interaction = table_count_interaction + 1;
%     preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task1(subj));
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task2(subj),'PCT_rel_comb',binoriv_timingsAll_task2(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task2(subj),'PCT_peakComb',peakTimes_task2(subj));
%     table_count_interaction = table_count_interaction + 1;
%     preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task2(subj));
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task3(subj),'PCT_rel_comb',binoriv_timingsAll_task3(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task3(subj),'PCT_peakComb',peakTimes_task3(subj)); 
%     table_count_interaction = table_count_interaction + 1;
%     preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task3(subj));
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
        'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'Condition', 0,'PCT_rel_true', binoriv_timingsTrue_task4(subj),'PCT_rel_comb',binoriv_timingsAll_task4(subj),...
        'PCT_first_comb',binoriv_timingsAllFirst_task4(subj),'PCT_peakComb',peakTimes_task4(subj));
%     table_count_interaction = table_count_interaction + 1;
%     preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num_medians,...
%         'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'Condition', 1,'PCT_rel_true', phys_timingsTrue_task4(subj));
            
end


%% Two-way repeated-measures ANOVA
% data cleaning
preprocessedData_interaction_table=struct2table(preprocessedData_interaction);
preprocessedData_interaction_table.WithSaccade = categorical(preprocessedData_interaction_table.WithSaccade);
preprocessedData_interaction_table.WithFPj = categorical(preprocessedData_interaction_table.WithFPj);
preprocessedData_interaction_table.Task = categorical(preprocessedData_interaction_table.Task);
preprocessedData_interaction_table.SubjectID = categorical(preprocessedData_interaction_table.SubjectID);
% preprocessedData_interaction_table.PCT_ins_median = double(preprocessedData_interaction_table.PCT_ins_median);
preprocessedData_interaction_table.PCT_rel_true = double(preprocessedData_interaction_table.PCT_rel_true);
preprocessedData_interaction_table.PCT_rel_comb = double(preprocessedData_interaction_table.PCT_rel_comb);
preprocessedData_interaction_table.PCT_first_comb = double(preprocessedData_interaction_table.PCT_first_comb);
preprocessedData_interaction_table.PCT_peakComb = double(preprocessedData_interaction_table.PCT_peakComb);

% % rowsToRemove = strcmp(preprocessedData_interaction_table.Individual, 'Annalena') & preprocessedData_interaction_table.Task==1;
preprocessedData_interaction_table(preprocessedData_interaction_table.SubjectID=="3",:) = [];
% preprocessedData_interaction_table(preprocessedData_interaction_table.Condition==1,:) = [];


%% Non-Parametric Friedman's test (NP counterpart of two-way rm anova) to evaluate the main effects of performing a saccade and presence of fixation point jumps separately on perceptual switch timings:
addpath S:\KNEU\KNEUR-Projects\Projects\Sukanya-Backup\ViolinPlot\dabarplot
cd('S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\figures');

%%% TRUE perceptual switches:
% Friedman's Non-Parametric Test: Arrange for the Column Effect of Saccades
table2testSacT = [[binoriv_timingsTrue_task2(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsTrue_task3(~isnan(binoriv_timingsTrue_task2))] [binoriv_timingsTrue_task4(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsTrue_task1(~isnan(binoriv_timingsTrue_task2))]];
[pSacT, tblSacT, statsSacT] = friedman(table2testSacT,17);

% Friedman's Non-Parametric Test: Arrange for the Column Effect of Fixation Point Jumps
table2testFPjT = [[binoriv_timingsTrue_task2(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsTrue_task4(~isnan(binoriv_timingsTrue_task2))] [binoriv_timingsTrue_task3(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsTrue_task1(~isnan(binoriv_timingsTrue_task2))]];
[pFPjT, tblFPjT, statsFPjT] = friedman(table2testFPjT,17);

%%%% Figures for saccade and FPj effects: TRUE switches %%%%
%%% Raincloud to compare saccade to no-saccade [TRUE]
addpath S:\KNEU\KNEUR-Projects\Projects\Sukanya-Backup\ViolinPlot\raincloudPlots

var1=table2testSacT(:,1); %no-saccade
var2=table2testSacT(:,2); %saccade

var12 = [{var1}; {var2}];


figure
colors = [0.6 0 0];
h1 = rm_raincloud(var12,colors,0,'ks',[],0.5);

h1.p{2,1}.FaceColor=[0 0 0.6]; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=[0 0 0.6]; %marker colors for the second category (Misses)
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = [0 0 0.6];
yticklabels({'Saccade','NO Saccade'}) %inverted because of the rm_raincloud function plot orientation!
hold on

for i=1:size(var12{1, 1},1) % Also match individual data points
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

xlim([-0.5 4.3])
xticks([0.5 1 1.5 2 2.5 3 3.5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PCT Medians (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Effect of Saccades on Completed PSTs'])
hold off
filename = ['saccadesTrueSwitch_PSTs_raincloud.fig'];
saveas(gcf,filename)
filename = ['saccadesTrueSwitch_PSTs_raincloud.tiff'];
saveas(gcf,filename)
close;

%%% Raincloud to compare FPj to no FPj [TRUE]
var1=table2testFPjT(:,1); %no-FPj
var2=table2testFPjT(:,2); %FPj

var12 = [{var1}; {var2}];


figure
colors = [0.6 0 0];
h1 = rm_raincloud(var12,colors,0,'ks',[],0.5);

h1.p{2,1}.FaceColor=[0 0 0.6]; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=[0 0 0.6]; %marker colors for the second category (Misses)
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = [0 0 0.6];
yticklabels({'FPj','NO FPj'}) %inverted because of the rm_raincloud function plot orientation!
hold on

for i=1:size(var12{1, 1},1) % Also match individual data points
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

xlim([-0.5 4.3])
xticks([0.5 1 1.5 2 2.5 3 3.5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PCT Medians (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Effect of Fixation Point Jumps on Completed PSTs'])
hold off
filename = ['fpjTrueSwitch_PSTs_raincloud.fig'];
saveas(gcf,filename)
filename = ['fpjTrueSwitch_PSTs_raincloud.tiff'];
saveas(gcf,filename)
close;


%%% COMBINED (ALL) perceptual changes:
% Friedman's Non-Parametric Test: Arrange for the Column Effect of Saccades
table2testSacA = [[binoriv_timingsAll_task2(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsAll_task3(~isnan(binoriv_timingsTrue_task2))]...
    [binoriv_timingsAll_task4(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsAll_task1(~isnan(binoriv_timingsTrue_task2))]];
[pSacA, tblSacA, statsSacA] = friedman(table2testSacA,17);


% Friedman's Non-Parametric Test: Arrange for the Column Effect of Fixation Point Jumps
table2testFPjA = [[binoriv_timingsAll_task2(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsAll_task4(~isnan(binoriv_timingsTrue_task2))] ...
    [binoriv_timingsAll_task3(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsAll_task1(~isnan(binoriv_timingsTrue_task2))]];
[pFPjA, tblFPjA, statsFPjA] = friedman(table2testFPjA,17);

%%%% Figures for saccade and FPj effects: COMBINED switches %%%%
%%% Raincloud to compare saccade to no-saccade [COMBINED]

var1=table2testSacA(:,1); %no-saccade
var2=table2testSacA(:,2); %saccade

var12 = [{var1}; {var2}];


figure
colors = [0.6 0 0];
h1 = rm_raincloud(var12,colors,0,'ks',[],0.5);

h1.p{2,1}.FaceColor=[0 0 0.6]; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=[0 0 0.6]; %marker colors for the second category (Misses)
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = [0 0 0.6];
yticklabels({'Saccade','NO Saccade'}) %inverted because of the rm_raincloud function plot orientation!
hold on

for i=1:size(var12{1, 1},1) % Also match individual data points
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

xlim([-0.5 4.3])
xticks([0.5 1 1.5 2 2.5 3 3.5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PSL Medians (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Effect of Saccades on Combined PSLs'])
hold off
filename = ['saccadesCombinedSwitch_PSLs_raincloud.fig'];
saveas(gcf,filename)
filename = ['saccadesCombinedSwitch_PSLs_raincloud.tiff'];
saveas(gcf,filename)
close;

%%% Raincloud to compare FPj to no FPj [COMBINED]
var1=table2testFPjA(:,1); %no-FPj
var2=table2testFPjA(:,2); %FPj

var12 = [{var1}; {var2}];


figure
colors = [0.6 0 0];
h1 = rm_raincloud(var12,colors,0,'ks',[],0.5);

h1.p{2,1}.FaceColor=[0 0 0.6]; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=[0 0 0.6]; %marker colors for the second category (Misses)
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = [0 0 0.6];
yticklabels({'FPj','NO FPj'}) %inverted because of the rm_raincloud function plot orientation!
hold on

for i=1:size(var12{1, 1},1) % Also match individual data points
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

xlim([-0.5 4.3])
xticks([0.5 1 1.5 2 2.5 3 3.5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PSL Medians (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Effect of FPj on Combined PSTs'])
hold off
filename = ['fpjCombinedSwitch_PSTs_raincloud.fig'];
saveas(gcf,filename)
filename = ['fpjCombinedSwitch_PSTs_raincloud.tiff'];
saveas(gcf,filename)
close;

%%% COMBINED and FIRST perceptual switches
% Friedman's Non-Parametric Test: Arrange for the Column Effect of Saccades
table2testSacAF = [[binoriv_timingsAllFirst_task2(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsAllFirst_task3(~isnan(binoriv_timingsTrue_task2))] ...
    [binoriv_timingsAllFirst_task4(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsAllFirst_task1(~isnan(binoriv_timingsTrue_task2))]];
[pSacAF, tblSacAF, statsSacAF] = friedman(table2testSacAF,17);


% Friedman's Non-Parametric Test: Arrange for the Column Effect of Fixation Point Jumps
table2testFPjAF = [[binoriv_timingsAllFirst_task2(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsAllFirst_task4(~isnan(binoriv_timingsTrue_task2))] ...
    [binoriv_timingsAllFirst_task3(~isnan(binoriv_timingsTrue_task2)); binoriv_timingsAllFirst_task1(~isnan(binoriv_timingsTrue_task2))]];
[pFPjAF, tblFPjAF, statsFPjAF] = friedman(table2testFPjAF,17);

%%%% Figures for saccade and FPj effects: COMBINED and FIRST switches %%%%
%%% Raincloud to compare saccade to no-saccade [COMBINED FIRST]

var1=table2testSacAF(:,1); %no-saccade
var2=table2testSacAF(:,2); %saccade

var12 = [{var1}; {var2}];


figure
colors = [0 0 0];
h1 = rm_raincloud(var12,colors,0,'ks',[],0.5);

h1.p{2,1}.FaceColor=[0.5 0.5 0.5]; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=[0.5 0.5 0.5]; %marker colors for the second category (Misses)
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = [0.5 0.5 0.5];
yticklabels({'Saccade','NO Saccade'}) %inverted because of the rm_raincloud function plot orientation!
hold on

for i=1:size(var12{1, 1},1) % Also match individual data points
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

xlim([-0.5 4.3])
xticks([0.5 1 1.5 2 2.5 3 3.5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PSL Medians (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Effect of Saccades on First PSLs'])
hold off
filename = ['saccadesCombinedFirstSwitch_PSLs_raincloud.fig'];
saveas(gcf,filename)
filename = ['saccadesCombinedFirstSwitch_PSLs_raincloud.tiff'];
saveas(gcf,filename)
close;

%%% Raincloud to compare FPj to no FPj [COMBINED FIRST]
var1=table2testFPjAF(:,1); %no-FPj
var2=table2testFPjAF(:,2); %FPj

var12 = [{var1}; {var2}];


figure
colors = [0 0 0];
h1 = rm_raincloud(var12,colors,0,'ks',[],0.5);

h1.p{2,1}.FaceColor=[0.5 0.5 0.5]; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=[0.5 0.5 0.5]; %marker colors for the second category (Misses)
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = [0.5 0.5 0.5];
yticklabels({'FPj','NO FPj'}) %inverted because of the rm_raincloud function plot orientation!
hold on

for i=1:size(var12{1, 1},1) % Also match individual data points
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

xlim([-0.5 4.3])
xticks([0.5 1 1.5 2 2.5 3 3.5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PSL Medians (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Effect of Shifting FPs on First PSLs'])
hold off
filename = ['fpjCombinedFirstSwitch_PSLs_raincloud.fig'];
saveas(gcf,filename)
filename = ['fpjCombinedFirstSwitch_PSTLs_raincloud.tiff'];
saveas(gcf,filename)
close;

%%% COMBINED perceptual switches: PEAK points in individual histograms

% Friedman's Non-Parametric Test: Arrange for the Column Effect of Saccades
table2testSacAP = [[peakTimes_task2(~isnan(binoriv_timingsTrue_task2)); peakTimes_task3(~isnan(binoriv_timingsTrue_task2))] ...
    [peakTimes_task4(~isnan(binoriv_timingsTrue_task2)); peakTimes_task1(~isnan(binoriv_timingsTrue_task2))]];
[pSacAP, tblSacAP, statsSacAP] = friedman(table2testSacAP,17);


% Friedman's Non-Parametric Test: Arrange for the Column Effect of Fixation Point Jumps
table2testFPjAP = [[peakTimes_task2(~isnan(binoriv_timingsTrue_task2)); peakTimes_task4(~isnan(binoriv_timingsTrue_task2))] ...
    [peakTimes_task3(~isnan(binoriv_timingsTrue_task2)); peakTimes_task1(~isnan(binoriv_timingsTrue_task2))]];
[pFPjAP, tblFPjAP, statsFPjAP] = friedman(table2testFPjAP,17);

%%% Raincloud to compare saccade to no-saccade [COMBINED PEAK]

var1=table2testSacAP(:,1); %no-saccade
var2=table2testSacAP(:,2); %saccade

var12 = [{var1}; {var2}];


figure
colors = [0 0 0];
h1 = rm_raincloud(var12,colors,0,'ks',[],0.1);

h1.p{2,1}.FaceColor=[0.5 0.5 0.5]; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=[0.5 0.5 0.5]; %marker colors for the second category (Misses)
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = [0.5 0.5 0.5];
yticklabels({'Saccade','NO Saccade'}) %inverted because of the rm_raincloud function plot orientation!
hold on

for i=1:size(var12{1, 1},1) % Also match individual data points
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

xlim([-1 6.5])
xticks([0 1 2 3 4 5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('Peak Latencies (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Effect of Saccades on Peak Latencies'])
hold off
filename = ['saccadesPeakLatency_PSLs_raincloud.fig'];
saveas(gcf,filename)
filename = ['saccadesPeakLatency_PSLs_raincloud.tiff'];
saveas(gcf,filename)
close;

%%% Raincloud to compare FPj to no FPj [COMBINED FIRST]
var1=table2testFPjAP(:,1); %no-FPj
var2=table2testFPjAP(:,2); %FPj

var12 = [{var1}; {var2}];


figure
colors = [0 0 0];
h1 = rm_raincloud(var12,colors,0,'ks',[],0.1);

h1.p{2,1}.FaceColor=[0.5 0.5 0.5]; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=[0.5 0.5 0.5]; %marker colors for the second category (Misses)
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = [0.5 0.5 0.5];
yticklabels({'FPj','NO FPj'}) %inverted because of the rm_raincloud function plot orientation!
hold on

for i=1:size(var12{1, 1},1) % Also match individual data points
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

xlim([-1 6.5])
xticks([0 1 2 3 4 5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('Peak Latencies (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Effect of Shifting FPs on Peak Latencies'])
hold off
filename = ['fpjPeakLatency_PSLs_raincloud.fig'];
saveas(gcf,filename)
filename = ['fpjPeakLatency_PSLs_raincloud.tiff'];
saveas(gcf,filename)
close;

%%%%%                                               %%%%%
%%%%% FOR ONE-WAY COMPARISONS ACROSS ALL FOUR TASKS %%%%%
%%%%%                                               %%%%%

%% TRUE SWITCHES table
table2plotTrue = [binoriv_timingsTrue_task1(~isnan(binoriv_timingsTrue_task2)) binoriv_timingsTrue_task2(~isnan(binoriv_timingsTrue_task2)) ...
    binoriv_timingsTrue_task3(~isnan(binoriv_timingsTrue_task2)) binoriv_timingsTrue_task4(~isnan(binoriv_timingsTrue_task2))];

% [h p] = adtest([table2plotTrue(:,1);table2plotTrue(:,2);table2plotTrue(:,3);table2plotTrue(:,4)]) %Anderson-Darling Test for normality of the data as a whole.
addpath S:\KNEU\KNEUR-Projects\Projects\Sukanya-Backup\ViolinPlot\raincloudPlots
table2plotAllTasksTrue = reshape(table2plotTrue,size(table2plotTrue,1)*size(table2plotTrue,2),1)
% Button Release
figure
raincloud_plot(table2plotAllTasksTrue,'box_on', 1,'color',[0.5 0.5 0.5]);
isoutlier(table2plotAllTasksTrue)
%% Non-Parametric One Way Friedman Across Tasks - TRUE switches

[pT_oneway tblT_oneway statsT_oneway] = friedman(table2plotTrue,1);

if pT_oneway < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cT,mT,hT,gnamesT] = multcompare(statsT_oneway);
end

% table_rmTrue = array2table(table2plotTrue,'VariableNames',{'Task1','Task2','Task3','Task4'});
% subjectIDs = (1:18)';
% subjectIDs(3) = [];
% table_rmTrue.subjects = subjectIDs;
% table_rmTrue = movevars(table_rmTrue, "subjects", "Before", "Task1");


% rmTrue = fitrm(table_rmTrue,'Task1-Task4 ~ 1', 'WithinDesign', [1 2 3 4]);
% ranovatblTrue = ranova(rmTrue);
% disp(ranovatblTrue);

% Bonferroni-corrected paired post-hoc tests to determine task pairs that differ significantly
% postHocTrue = multcompare(rmTrue, 'Time', 'ComparisonType', 'bonferroni');


%% COMBINED SWITCHES
table2plotComb = [binoriv_timingsAll_task1(~isnan(binoriv_timingsTrue_task2)) binoriv_timingsAll_task2(~isnan(binoriv_timingsTrue_task2)) ...
    binoriv_timingsAll_task3(~isnan(binoriv_timingsTrue_task2)) binoriv_timingsAll_task4(~isnan(binoriv_timingsTrue_task2))];
table2plotComb = double(table2plotComb);
% 
% [h p] = adtest([table2plotComb(:,1);table2plotComb(:,2);table2plotComb(:,3);table2plotComb(:,4)]) %Anderson-Darling Test for normality of the data as a whole.
% 
% table2plotAllTasksComb = reshape(table2plotComb,size(table2plotComb,1)*size(table2plotComb,2),1)
% % Button Release
% figure
% raincloud_plot(table2plotAllTasksComb,'box_on', 1,'color',[0.5 0.5 0.5]);
% isoutlier(table2plotAllTasksComb)

%% Non-Parametric One Way Friedman Across Tasks - COMBINED switches

[pA_oneway tblA_oneway statsA_oneway] = friedman(table2plotComb,1);

if pA_oneway < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cA,mA,hA,gnamesA] = multcompare(statsA_oneway);
end

%% COMBINED and FIRST SWITCHES
table2plotCombFirst = [binoriv_timingsAllFirst_task1(~isnan(binoriv_timingsTrue_task2)) binoriv_timingsAllFirst_task2(~isnan(binoriv_timingsTrue_task2)) ...
    binoriv_timingsAllFirst_task3(~isnan(binoriv_timingsTrue_task2)) binoriv_timingsAllFirst_task4(~isnan(binoriv_timingsTrue_task2))];
table2plotCombFirst = double(table2plotCombFirst);


%% Non-Parametric One Way Friedman Across Tasks - COMBINED FIRST switches
% Parametric Across Tasks True Switch Timing Comparisons
[pAF_oneway tblAF_oneway statsAF_oneway] = friedman(table2plotCombFirst,1);

if pAF_oneway < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cAF,mAF,hAF,gnamesAF] = multcompare(statsAF_oneway);
end

table_rmCombFirst = array2table(table2plotCombFirst,'VariableNames',{'Task1','Task2','Task3','Task4'});

%% COMBINED SWITCHES - PEAK times on Histograms
table2plotPeak = [peakTimes_task1(~isnan(binoriv_timingsTrue_task2)) peakTimes_task2(~isnan(binoriv_timingsTrue_task2)) ...
    peakTimes_task3(~isnan(binoriv_timingsTrue_task2)) peakTimes_task4(~isnan(binoriv_timingsTrue_task2))];

[pAP_oneway tblAP_oneway statsAP_oneway] = friedman(table2plotPeak,1);

if pAP_oneway < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cAP,mAP,hAP,gnamesAP] = multcompare(statsAP_oneway);
end

%% Bar Graph Plot for True Perceptual Switches

groupColors = [0.3 0.5 0.9; 0.8 0.4 0.4; 0.7 0.4 0.7; 0.5 0.7 0.4];
cell2plotTrue{1} = table2plotTrue(:,1);
cell2plotTrue{2} = table2plotTrue(:,2);
cell2plotTrue{3} = table2plotTrue(:,3);
cell2plotTrue{4} = table2plotTrue(:,4);
    
figure;
h = dabarplot(cell2plotTrue,'colors',groupColors,'scatter',1,'scattersize',100);
hold on
% for i=1:size(table2plotTrue,1) % Also match individual data points
%     X = [h.sc(1).XData(i) h.sc(2).XData(i) h.sc(3).XData(i) h.sc(4).XData(i)];
%     Y = [h.sc(1).YData(i) h.sc(2).YData(i) h.sc(3).YData(i) h.sc(4).YData(i)];
%     plot(X,Y,"k-");
% end
yline(2.5,'r--','LineWidth',1.5)
xticklabels({'Task 1','Task 2','Task 3','Task 4'})
ylim([0 5])
title('Median Perceptual Switch (Completed) Timing')
ylabel('(s)');
set(gca,'FontSize',48)
set(gcf, 'Position', get(0, 'Screensize'));
filename = ['medianTrueSwitch_PSTs_allTasksBarGraph.fig'];
saveas(gcf,filename)
filename = ['medianTrueSwitch_PSTs_allTasksBarGraph.tiff'];
saveas(gcf,filename)
close;

%% Bar Graph Plot for Combined Perceptual Switches
cell2plotComb{1} = table2plotComb(:,1);
cell2plotComb{2} = table2plotComb(:,2);
cell2plotComb{3} = table2plotComb(:,3);
cell2plotComb{4} = table2plotComb(:,4);

figure;
dabarplot(cell2plotComb,'colors',groupColors,'scatter',1,'scattersize',100)
hold on
yline(2.5,'r--','LineWidth',1.5)
xticklabels({'Task 1','Task 2','Task 3','Task 4'})
ylim([0 5])
title('Median Perceptual Switch (Combined) Timing')
ylabel('(s)');
set(gca,'FontSize',48)
set(gcf, 'Position', get(0, 'Screensize'));
filename = ['medianCombined_PSTs_allTasksBarGraph.fig'];
saveas(gcf,filename)
filename = ['medianCombined_PSTs_allTasksBarGraph.tiff'];
saveas(gcf,filename)
close;

%% Bar Graph for Combined FIRST Perceptual Switches
cell2plotCombFirst{1} = table2plotCombFirst(:,1);
cell2plotCombFirst{2} = table2plotCombFirst(:,2);
cell2plotCombFirst{3} = table2plotCombFirst(:,3);
cell2plotCombFirst{4} = table2plotCombFirst(:,4);

figure;
dabarplot(cell2plotCombFirst,'colors',groupColors,'scatter',1,'scattersize',100)
hold on
yline(2.5,'r--','LineWidth',1.5)
xticklabels({'Task 1','Task 2','Task 3','Task 4'})
ylim([0 5])
title('Median of First PSLs')
ylabel('(s)');
set(gca,'FontSize',48)
set(gcf, 'Position', get(0, 'Screensize'));
filename = ['medianCombinedFirst_PSLs_allTasksBarGraph.fig'];
saveas(gcf,filename)
filename = ['medianCombinedFirst_PSLs_allTasksBarGraph.tiff'];
saveas(gcf,filename)
close;

%% Bar Graph for PEAK points on histograms
cell2plotPeak{1} = table2plotPeak(:,1);
cell2plotPeak{2} = table2plotPeak(:,2);
cell2plotPeak{3} = table2plotPeak(:,3);
cell2plotPeak{4} = table2plotPeak(:,4);

figure;
dabarplot(cell2plotPeak,'colors',groupColors,'scatter',1,'scattersize',100)
hold on
yline(2.5,'r--','LineWidth',1.5)
xticklabels({'Task 1','Task 2','Task 3','Task 4'})
ylim([0 5])
title('Peak Latencies')
ylabel('(s)');
set(gca,'FontSize',48)
set(gcf, 'Position', get(0, 'Screensize'));
filename = ['peak_PSLs_allTasksBarGraph.fig'];
saveas(gcf,filename)
filename = ['peak_PSLs_allTasksBarGraph.tiff'];
saveas(gcf,filename)
close;

%% 
