% Author: Ege Kingir (ege.kingir@med.uni-goettingen.de)
% Statistical tests for across-task comparisons of perceptual switches within the first seconds of trials.

clear;clc;close all

%%
%%%% NOTES %%%%
% Subject 3 is excluded from the meanMedians files in the sense that all values from this subject should be NaN: I take care of this in the...
% ... "disturbances_truePercept" script.

for task=1:4
    data_dir = ['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task' num2str(task) '\meanMedians'];
    cd(data_dir)
    load("meanMedians_trueSwitch.mat")

    
    percent_disturb_inF1 = taskAsummary.percent_disturb_inF1;
    percent_disturb_inF1(isnan(percent_disturb_inF1)) = 0;
    percent_switch_inF1 = taskAsummary.percent_switches_inF1;
    percent_switch_inF1(isnan(percent_switch_inF1)) = 0;

    combinedSwitch_F1 = (percent_disturb_inF1.*taskAsummary.num_disturbedSwitch + taskAsummary.percent_switches_inF1.*taskAsummary.num_completedSwitch)./(taskAsummary.num_disturbedSwitch + taskAsummary.num_completedSwitch);
    
    allTasksSummary{task,1} = taskAsummary;
    disturbedSwitch_F1{:,task} = taskAsummary.percent_disturb_inF1;
    trueSwitch_F1{:,task} = taskAsummary.percent_switches_inF1;

    

    allTasksSummary{task,1}.percent_change_inF1 = combinedSwitch_F1;
    combinedSwitches_F1{:,task} = combinedSwitch_F1;

    trials_w_change_inF1 = taskAsummary.percentTrials_w_f1Change;
    percent_ofTrials_w_f1Change{:,task} = trials_w_change_inF1;

    trials_w_trueSwitch_inF1 = taskAsummary.percentTrials_w_f1TrueSwitch;
    percent_ofTrials_w_f1TrueSwitch{:,task} = trials_w_trueSwitch_inF1;

    diff_expected_combinedSwitchesF1(task,1) = signrank(combinedSwitch_F1,20,'tail','right');
    diff_expected_trueSwitchesF1(task,1) = signrank(taskAsummary.percent_switches_inF1,20,'tail','right');
      
    clear taskAsummary combinedSwitch_F1
end

%%
addpath S:\KNEU\KNEUR-Projects\Projects\Sukanya-Backup\ViolinPlot\dabarplot
cd('S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\figures');

groupColors = [0.3 0.5 0.9; 0.8 0.4 0.4; 0.7 0.4 0.7; 0.5 0.7 0.4];

%% Probability of Complete Switches Occurring in the First Second
trueSwitch_F1{1, 1}(isnan(trueSwitch_F1{1, 2})) = nan;
trueSwitch_F1{1, 3}(isnan(trueSwitch_F1{1, 2})) = nan;
trueSwitch_F1{1, 4}(isnan(trueSwitch_F1{1, 2})) = nan; %making the values from subject #3 all NaNs!

figure;
dabarplot(trueSwitch_F1,'colors',groupColors,'scatter',1,'scattersize',100)
hold on
yline(20,'r--','LineWidth',1.5)
xticklabels({'Task 1','Task 2','Task 3','Task 4'})
ylim([0 100])
title('Percentage of Completed Switches in the First Second')
ylabel('%');
set(gca,'FontSize',36)
set(gcf, 'Position', get(0, 'Screensize'));
filename = ['summary_CompleteSwitchRatio_inF1.fig'];
saveas(gcf,filename)
filename = ['summary_CompleteSwitchRatio_inF1.tiff'];
saveas(gcf,filename)
close;

trueTable = [trueSwitch_F1{1,1} trueSwitch_F1{1,2} trueSwitch_F1{1,3} trueSwitch_F1{1,4}];
rowToRemove = isnan(trueTable(:,1));

trueTable(rowToRemove,:) = [];
[pT_f1 tblT_f1 statsT_f1] = friedman(trueTable,1);

if pT_f1 < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cT,mT,hT,gnamesT] = multcompare(statsT_f1);
end

%% Probability of an Overall Change in Perception in the First Second
combinedSwitches_F1{1, 1}(isnan(combinedSwitches_F1{1, 2})) = nan;
combinedSwitches_F1{1, 3}(isnan(combinedSwitches_F1{1, 2})) = nan;
combinedSwitches_F1{1, 4}(isnan(combinedSwitches_F1{1, 2})) = nan; %making the values from subject #3 all NaNs!

figure;
dabarplot(combinedSwitches_F1,'colors',groupColors,'scatter',1,'scattersize',100)
hold on
yline(20,'r--','LineWidth',1.5)
xticklabels({'Task 1','Task 2','Task 3','Task 4'})
ylim([0 100])
title('Percentage of Changes in Perception in the First Second')
ylabel('%');
set(gca,'FontSize',36)
set(gcf, 'Position', get(0, 'Screensize'));
filename = ['summary_OverallChangeRatio_inF1.fig'];
saveas(gcf,filename)
filename = ['summary_OverallChangeRatio_inF1.tiff'];
saveas(gcf,filename)
close;

