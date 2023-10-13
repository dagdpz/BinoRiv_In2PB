% Author: Ryo Segawa (whizznihil.kid@gmail.com)
function analysis_human_perceptChange_rm2wayANOVA()

clear all
close all

trial_count = 8;
fig_dir = ['figures'];
mkdir(fig_dir)

subj_num = 0;
table_count_switchEffect = 0;
table_count_FPjEffect = 0;
table_count_SacEffect = 0;
table_count_interaction = 0;

data_dir_task1 = dir('Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task1');
data_dir_task1 = data_dir_task1(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir_task1.name})); % avoid '.' and '..'
for subj = 1:numel(data_dir_task1)
%     mkdir([fig_dir '/' data_dir_task1(subj).name])
%     subj_fig_dir = ([fig_dir '/' data_dir_task1(subj).name]);
    
    %% Extract timings of perceptual change
    % task 1
    subj_dir_task1 = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task1/' data_dir_task1(subj).name '/*.mat']);
    for file = 1:numel(subj_dir_task1)
        data_task1 = load(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task1/' data_dir_task1(subj).name '/' subj_dir_task1(file).name]);
                
        [binoriv_timing_task1_ins, phys_timing_task1_ins, binoriv_timing_task1_rel, phys_timing_task1_rel] = extract_buttonPress(1,data_task1);
    end
    
    if ~exist(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task2/' data_dir_task1(subj).name])
        continue
    end
    % task 2
    subj_dir_task2 = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task2/' data_dir_task1(subj).name '/*.mat']);
    for file = 1:numel(subj_dir_task2)
        data_task2 = load(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task2/' data_dir_task1(subj).name '/' subj_dir_task2(file).name]);
        
        [binoriv_timing_task2_ins, phys_timing_task2_ins, binoriv_timing_task2_rel, phys_timing_task2_rel] = extract_buttonPress(2,data_task2);
    end
    
    % task 3
    if ~exist(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task3/' data_dir_task1(subj).name])
        continue
    end
    subj_dir_task3 = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task3/' data_dir_task1(subj).name '/*.mat']);
    for file = 1:numel(subj_dir_task3)
        data_task3 = load(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task3/' data_dir_task1(subj).name '/' subj_dir_task3(file).name]);
        
        [binoriv_timing_task3_ins, phys_timing_task3_ins, binoriv_timing_task3_rel, phys_timing_task3_rel] = extract_buttonPress(3,data_task3);
    end
    
    % task 4
    if ~exist(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task4/' data_dir_task1(subj).name])
        continue
    end
    subj_dir_task4 = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task4/' data_dir_task1(subj).name '/*.mat']);
    for file = 1:numel(subj_dir_task4)
        data_task4 = load(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task4/' data_dir_task1(subj).name '/' subj_dir_task4(file).name]);
        
        [binoriv_timing_task4_ins, phys_timing_task4_ins, binoriv_timing_task4_rel, phys_timing_task4_rel] = extract_buttonPress(4,data_task4);
    end
    
    %% data store
    subj_num = subj_num + 1;

    % Switch effect
    table_count_switchEffect = table_count_switchEffect + 1;
    preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task1_ins),'PCT_rel_median', median(binoriv_timing_task1_rel)); % PCT: Percept Changed Timing
    table_count_switchEffect = table_count_switchEffect + 1;
    preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'Condition', 1,'PCT_ins_median', median(phys_timing_task1_ins),'PCT_rel_median', median(phys_timing_task1_rel)); % PCT: Percept Changed Timing
    table_count_switchEffect = table_count_switchEffect + 1;
    preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task2_ins),'PCT_rel_median', median(binoriv_timing_task2_rel)); 
    table_count_switchEffect = table_count_switchEffect + 1;
    preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 1,'PCT_ins_median', median(phys_timing_task2_ins),'PCT_rel_median', median(phys_timing_task2_rel)); 

    % FPj effect
    table_count_FPjEffect = table_count_FPjEffect + 1;
    preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task2_ins),'PCT_rel_median', median(binoriv_timing_task2_rel));
    table_count_FPjEffect = table_count_FPjEffect + 1;
    preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 1,'PCT_ins_median', median(phys_timing_task2_ins),'PCT_rel_median', median(phys_timing_task2_rel));
    table_count_FPjEffect = table_count_FPjEffect + 1;
    preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task3_ins),'PCT_rel_median', median(binoriv_timing_task3_rel)); 
    table_count_FPjEffect = table_count_FPjEffect + 1;
    preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'Condition', 1,'PCT_ins_median', median(phys_timing_task3_ins),'PCT_rel_median', median(phys_timing_task3_rel));
    
    % Saccade effect
    table_count_SacEffect = table_count_SacEffect + 1;
    preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task2_ins),'PCT_rel_median', median(binoriv_timing_task2_rel));
    table_count_SacEffect = table_count_SacEffect + 1;
    preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 1,'PCT_ins_median', median(phys_timing_task2_ins),'PCT_rel_median', median(phys_timing_task2_rel));
    table_count_SacEffect = table_count_SacEffect + 1;
    preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task4_ins),'PCT_rel_median', median(binoriv_timing_task4_rel));
    table_count_SacEffect = table_count_SacEffect + 1;
    preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'Condition', 1,'PCT_ins_median', median(phys_timing_task4_ins),'PCT_rel_median', median(phys_timing_task4_rel));
    
    % Interaction
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task1_ins),'PCT_rel_median', median(binoriv_timing_task1_rel)); 
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'Condition', 1,'PCT_ins_median', median(phys_timing_task1_ins),'PCT_rel_median', median(phys_timing_task1_rel));
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task2_ins),'PCT_rel_median', median(binoriv_timing_task2_rel));
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'Condition', 1,'PCT_ins_median', median(phys_timing_task2_ins),'PCT_rel_median', median(phys_timing_task2_rel));
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task3_ins),'PCT_rel_median', median(binoriv_timing_task3_rel)); 
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'Condition', 1,'PCT_ins_median', median(phys_timing_task3_ins),'PCT_rel_median', median(phys_timing_task3_rel));
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'Condition', 0,'PCT_ins_median', median(binoriv_timing_task4_ins),'PCT_rel_median', median(binoriv_timing_task4_rel));
    table_count_interaction = table_count_interaction + 1;
    preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
        'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'Condition', 1,'PCT_ins_median', median(phys_timing_task4_ins),'PCT_rel_median', median(phys_timing_task4_rel));
            
end

%% Outlier exclusion 
% exclude subjects who have a RT median of between-subject mean + 3*std or more in task 2
exclusion = true;
if exclusion
    indicesToDelete = find([preprocessedData_interaction.Task]~=2 | [preprocessedData_interaction.Condition]==0);
    preprocessedData_task2 = preprocessedData_interaction;
    preprocessedData_task2(indicesToDelete) = [];
    preprocessedData_task2 = struct2table(preprocessedData_task2);
    
    between_subj_ins_mean = mean(preprocessedData_task2.PCT_ins_median);
    between_subj_rel_mean = mean(preprocessedData_task2.PCT_rel_median);
    between_subj_ins_std = std(preprocessedData_task2.PCT_ins_median);
    between_subj_rel_std  = std(preprocessedData_task2.PCT_rel_median);
    threshold_pos_ins = between_subj_ins_mean + 3*between_subj_ins_std;
    threshold_neg_ins = between_subj_ins_mean - 3*between_subj_ins_std;
    threshold_pos_rel = between_subj_rel_mean + 3*between_subj_rel_std;
    threshold_neg_rel = between_subj_rel_mean - 3*between_subj_rel_std;
    
    outlierSubj_ID = preprocessedData_task2.SubjectID(find(preprocessedData_task2.PCT_ins_median>threshold_pos_ins | preprocessedData_task2.PCT_ins_median<threshold_neg_ins));
    preprocessedData_switchEffect(find([preprocessedData_switchEffect.SubjectID]==outlierSubj_ID)) = [];
    preprocessedData_FPjEffect(find([preprocessedData_FPjEffect.SubjectID]==outlierSubj_ID)) = [];
    preprocessedData_SacEffect(find([preprocessedData_SacEffect.SubjectID]==outlierSubj_ID)) = [];
    preprocessedData_interaction(find([preprocessedData_interaction.SubjectID]==outlierSubj_ID)) = [];
end


%% Two-way repeated-measures ANOVA
% data cleaning
preprocessedData_switchEffect_table=struct2table(preprocessedData_switchEffect);
% preprocessedData_switchEffect_table.WithSaccade = categorical(preprocessedData_switchEffect_table.WithSaccade);
% preprocessedData_switchEffect_table.WithFPj = categorical(preprocessedData_switchEffect_table.WithFPj);
% preprocessedData_switchEffect_table.Task = categorical(preprocessedData_switchEffect_table.Task);
% preprocessedData_switchEffect_table.SubjectID = categorical(preprocessedData_switchEffect_table.SubjectID);
preprocessedData_switchEffect_table.PCT_ins_median = double(preprocessedData_switchEffect_table.PCT_ins_median);
preprocessedData_switchEffect_table.PCT_rel_median = double(preprocessedData_switchEffect_table.PCT_rel_median);
rowsToRemove = strcmp(preprocessedData_switchEffect_table.Individual, 'Annalena');
preprocessedData_switchEffect_table(rowsToRemove, :) = [];

preprocessedData_FPjEffect_table=struct2table(preprocessedData_FPjEffect);
% preprocessedData_FPjEffect_table.WithSaccade = categorical(preprocessedData_FPjEffect_table.WithSaccade);
% preprocessedData_FPjEffect_table.WithFPj = categorical(preprocessedData_FPjEffect_table.WithFPj);
% preprocessedData_FPjEffect_table.Task = categorical(preprocessedData_FPjEffect_table.Task);
% preprocessedData_FPjEffect_table.SubjectID = categorical(preprocessedData_FPjEffect_table.SubjectID);
preprocessedData_FPjEffect_table.PCT_ins_median = double(preprocessedData_FPjEffect_table.PCT_ins_median);
preprocessedData_FPjEffect_table.PCT_rel_median = double(preprocessedData_FPjEffect_table.PCT_rel_median);

preprocessedData_SacEffect_table=struct2table(preprocessedData_SacEffect);
% preprocessedData_SacEffect_table.WithSaccade = categorical(preprocessedData_SacEffect_table.WithSaccade);
% preprocessedData_SacEffect_table.WithFPj = categorical(preprocessedData_SacEffect_table.WithFPj);
% preprocessedData_SacEffect_table.Task = categorical(preprocessedData_SacEffect_table.Task);
% preprocessedData_SacEffect_table.SubjectID = categorical(preprocessedData_SacEffect_table.SubjectID);
preprocessedData_SacEffect_table.PCT_ins_median = double(preprocessedData_SacEffect_table.PCT_ins_median);
preprocessedData_SacEffect_table.PCT_rel_median = double(preprocessedData_SacEffect_table.PCT_rel_median);

preprocessedData_interaction_table=struct2table(preprocessedData_interaction);
% preprocessedData_interaction_table.WithSaccade = categorical(preprocessedData_interaction_table.WithSaccade);
% preprocessedData_interaction_table.WithFPj = categorical(preprocessedData_interaction_table.WithFPj);
% preprocessedData_interaction_table.Task = categorical(preprocessedData_interaction_table.Task);
% preprocessedData_interaction_table.SubjectID = categorical(preprocessedData_interaction_table.SubjectID);
preprocessedData_interaction_table.PCT_ins_median = double(preprocessedData_interaction_table.PCT_ins_median);
preprocessedData_interaction_table.PCT_rel_median = double(preprocessedData_interaction_table.PCT_rel_median);
rowsToRemove = strcmp(preprocessedData_interaction_table.Individual, 'Annalena') & preprocessedData_interaction_table.Task==1;
preprocessedData_interaction_table(rowsToRemove, :) = [];

% Effect of percept switch after FPj [insertion]
stats = rm_anova2(preprocessedData_switchEffect_table.PCT_ins_median,...
    preprocessedData_switchEffect_table.SubjectID, ...
    preprocessedData_switchEffect_table.Task,...
    preprocessedData_switchEffect_table.Condition,...
    {'Task', 'Condition'});
disp('Effect of percept switch after FPj [insertion]:')
disp(stats)

% Effect of percept switch after FPj [release]
stats = rm_anova2(preprocessedData_switchEffect_table.PCT_rel_median,...
    preprocessedData_switchEffect_table.SubjectID, ...
    preprocessedData_switchEffect_table.Task,...
    preprocessedData_switchEffect_table.Condition,...
    {'Task', 'Condition'});
disp('Effect of percept switch after FPj [release]:')
disp(stats)

% FPj effect [insertion]
stats = rm_anova2(preprocessedData_FPjEffect_table.PCT_ins_median,...
    preprocessedData_FPjEffect_table.SubjectID, ...
    preprocessedData_FPjEffect_table.Task,...
    preprocessedData_FPjEffect_table.Condition,...
    {'Task', 'Condition'});
disp('FPj effect [insertion]:')
disp(stats)

% FPj effect [release]
stats = rm_anova2(preprocessedData_FPjEffect_table.PCT_rel_median,...
    preprocessedData_FPjEffect_table.SubjectID, ...
    preprocessedData_FPjEffect_table.Task,...
    preprocessedData_FPjEffect_table.Condition,...
    {'Task', 'Condition'});
disp('FPj effect [release]:')
disp(stats)

% Saccade effect [insertion]
stats = rm_anova2(preprocessedData_SacEffect_table.PCT_ins_median,...
    preprocessedData_SacEffect_table.SubjectID, ...
    preprocessedData_SacEffect_table.Task,...
    preprocessedData_SacEffect_table.Condition,...
    {'Task', 'Condition'});
disp('Saccade effect [insertion]:')
disp(stats)

% Saccade effect [release]
stats = rm_anova2(preprocessedData_SacEffect_table.PCT_rel_median,...
    preprocessedData_SacEffect_table.SubjectID, ...
    preprocessedData_SacEffect_table.Task,...
    preprocessedData_SacEffect_table.Condition,...
    {'Task', 'Condition'});
disp('Saccade effect [release]:')
disp(stats)

% Saccade+FPj effect [insertion]
stats = rm_anova2(preprocessedData_interaction_table.PCT_ins_median,...
    preprocessedData_interaction_table.SubjectID, ...
    preprocessedData_interaction_table.Task,...
    preprocessedData_interaction_table.Condition,...
    {'Task', 'Condition'});
disp('Saccade+FPj effect [insertion]:')
disp(stats)

% Saccade+FPj effect [release]
stats = rm_anova2(preprocessedData_interaction_table.PCT_rel_median,...
    preprocessedData_interaction_table.SubjectID, ...
    preprocessedData_interaction_table.Task,...
    preprocessedData_interaction_table.Condition,...
    {'Task', 'Condition'});
disp('Saccade+FPj effect [release]:')
disp(stats)



function [binoriv_timing_task_ins, phys_timing_task_ins, binoriv_timing_task_rel, phys_timing_task_rel] = extract_buttonPress(task_number,data)
binoriv_timing_task_ins = [];
phys_timing_task_ins = [];
binoriv_timing_task_rel = [];
phys_timing_task_rel = [];
%% Task 1 or 3
if task_number == 1 || task_number == 3
    %% Button insertion
%         for trl = 1:numel(data.trial)-1
    for trl = 18:numel(data.trial)-1
        if data.trial(trl-1).stimulus == 1 % remove the first trial from each block
            continue
        end
        % Binoriv 
        if data.trial(trl).stimulus == 4
            for loop = 1:7
                if data.trial(trl-loop).stimulus ~= 4
                    for sample = 1:data.trial(trl).counter-1
                        if data.trial(trl).repo_red(sample) == 0 && data.trial(trl).repo_red(sample+1) == 1
                            switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_task_ins = [binoriv_timing_task_ins switch_timing];
    %                         end
                            break
                        elseif data.trial(trl).repo_blue(sample) == 0 && data.trial(trl).repo_blue(sample+1) == 1
                            switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_task_ins = [binoriv_timing_task_ins switch_timing];
    %                         end
                            break
                        end
                    end      
                    break
                end

                if data.trial(trl-loop).eye.fix.x.red == data.trial(trl).eye.fix.x.red &&...
                    data.trial(trl-loop).eye.fix.y.red == data.trial(trl).eye.fix.y.red
%                             if any(find(data.trial(trl-loop).repo_red)) == 1 && any(find(data.trial(trl-loop).repo_red)) == 0
%                                 break
%                             elseif any(find(data.trial(trl-loop).repo_blue)) == 1 && any(find(data.trial(trl-loop).repo_blue)) == 0
%                                 break
                    if any(find(data.trial(trl-loop).repo_red)) == 1 && any(find(data.trial(trl-loop).repo_blue)) == 1
                        break
                    elseif any(find(data.trial(trl-loop).repo_red)) == 0 && any(find(data.trial(trl-loop).repo_red)) == 1 ||...
                            any(find(data.trial(trl-loop).repo_blue)) == 0 && any(find(data.trial(trl-loop).repo_blue)) == 1 
                        break
                    else
                        for sample = 1:data.trial(trl).counter-1
                            if data.trial(trl).repo_red(sample) == 0 && data.trial(trl).repo_red(sample+1) == 1
                                switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl-loop).tSample_from_time_start(1);
        %                         if switch_timing <= 5
                                    binoriv_timing_task_ins = [binoriv_timing_task_ins switch_timing];
        %                         end
                                break
                            elseif data.trial(trl).repo_blue(sample) == 0 && data.trial(trl).repo_blue(sample+1) == 1
                                switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl-loop).tSample_from_time_start(1);
        %                         if switch_timing <= 5
                                    binoriv_timing_task_ins = [binoriv_timing_task_ins switch_timing];
        %                         end
                                break
                            end
                        end        
                    end
                    break
                else
                    for sample = 1:data.trial(trl).counter-1
                        if data.trial(trl).repo_red(sample) == 0 && data.trial(trl).repo_red(sample+1) == 1
                            switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_task_ins = [binoriv_timing_task_ins switch_timing];
    %                         end
                            break
                        elseif data.trial(trl).repo_blue(sample) == 0 && data.trial(trl).repo_blue(sample+1) == 1
                            switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_task_ins = [binoriv_timing_task_ins switch_timing];
    %                         end
                            break
                        end
                    end
                    break
                end
            end

        % Phys 
        elseif data.trial(trl).stimulus == 2 && data.trial(trl+1).stimulus ~= 2
            for loop = 1:4
                if data.trial(trl-loop).stimulus ~= 2
                    min_trl = trl-loop + 1;
                end
            end

            percept_change = false;
            for cont_trl = min_trl:trl
                for sample = 1:data.trial(cont_trl).counter-1
                    if data.trial(cont_trl).repo_red(sample) == 0 && data.trial(cont_trl).repo_red(sample+1) == 1
                        switch_timing = data.trial(cont_trl).tSample_from_time_start(sample) - data.trial(cont_trl).tSample_from_time_start(1);
                        phys_timing_task_ins = [phys_timing_task_ins switch_timing];
                        percept_change = true;
                        break
                    end
                end
                if percept_change; break; end
            end                     

        elseif data.trial(trl).stimulus == 3 && data.trial(trl+1).stimulus ~= 3
            for loop = 1:4
                if data.trial(trl-loop).stimulus ~= 3
                    min_trl = trl-loop + 1;
                end
            end

            percept_change = false;
            for cont_trl = min_trl:trl
                for sample = 1:data.trial(cont_trl).counter-1
                    if data.trial(cont_trl).repo_blue(sample) == 0 && data.trial(cont_trl).repo_blue(sample+1) == 1
                        switch_timing = data.trial(cont_trl).tSample_from_time_start(sample) - data.trial(cont_trl).tSample_from_time_start(1);
                        phys_timing_task_ins = [phys_timing_task_ins switch_timing];
                        percept_change = true;
                        break
                    end
                end
                if percept_change; break; end
            end

        end        
    end

    %% Button release
%         for trl = 1:numel(data.trial)-1
    for trl = 18:numel(data.trial)-1
        if data.trial(trl-1).stimulus == 1 % remove the first trial from each block
            continue
        end
        % Binoriv 
        if data.trial(trl).stimulus == 4
            for loop = 1:7
                if data.trial(trl-loop).stimulus ~= 4
                    for sample = 1:data.trial(trl).counter-1
                        if data.trial(trl).repo_red(sample) == 1 && data.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_task_rel = [binoriv_timing_task_rel switch_timing];
    %                         end
                            break
                        elseif data.trial(trl).repo_blue(sample) == 1 && data.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_task_rel = [binoriv_timing_task_rel switch_timing];
    %                         end
                            break
                        end
                    end      
                    break
                end

                if data.trial(trl-loop).eye.fix.x.red == data.trial(trl).eye.fix.x.red &&...
                    data.trial(trl-loop).eye.fix.y.red == data.trial(trl).eye.fix.y.red
                    if any(find(data.trial(trl-loop).repo_red)) == 1 && any(find(data.trial(trl-loop).repo_red)) == 0
                        break
                    elseif any(find(data.trial(trl-loop).repo_blue)) == 1 && any(find(data.trial(trl-loop).repo_blue)) == 0
                        break
                    elseif any(find(data.trial(trl-loop).repo_red)) == 1 && any(find(data.trial(trl-loop).repo_blue)) == 1
                        break
                    elseif any(find(data.trial(trl-loop).repo_red)) == 0 && any(find(data.trial(trl-loop).repo_red)) == 1 ||...
                            any(find(data.trial(trl-loop).repo_blue)) == 0 && any(find(data.trial(trl-loop).repo_blue)) == 1 
                        break
                    else
                        for sample = 1:data.trial(trl).counter-1
                            if data.trial(trl).repo_red(sample) == 1 && data.trial(trl).repo_red(sample+1) == 0
                                switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl-loop).tSample_from_time_start(1);
        %                         if switch_timing <= 5
                                    binoriv_timing_task_rel = [binoriv_timing_task_rel switch_timing];
        %                         end
                                break
                            elseif data.trial(trl).repo_blue(sample) == 1 && data.trial(trl).repo_blue(sample+1) == 0
                                switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl-loop).tSample_from_time_start(1);
        %                         if switch_timing <= 5
                                    binoriv_timing_task_rel = [binoriv_timing_task_rel switch_timing];
        %                         end
                                break
                            end
                        end        
                    end
                    break
                else
                    for sample = 1:data.trial(trl).counter-1
                        if data.trial(trl).repo_red(sample) == 1 && data.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_task_rel = [binoriv_timing_task_rel switch_timing];
    %                         end
                            break
                        elseif data.trial(trl).repo_blue(sample) == 1 && data.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_task_rel = [binoriv_timing_task_rel switch_timing];
    %                         end
                            break
                        end
                    end
                    break
                end
            end

        % Phys
        elseif data.trial(trl).stimulus == 2 && data.trial(trl+1).stimulus ~= 2
            for loop = 1:4
                if data.trial(trl-loop).stimulus ~= 2
                    min_trl = trl-loop + 1;
                end
            end

            percept_change = false;
            for cont_trl = min_trl:trl
                for sample = 1:data.trial(cont_trl).counter-1
                    if data.trial(cont_trl).repo_blue(sample) == 1 && data.trial(cont_trl).repo_blue(sample+1) == 0
                        switch_timing = data.trial(cont_trl).tSample_from_time_start(sample) - data.trial(cont_trl).tSample_from_time_start(1);
                        phys_timing_task_rel = [phys_timing_task_rel switch_timing];
                        percept_change = true;
                        break
                    end
                end
                if percept_change; break; end
            end                     

        elseif data.trial(trl).stimulus == 3 && data.trial(trl+1).stimulus ~= 3
            for loop = 1:4
                if data.trial(trl-loop).stimulus ~= 3
                    min_trl = trl-loop + 1;
                end
            end

            percept_change = false;
            for cont_trl = min_trl:trl
                for sample = 1:data.trial(cont_trl).counter-1
                    if data.trial(cont_trl).repo_red(sample) == 1 && data.trial(cont_trl).repo_red(sample+1) == 0
                        switch_timing = data.trial(cont_trl).tSample_from_time_start(sample) - data.trial(cont_trl).tSample_from_time_start(1);
                        phys_timing_task_rel = [phys_timing_task_rel switch_timing];
                        percept_change = true;
                        break
                    end
                end
                if percept_change; break; end
            end
        end
    end
elseif task_number == 2 || task_number == 4
    %% Button insertion
%             for trl = 1:numel(data.trial)-1
    for trl = 18:numel(data.trial)-1
        if data.trial(trl-1).stimulus == 1 % remove the first trial from each block
            continue
        end
        % Binoriv 
        if data.trial(trl).stimulus == 4
            for sample = 1:data.trial(trl).counter-1
                if data.trial(trl).repo_red(sample) == 0 && data.trial(trl).repo_red(sample+1) == 1
                    switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         if switch_timing <= 5
                        binoriv_timing_task_ins = [binoriv_timing_task_ins switch_timing];
%                         end
                    break
                elseif data.trial(trl).repo_blue(sample) == 0 && data.trial(trl).repo_blue(sample+1) == 1
                    switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         if switch_timing <= 5
                        binoriv_timing_task_ins = [binoriv_timing_task_ins switch_timing];
%                         end
                    break
                end
            end      
        % Phys
        elseif data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3
            for sample = 1:data.trial(trl).counter-1
                if data.trial(trl).repo_red(sample) == 0 && data.trial(trl).repo_red(sample+1) == 1
                    switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         if switch_timing <= 5
                        phys_timing_task_ins = [phys_timing_task_ins switch_timing];
%                         end
                    break
                elseif data.trial(trl).repo_blue(sample) == 0 && data.trial(trl).repo_blue(sample+1) == 1
                    switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         if switch_timing <= 5
                        phys_timing_task_ins = [phys_timing_task_ins switch_timing];
%                         end
                    break
                end
            end
        end
    end

     %% Button release
%             for trl = 1:numel(data.trial)-1
    for trl = 18:numel(data.trial)-1
        if data.trial(trl-1).stimulus == 1 % remove the first trial from each block
            continue
        end
        % Binoriv 
        if data.trial(trl).stimulus == 4
            for sample = 1:data.trial(trl).counter-1
                if data.trial(trl).repo_red(sample) == 1 && data.trial(trl).repo_red(sample+1) == 0
                    switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         if switch_timing <= 5
                        binoriv_timing_task_rel = [binoriv_timing_task_rel switch_timing];
%                         end
                    break
                elseif data.trial(trl).repo_blue(sample) == 1 && data.trial(trl).repo_blue(sample+1) == 0
                    switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         if switch_timing <= 5
                        binoriv_timing_task_rel = [binoriv_timing_task_rel switch_timing];
%                         end
                    break
                end
            end    
        % Phys
        elseif data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3
            for sample = 1:data.trial(trl).counter-1
                if data.trial(trl).repo_red(sample) == 1 && data.trial(trl).repo_red(sample+1) == 0
                    switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         if switch_timing <= 5
                        phys_timing_task_rel = [phys_timing_task_rel switch_timing];
%                         end
                    break
                elseif data.trial(trl).repo_blue(sample) == 1 && data.trial(trl).repo_blue(sample+1) == 0
                    switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         if switch_timing <= 5
                        phys_timing_task_rel = [phys_timing_task_rel switch_timing];
%                         end
                    break
                end
            end
        end
    end
end