combinedTable = [combinedSwitches_F1{1,1} combinedSwitches_F1{1,2} combinedSwitches_F1{1,3} combinedSwitches_F1{1,4}];
rowToRemove = isnan(combinedTable(:,1));

combinedTable(rowToRemove,:) = [];
[pC_f1 tblC_f1 statsC_f1] = friedman(combinedTable,1);

if pC_f1 < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cC,mC,hC,gnamesC] = multcompare(statsC_f1);
end

%% Probability of a BR Trial Inducing a True (Completed) Perceptual Switch in the First Second
percent_ofTrials_w_f1TrueSwitch{1, 1}(isnan(percent_ofTrials_w_f1TrueSwitch{1, 2})) = nan;
percent_ofTrials_w_f1TrueSwitch{1, 3}(isnan(percent_ofTrials_w_f1TrueSwitch{1, 2})) = nan;
percent_ofTrials_w_f1TrueSwitch{1, 4}(isnan(percent_ofTrials_w_f1TrueSwitch{1, 2})) = nan; %making the values from subject #3 all NaNs!
figure;
dabarplot(percent_ofTrials_w_f1TrueSwitch,'colors',groupColors,'scatter',1,'scattersize',100);
xticklabels({'Task 1','Task 2','Task 3','Task 4'})
ylim([0 100])
title('% of Trials with a Completed Perceptual Switch in the First Second')
ylabel('%');
set(gca,'FontSize',36)
set(gcf, 'Position', get(0, 'Screensize'));
filename = ['summary_TrialsInducingTrueSwitch_inF1.fig'];
saveas(gcf,filename)
filename = ['summary_TrialsInducingTrueSwitch_inF1.tiff'];
saveas(gcf,filename)
close;

trialsTrue_wF1Table = [percent_ofTrials_w_f1TrueSwitch{1,1} percent_ofTrials_w_f1TrueSwitch{1,2} percent_ofTrials_w_f1TrueSwitch{1,3} percent_ofTrials_w_f1TrueSwitch{1,4}];
rowToRemove = isnan(trialsTrue_wF1Table(:,1));

trialsTrue_wF1Table(rowToRemove,:) = [];
[pTrT_f1 tblTrT_f1 statsTrT_f1] = friedman(trialsTrue_wF1Table,1);

if pTrT_f1 < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cTrT,mTrT,hTrT,gnamesTrT] = multcompare(statsTrT_f1);
end
%% Probability of a BR Trial Inducing a Change in Perception in the First Second
percent_ofTrials_w_f1Change{1, 1}(isnan(percent_ofTrials_w_f1Change{1, 2})) = nan;
percent_ofTrials_w_f1Change{1, 3}(isnan(percent_ofTrials_w_f1Change{1, 2})) = nan;
percent_ofTrials_w_f1Change{1, 4}(isnan(percent_ofTrials_w_f1Change{1, 2})) = nan; %making the values from subject #3 all NaNs!
figure;
dabarplot(percent_ofTrials_w_f1Change,'colors',groupColors,'scatter',1,'scattersize',100);
xticklabels({'Task 1','Task 2','Task 3','Task 4'})
ylim([0 100])
title('% of Trials with a Combined Perceptual Switch in the First Second')
ylabel('%');
set(gca,'FontSize',36)
set(gcf, 'Position', get(0, 'Screensize'));
filename = ['summary_TrialsInducingChange_inF1.fig'];
saveas(gcf,filename)
filename = ['summary_TrialsInducingChange_inF1.tiff'];
saveas(gcf,filename)
close;

trialsComb_wF1Table = [percent_ofTrials_w_f1Change{1,1} percent_ofTrials_w_f1Change{1,2} percent_ofTrials_w_f1Change{1,3} percent_ofTrials_w_f1Change{1,4}];
rowToRemove = isnan(trialsComb_wF1Table(:,1));

trialsComb_wF1Table(rowToRemove,:) = [];
[pTrC_f1 tblTrC_f1 statsTrC_f1] = friedman(trialsComb_wF1Table,1);

if pTrC_f1 < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cTrC,mTrC,hTrC,gnamesTrC] = multcompare(statsTrC_f1);
end

%% Comparison of the Number of Incomplete Switches Across Participants
numWeightedIncompSwitches = [allTasksTable.(1){1,1}.num_disturbedSwitch.* allTasksTable.(1){1,1}.num_bino...
    allTasksTable.(2){1,1}.num_disturbedSwitch .* allTasksTable.(2){1,1}.num_bino...
    allTasksTable.(3){1,1}.num_disturbedSwitch .* allTasksTable.(3){1,1}.num_bino...
    allTasksTable.(4){1,1}.num_disturbedSwitch .* allTasksTable.(4){1,1}.num_bino];

numWeightedIncompSwitches(rowToRemove,:) = [];
[pInc_f1 tblInc_f1 statsInc_f1] = friedman(numWeightedIncompSwitches,1);

if pInc_f1 < 0.05 %then go into the post-hoc test, using the stats output as the input for the multcompare function!
    [cIncC,mIncC,hIncC,gnamesIncC] = multcompare(statsInc_f1);
end

%%
%%%%%%%%%% Formulating the summary tables %%%%%%%%%%%%

%% Trial Info Table: #phys trials, success in phys trials, #BR trials, # of completed switches, # of incomplete switches (1,2,8,9,10)

allTasksTable = cell2table(allTasksSummary');
allTasksTable.Properties.VariableNames = {'Task 1','Task 2','Task 3','Task 4'};

tableTrialInfo = table(allTasksTable.(1){1,1}(:,[1,2,8,9,10]),allTasksTable.(2){1,1}(:,[1,2,8,9,10]),allTasksTable.(3){1,1}(:,[1,2,8,9,10]),allTasksTable.(4){1,1}(:,[1,2,8,9,10]));
tableTrialInfo.Properties.VariableNames = {'Task 1','Task 2','Task 3','Task 4'};

cd('S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary');
filename = 'trialInfos.xlsx';
writetable(allTasksTable.(1){1,1}(:,[1,2,8,9,10]),filename,'Sheet',1);
writetable(allTasksTable.(2){1,1}(:,[1,2,8,9,10]),filename,'Sheet',2);
writetable(allTasksTable.(3){1,1}(:,[1,2,8,9,10]),filename,'Sheet',3);
writetable(allTasksTable.(4){1,1}(:,[1,2,8,9,10]),filename,'Sheet',4);


%% Median and IQRs for perceptual switch timings: Physical trials, BR-completed, BR-incomplete switches (4,6,16,18,20,22)

tablePCTmedians = table(allTasksTable.(1){1,1}(:,[4,6,16,18,20,22]),allTasksTable.(2){1,1}(:,[4,6,16,18,20,22]),allTasksTable.(3){1,1}(:,[4,6,16,18,20,22]),allTasksTable.(4){1,1}(:,[4,6,16,18,20,22]));
tablePCTmedians.Properties.VariableNames = {'Task 1','Task 2','Task 3','Task 4'};

for row = 1:size(tablePCTmedians.(1),1)
    for col = 1:size(tablePCTmedians.(1),2)
        tablePCTtask1(row,1) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(1)(row,1))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(1)(row,2))), ')');
        tablePCTtask1(row,2) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(1)(row,3))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(1)(row,4))), ')');
        tablePCTtask1(row,3) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(1)(row,5))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(1)(row,6))), ')');
    end
end

for row = 1:size(tablePCTmedians.(2),1)
    for col = 1:size(tablePCTmedians.(2),2)
        tablePCTtask2(row,1) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(2)(row,1))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(2)(row,2))), ')');
        tablePCTtask2(row,2) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(2)(row,3))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(2)(row,4))), ')');
        tablePCTtask2(row,3) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(2)(row,5))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(2)(row,6))), ')');
    end
end

for row = 1:size(tablePCTmedians.(3),1)
    for col = 1:size(tablePCTmedians.(3),2)
        tablePCTtask3(row,1) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(3)(row,1))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(3)(row,2))), ')');
        tablePCTtask3(row,2) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(3)(row,3))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(3)(row,4))), ')');
        tablePCTtask3(row,3) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(3)(row,5))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(3)(row,6))), ')');
    end
end

for row = 1:size(tablePCTmedians.(4),1)
    for col = 1:size(tablePCTmedians.(4),2)
        tablePCTtask4(row,1) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(4)(row,1))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(4)(row,2))), ')');
        tablePCTtask4(row,2) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(4)(row,3))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(4)(row,4))), ')');
        tablePCTtask4(row,3) = strcat(sprintf("%.2f",table2array(tablePCTmedians.(4)(row,5))), ' (', sprintf("%.2f",table2array(tablePCTmedians.(4)(row,6))), ')');
    end
end

cd('S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary');
filename = 'PCTmedian_iqr.xlsx';
writematrix(tablePCTtask1,filename,'Sheet',1);
writematrix(tablePCTtask2,filename,'Sheet',2);
writematrix(tablePCTtask3,filename,'Sheet',3);
writematrix(tablePCTtask4,filename,'Sheet',4);
%% Perceptual Change Dynamics in the First Seconds of Trials: % of complete, incomplete, and overall switches in the first second, % of trials with a change in F1 (11,12,22,13): 
tableF1Effects = table(allTasksTable.(1){1,1}(:,[11,12,22,13]),allTasksTable.(2){1,1}(:,[11,12,22,13]),allTasksTable.(3){1,1}(:,[11,12,22,13]),allTasksTable.(4){1,1}(:,[11,12,22,13]));
tableF1Effects.Properties.VariableNames = {'Task 1','Task 2','Task 3','Task 4'};

cd('S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary');
filename = 'F1_probs.xlsx';
writetable(allTasksTable.(1){1,1}(:,[11,12,22,13]),filename,'Sheet',1);
writetable(allTasksTable.(2){1,1}(:,[11,12,22,13]),filename,'Sheet',2);
writetable(allTasksTable.(3){1,1}(:,[11,12,22,13]),filename,'Sheet',3);
writetable(allTasksTable.(4){1,1}(:,[11,12,22,13]),filename,'Sheet',4);


