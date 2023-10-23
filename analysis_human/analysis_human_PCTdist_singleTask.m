% Author: Ryo Segawa (whizznihil.kid@gmail.com)
% Comparison of perceptual change timing probabilities between arbitrary tasks
function analysis_human_PCTdist_single()

clear all
close all

taskA_number = 2;
subject = 11;
task_psuedoChopping = true; % Assign pseudo FP positions to task2 with the same random numbers as task1 and task3 to mimic the same reaction time plot scales as task1 and task3

data_dir_taskA = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(taskA_number)]);
% data_dir_taskA = dir(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task1']);
data_dir_taskA = data_dir_taskA(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir_taskA.name})); % avoid '.' and '..'

trial_count = 8;
fig_dir = ['figures'];
mkdir(fig_dir)

prob_dist_bino_taskA = [];
prob_dist_phys_taskA = [];
prob_dist_bino_taskB = [];
prob_dist_phys_taskB = [];

binoriv_timing_taskA_ins_allSubj = [];
phys_timing_taskA_ins_allSubj = [];
binoriv_timing_taskA_rel_allSubj = [];
phys_timing_taskA_rel_allSubj = [];

for subj = 1:numel(data_dir_taskA)
% for subj = subject:subject
    close all
    binoriv_timing_taskA_ins = [];
    phys_timing_taskA_ins = [];
    binoriv_timing_taskA_rel = [];
    phys_timing_taskA_rel = [];
    
    num_red_presented = 0;
    num_blue_presented = 0;
    num_red_cong = 0; % congruent with the stimulus
    num_blue_cong = 0;
    

    mkdir([fig_dir '/' data_dir_taskA(subj).name])
    subj_fig_dir = ([fig_dir '/' data_dir_taskA(subj).name]);
    
    
    subj_dir = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/*.mat']);
%     subj_dir = dir(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task1/' data_dir_taskA(subj).name]);
    for file = 1:numel(subj_dir)
        data_taskA = load(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/' subj_dir(file).name]);
%         data_taskA = load(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task1/' data_dir_taskA(subj).name]);

        % Outlier triad exclusion
        trial_count_forOutlier = trial_count*2;
        outlier_trials = [];
        for trl = 18:numel(data_taskA.trial)-17 
    %     for trl = 1:numel(data_taskA.trial)-1 
            if data_taskA.trial(trl).stimulus == 2 || data_taskA.trial(trl).stimulus == 3 || data_taskA.trial(trl).stimulus == 4
                if data_taskA.trial(trl).success == 0
                    trial_count_forOutlier = trial_count_forOutlier - 1;
                end

                if (data_taskA.trial(trl+1).stimulus == 1 || data_taskA.trial(trl+1).stimulus == 5) && trial_count_forOutlier == 1
                    outlier_trials = [outlier_trials (trl-trial_count*2+1:trl+1)];
                    trial_count_forOutlier = trial_count*2;
                elseif (data_taskA.trial(trl+1).stimulus == 1 || data_taskA.trial(trl+1).stimulus == 5) && trial_count_forOutlier ~= 1
                    trial_count_forOutlier = trial_count*2;
                end
            end
        end
        data_taskA.trial(outlier_trials) = [];
        
        % Calc num of phys stim presented & num of congruence
        for trl = 18:numel(data_taskA.trial)-1            
            if data_taskA.trial(trl).stimulus == 2 && data_taskA.trial(trl+1).stimulus ~= 2
                num_red_presented = num_red_presented + 1;
                if any(find(data_taskA.trial(trl).repo_red == 1))
                    num_red_cong = num_red_cong + 1;
                end
            elseif data_taskA.trial(trl).stimulus == 3 && data_taskA.trial(trl+1).stimulus ~= 3
                num_blue_presented = num_blue_presented + 1;
                if any(find(data_taskA.trial(trl).repo_blue == 1))
                    num_blue_cong = num_blue_cong + 1;
                end
            end
        end
        %% Task 1 or 3 (or 2)
        if taskA_number == 2 && task_psuedoChopping
            for trl = 1:numel(data_taskA.trial)
                fix_loc_label = randi([1 4],1,1);
                if fix_loc_label == 1
                    data_taskA.trial(trl).eye.fix.x.red = -1;
                    data_taskA.trial(trl).eye.fix.y.red = -1;
                elseif fix_loc_label == 2
                    data_taskA.trial(trl).eye.fix.x.red = -2;
                    data_taskA.trial(trl).eye.fix.y.red = -2;
                elseif fix_loc_label == 3
                    data_taskA.trial(trl).eye.fix.x.red = -3;
                    data_taskA.trial(trl).eye.fix.y.red = -3;
                elseif fix_loc_label == 4
                    data_taskA.trial(trl).eye.fix.x.red = -4;
                    data_taskA.trial(trl).eye.fix.y.red = -4;
                end
            end
        end
        
        if taskA_number == 1 || taskA_number == 3 || task_psuedoChopping
            %% Button insertion
    %         for trl = 1:numel(data_taskA.trial)-1
            for trl = 18:numel(data_taskA.trial)-1
                % Binoriv 
                if data_taskA.trial(trl).stimulus == 4
                    if data_taskA.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                        continue
                    end
                    for loop = 1:7
                        if data_taskA.trial(trl-loop).stimulus ~= 4
                            for sample = 1:data_taskA.trial(trl).counter-1
                                if data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_red(sample+1) == 1
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
            %                         if switch_timing <= 5
                                        binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing];
            %                         end
                                    break
                                elseif data_taskA.trial(trl).repo_blue(sample) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
            %                         if switch_timing <= 5
                                        binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing];
            %                         end
                                    break
                                end
                            end      
                            break
                        end

                        if data_taskA.trial(trl-loop).eye.fix.x.red == data_taskA.trial(trl).eye.fix.x.red &&...
                            data_taskA.trial(trl-loop).eye.fix.y.red == data_taskA.trial(trl).eye.fix.y.red
%                             if any(find(data_taskA.trial(trl-loop).repo_red)) == 1 && any(find(data_taskA.trial(trl-loop).repo_red)) == 0
%                                 break
%                             elseif any(find(data_taskA.trial(trl-loop).repo_blue)) == 1 && any(find(data_taskA.trial(trl-loop).repo_blue)) == 0
%                                 break
                            if any(find(data_taskA.trial(trl-loop).repo_red)) == 1 && any(find(data_taskA.trial(trl-loop).repo_blue)) == 1
                                break
                            elseif any(find(data_taskA.trial(trl-loop).repo_red)) == 0 && any(find(data_taskA.trial(trl-loop).repo_red)) == 1 ||...
                                    any(find(data_taskA.trial(trl-loop).repo_blue)) == 0 && any(find(data_taskA.trial(trl-loop).repo_blue)) == 1 
                                break
                            else
                                for sample = 1:data_taskA.trial(trl).counter-1
                                    if data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_red(sample+1) == 1
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl-loop).tSample_from_time_start(1);
                %                         if switch_timing <= 5
                                            binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing];
                %                         end
                                        break
                                    elseif data_taskA.trial(trl).repo_blue(sample) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl-loop).tSample_from_time_start(1);
                %                         if switch_timing <= 5
                                            binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing];
                %                         end
                                        break
                                    end
                                end        
                            end
                            break
                        else
                            for sample = 1:data_taskA.trial(trl).counter-1
                                if data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_red(sample+1) == 1
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
            %                         if switch_timing <= 5
                                        binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing];
            %                         end
                                    break
                                elseif data_taskA.trial(trl).repo_blue(sample) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
            %                         if switch_timing <= 5
                                        binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing];
            %                         end
                                    break
                                end
                            end
                            break
                        end
                    end

                % Phys 
                elseif data_taskA.trial(trl).stimulus == 2 && data_taskA.trial(trl+1).stimulus ~= 2
                    for loop = 1:4
                        if data_taskA.trial(trl-loop).stimulus ~= 2
                            min_trl = trl-loop + 1;
                        end
                    end
                    
                    percept_change = false;
                    for cont_trl = min_trl:trl
                        for sample = 1:data_taskA.trial(cont_trl).counter-1
                            if data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_red(sample+1) == 1
                                switch_timing = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing];
                                percept_change = true;
                                break
                            end
                        end
                        if percept_change; break; end
                    end                     

                elseif data_taskA.trial(trl).stimulus == 3 && data_taskA.trial(trl+1).stimulus ~= 3
                    for loop = 1:4
                        if data_taskA.trial(trl-loop).stimulus ~= 3
                            min_trl = trl-loop + 1;
                        end
                    end
                    
                    percept_change = false;
                    for cont_trl = min_trl:trl
                        for sample = 1:data_taskA.trial(cont_trl).counter-1
                            if data_taskA.trial(cont_trl).repo_blue(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1
                                switch_timing = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing];
                                percept_change = true;
                                break
                            end
                        end
                        if percept_change; break; end
                    end
                    
                end        
            end

            %% Button release
    %         for trl = 1:numel(data_taskA.trial)-1
            for trl = 18:numel(data_taskA.trial)-1
                % Binoriv 
                if data_taskA.trial(trl).stimulus == 4
                    if data_taskA.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                        continue
                    end
                    for loop = 1:7
                        if data_taskA.trial(trl-loop).stimulus ~= 4
                            for sample = 1:data_taskA.trial(trl).counter-1
                                if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
            %                         if switch_timing <= 5
                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
            %                         end
                                    break
                                elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
            %                         if switch_timing <= 5
                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
            %                         end
                                    break
                                end
                            end      
                            break
                        end

                        if data_taskA.trial(trl-loop).eye.fix.x.red == data_taskA.trial(trl).eye.fix.x.red &&...
                            data_taskA.trial(trl-loop).eye.fix.y.red == data_taskA.trial(trl).eye.fix.y.red
                            if any(find(data_taskA.trial(trl-loop).repo_red)) == 1 && any(find(data_taskA.trial(trl-loop).repo_red)) == 0
                                break
                            elseif any(find(data_taskA.trial(trl-loop).repo_blue)) == 1 && any(find(data_taskA.trial(trl-loop).repo_blue)) == 0
                                break
                            elseif any(find(data_taskA.trial(trl-loop).repo_red)) == 1 && any(find(data_taskA.trial(trl-loop).repo_blue)) == 1
                                break
                            elseif any(find(data_taskA.trial(trl-loop).repo_red)) == 0 && any(find(data_taskA.trial(trl-loop).repo_red)) == 1 ||...
                                    any(find(data_taskA.trial(trl-loop).repo_blue)) == 0 && any(find(data_taskA.trial(trl-loop).repo_blue)) == 1 
                                break
                            else
                                for sample = 1:data_taskA.trial(trl).counter-1
                                    if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl-loop).tSample_from_time_start(1);
                %                         if switch_timing <= 5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
                %                         end
                                        break
                                    elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl-loop).tSample_from_time_start(1);
                %                         if switch_timing <= 5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
                %                         end
                                        break
                                    end
                                end        
                            end
                            break
                        else
                            for sample = 1:data_taskA.trial(trl).counter-1
                                if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
            %                         if switch_timing <= 5
                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
            %                         end
                                    break
                                elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
            %                         if switch_timing <= 5
                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
            %                         end
                                    break
                                end
                            end
                            break
                        end
                    end

                % Phys
                elseif data_taskA.trial(trl).stimulus == 2 && data_taskA.trial(trl+1).stimulus ~= 2
                    for loop = 1:4
                        if data_taskA.trial(trl-loop).stimulus ~= 2
                            min_trl = trl-loop + 1;
                        end
                    end
                    
                    percept_change = false;
                    for cont_trl = min_trl:trl
                        for sample = 1:data_taskA.trial(cont_trl).counter-1
                            if data_taskA.trial(cont_trl).repo_blue(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0
                                switch_timing = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing];
                                percept_change = true;
                                break
                            end
                        end
                        if percept_change; break; end
                    end                     

                elseif data_taskA.trial(trl).stimulus == 3 && data_taskA.trial(trl+1).stimulus ~= 3
                    for loop = 1:4
                        if data_taskA.trial(trl-loop).stimulus ~= 3
                            min_trl = trl-loop + 1;
                        end
                    end
                    
                    percept_change = false;
                    for cont_trl = min_trl:trl
                        for sample = 1:data_taskA.trial(cont_trl).counter-1
                            if data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_red(sample+1) == 0
                                switch_timing = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing];
                                percept_change = true;
                                break
                            end
                        end
                        if percept_change; break; end
                    end
                end
            end
        elseif taskA_number == 2 || taskA_number == 4
            if taskA_number == 2 && task_psuedoChopping
                continue
            end
            %% Button insertion
%             for trl = 1:numel(data_taskA.trial)-1
            for trl = 18:numel(data_taskA.trial)-1
                
                % Binoriv 
                if data_taskA.trial(trl).stimulus == 4
                    if data_taskA.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                        continue
                    end
                    
                    if data_taskA.trial(trl-1).stimulus == 1 || data_taskA.trial(trl-1).stimulus == 2 || data_taskA.trial(trl-1).stimulus == 3% remove the first trial from each block
                        continue
                    end
                    for sample = 1:data_taskA.trial(trl).counter-1
                        if data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_red(sample+1) == 1
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing];
    %                         end
                            break
                        elseif data_taskA.trial(trl).repo_blue(sample) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing];
    %                         end
                            break
                        end
                    end      
                % Phys
                elseif data_taskA.trial(trl).stimulus == 2 || data_taskA.trial(trl).stimulus == 3
                    for sample = 1:data_taskA.trial(trl).counter-1
                        if data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_red(sample+1) == 1
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing];
    %                         end
                            break
                        elseif data_taskA.trial(trl).repo_blue(sample) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing];
    %                         end
                            break
                        end
                    end
                end
            end
            
             %% Button release
%             for trl = 1:numel(data_taskA.trial)-1
            for trl = 18:numel(data_taskA.trial)-1
                % Binoriv 
                if data_taskA.trial(trl).stimulus == 4
                    if data_taskA.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                        continue
                    end
                    
                    if data_taskA.trial(trl-1).stimulus == 1 || data_taskA.trial(trl-1).stimulus == 2 || data_taskA.trial(trl-1).stimulus == 3% remove the first trial from each block
                        continue
                    end
                    for sample = 1:data_taskA.trial(trl).counter-1
                        if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
    %                         end
                            break
                        elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
    %                         end
                            break
                        end
                    end    
                % Phys
                elseif data_taskA.trial(trl).stimulus == 2 || data_taskA.trial(trl).stimulus == 3
                    for sample = 1:data_taskA.trial(trl).counter-1
                        if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing];
    %                         end
                            break
                        elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
    %                         if switch_timing <= 5
                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing];
    %                         end
                            break
                        end
                    end
                end
            end
        end
    end
    
    % Define the bin edges
    if taskA_number == 4
        binEdges = 0:0.25:5;
    elseif taskA_number == 2
        if task_psuedoChopping
            binEdges = 0:0.25:40;
        else
            binEdges = 0:0.25:5;
        end
    else
        binEdges = 0:0.25:40;
    end
    
    % Percept switch prob. in BinoRiv cond. insertion
    figure('Position', [100 100 800 600]);
%     histogram(binoriv_timing_taskA_ins,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(binoriv_timing_taskA_ins, 'Normalization', 'probability', 'NumBins', 20);
    histData = histcounts(binoriv_timing_taskA_ins, binEdges);
    bar(binEdges(1:end-1) + diff(binEdges)/2, histData);
    xline(mean(binoriv_timing_taskA_ins),'-',{'Mean'})
    xline(median(binoriv_timing_taskA_ins),'--',{'Median'})
%     if taskA_number == 2 || taskA_number == 4
%         xlim([0 5])
%     else
        xlim([0 10])
%     end
%     ylim([0 1])
    xlabel('Time from trial onset [s]')
%     ylabel('Probability');
    ylabel('Counts');
    title(['Probability Distribution of task ' num2str(taskA_number)...
        ', Binoriv insertion'...
        ', Num of data: ' num2str(numel(binoriv_timing_taskA_ins))]);
    filename = [subj_fig_dir '/Switch_prob_bino_ins_' num2str(taskA_number) '.png'];
    saveas(gcf,filename)
    filename = [subj_fig_dir '/Switch_prob_bino_ins_' num2str(taskA_number) '.fig'];
    saveas(gcf,filename)
    binoriv_timing_taskA_ins_allSubj = [binoriv_timing_taskA_ins_allSubj binoriv_timing_taskA_ins];
    
    % Percept switch prob. in Phys cond. insertion
    figure('Position', [100 100 800 600]);
%     histogram(phys_timing_taskA_ins,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(phys_timing_taskA_ins, 'Normalization', 'probability', 'NumBins', 20);
    histData = histcounts(phys_timing_taskA_ins, binEdges);
    bar(binEdges(1:end-1) + diff(binEdges)/2, histData);
    xline(mean(phys_timing_taskA_ins),'-',{'Mean'})
    xline(median(phys_timing_taskA_ins),'--',{'Median'})
%     if taskA_number == 2 || taskA_number == 4
%         xlim([0 5])
%     else
        xlim([0 10])
%     end
%     ylim([0 1])
    xlabel('Time from trial onset [s]')
%     ylabel('Probability');
    ylabel('Counts');
    title({['Probability Distribution of task ' num2str(taskA_number)...
        ', Phys insertion'...
        ', Num of data: ' num2str(numel(phys_timing_taskA_ins))]},...
        {['Num of red presented: ' num2str(num_red_presented)...
        ', Num of blue presented: ' num2str(num_blue_presented),...
        ', Num of red correct: ' num2str(num_red_cong)...
        ', Num of blue correct: ' num2str(num_blue_cong)...
        ', Success rate: ' num2str(100*(num_red_cong+num_blue_cong)/(num_red_presented+num_blue_presented)) '%']})
    filename = [subj_fig_dir '/Switch_prob_phys_ins_' num2str(taskA_number) '.png'];
    saveas(gcf,filename)
    filename = [subj_fig_dir '/Switch_prob_phys_ins_' num2str(taskA_number) '.fig'];
    saveas(gcf,filename)
    phys_timing_taskA_ins_allSubj = [phys_timing_taskA_ins_allSubj phys_timing_taskA_ins];
    
    % Percept switch prob. in BinoRiv cond. release
    figure('Position', [100 100 800 600]);
%     histogram(binoriv_timing_taskA_rel,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(binoriv_timing_taskA_rel, 'Normalization', 'probability', 'NumBins', 20);
    histData = histcounts(binoriv_timing_taskA_rel, binEdges);
    bar(binEdges(1:end-1) + diff(binEdges)/2, histData);
    xline(mean(binoriv_timing_taskA_rel),'-',{'Mean'})
    xline(median(binoriv_timing_taskA_rel),'--',{'Median'})
%     if taskA_number == 2 || taskA_number == 4
%         xlim([0 5])
%     else
        xlim([0 10])
%     end
%     ylim([0 1])
    xlabel('Time from trial onset [s]')
%     ylabel('Probability');
    ylabel('Counts');
    title(['Probability Distribution of task ' num2str(taskA_number)...
        ', Binoriv release'...
        ', Num of data: ' num2str(numel(binoriv_timing_taskA_rel))]);
    filename = [subj_fig_dir '/Switch_prob_bino_rel_' num2str(taskA_number) '.png'];
    saveas(gcf,filename)
    filename = [subj_fig_dir '/Switch_prob_bino_rel_' num2str(taskA_number) '.fig'];
    saveas(gcf,filename)
    binoriv_timing_taskA_rel_allSubj = [binoriv_timing_taskA_rel_allSubj binoriv_timing_taskA_rel];
    
    % Percept switch prob. in Phys cond. release
    figure('Position', [100 100 800 600]);
%     histogram(phys_timing_taskA_rel,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(phys_timing_taskA_rel, 'Normalization', 'probability', 'NumBins', 20);
    histData = histcounts(phys_timing_taskA_rel, binEdges);
    bar(binEdges(1:end-1) + diff(binEdges)/2, histData);
    xline(mean(phys_timing_taskA_rel),'-',{'Mean'})
    xline(median(phys_timing_taskA_rel),'--',{'Median'})
%     if taskA_number == 2 || taskA_number == 4
%         xlim([0 5])
%     else
        xlim([0 10])
%     end
%     ylim([0 1])
    xlabel('Time from trial onset [s]')
%     ylabel('Probability');
    ylabel('Counts');
%     title({['Probability Distribution of task ' num2str(taskA_number)...
%         ', Phys release'...
%         ', Num of data: ' num2str(numel(phys_timing_taskA_rel))]},...
%         {['Num of red presented: ' num2str(num_red_presented)...
%         ', Num of blue presented: ' num2str(num_blue_presented)]},...
%         {['Num of red correct: ' num2str(num_red_cong)...
%         ', Num of blue correct: ' num2str(num_blue_cong)]});
    title({['Probability Distribution of task ' num2str(taskA_number)...
        ', Phys release'...
        ', Num of data: ' num2str(numel(phys_timing_taskA_rel))]},...
        {['Num of red presented: ' num2str(num_red_presented)...
        ', Num of blue presented: ' num2str(num_blue_presented),...
        ', Num of red correct: ' num2str(num_red_cong)...
        ', Num of blue correct: ' num2str(num_blue_cong),...
        ', Success rate: ' num2str(100*(num_red_cong+num_blue_cong)/(num_red_presented+num_blue_presented)) '%']})
    filename = [subj_fig_dir '/Switch_prob_phys_rel_' num2str(taskA_number) '.png'];
    saveas(gcf,filename)
    filename = [subj_fig_dir '/Switch_prob_phys_rel_' num2str(taskA_number) '.fig'];
    saveas(gcf,filename)
    phys_timing_taskA_rel_allSubj = [phys_timing_taskA_rel_allSubj phys_timing_taskA_rel];
    

    % Percept switch prob. in both cond. 
%     figure;
% %     histogram(binoriv_timing_taskA,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(binoriv_timing_taskA, 'Normalization', 'probability', 'FaceAlpha', 0.5, 'NumBins', 20); hold on
%     histogram(phys_timing_taskA, 'Normalization', 'probability', 'FaceAlpha', 0.5, 'NumBins', 20);
%     xline(mean(binoriv_timing_taskA),'-',{'Binoriv mean'})
%     xline(median(binoriv_timing_taskA),'--',{'Binoriv median'})
%     xline(mean(phys_timing_taskA),'-',{'Phys mean'})
%     xline(median(phys_timing_taskA),'--',{'Phys median'})
%     xlim([0 5])
%     [p_mw, h, mwstat] = ranksum(binoriv_timing_taskA,phys_timing_taskA);
%     xlabel('Time from trial onset [s]')
%     ylabel('Probability');
%     title(['Probability Distribution of task ' num2str(taskA_number) ', p-mw=' num2str(p_mw)]);
%     filename = [subj_fig_dir '/Switch_prob_comp_' num2str(taskA_number) '.png'];
%     saveas(gcf,filename)
%     filename = [subj_fig_dir '/Switch_prob_comp_' num2str(taskA_number) '.fig'];
%     saveas(gcf,filename)

end


% Percept switch prob. in Binoriv cond. insertion across all subj
figure('Position', [100 100 800 600]);
%     histogram(phys_timing_taskA_rel,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(phys_timing_taskA_rel, 'Normalization', 'probability', 'NumBins', 20);
histData = histcounts(binoriv_timing_taskA_ins_allSubj, binEdges);
bar(binEdges(1:end-1) + diff(binEdges)/2, histData);
xline(mean(binoriv_timing_taskA_ins_allSubj),'-',{'Mean'})
xline(median(binoriv_timing_taskA_ins_allSubj),'--',{'Median'})
%     if taskA_number == 2 || taskA_number == 4
%         xlim([0 5])
%     else
    xlim([0 10])
%     end
%     ylim([0 1])
xlabel('Time from trial onset [s]')
%     ylabel('Probability');
ylabel('Counts');
title({['Probability Distribution of task ' num2str(taskA_number)...
    ', Binoriv insertion'...
    ', Num of data: ' num2str(numel(binoriv_timing_taskA_ins_allSubj))]})
filename = [fig_dir '/Switch_prob_binoriv_ins_' num2str(taskA_number) '_allSubj.png'];
saveas(gcf,filename)
filename = [fig_dir '/Switch_prob_binoriv_ins_' num2str(taskA_number) '_allSubj.fig'];
saveas(gcf,filename)

% Percept switch prob. in phys cond. insertion across all subj
figure('Position', [100 100 800 600]);
%     histogram(phys_timing_taskA_rel,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(phys_timing_taskA_rel, 'Normalization', 'probability', 'NumBins', 20);
histData = histcounts(phys_timing_taskA_ins_allSubj, binEdges);
bar(binEdges(1:end-1) + diff(binEdges)/2, histData);
xline(mean(phys_timing_taskA_ins_allSubj),'-',{'Mean'})
xline(median(phys_timing_taskA_ins_allSubj),'--',{'Median'})
%     if taskA_number == 2 || taskA_number == 4
%         xlim([0 5])
%     else
    xlim([0 10])
%     end
%     ylim([0 1])
xlabel('Time from trial onset [s]')
%     ylabel('Probability');
ylabel('Counts');
title({['Probability Distribution of task ' num2str(taskA_number)...
    ', Phys insertion'...
    ', Num of data: ' num2str(numel(phys_timing_taskA_ins_allSubj))]})
filename = [fig_dir '/Switch_prob_phys_ins_' num2str(taskA_number) '_allSubj.png'];
saveas(gcf,filename)
filename = [fig_dir '/Switch_prob_phys_ins_' num2str(taskA_number) '_allSubj.fig'];
saveas(gcf,filename)

% Percept switch prob. in binoriv cond. release across all subj
figure('Position', [100 100 800 600]);
%     histogram(phys_timing_taskA_rel,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(phys_timing_taskA_rel, 'Normalization', 'probability', 'NumBins', 20);
histData = histcounts(binoriv_timing_taskA_rel_allSubj, binEdges);
bar(binEdges(1:end-1) + diff(binEdges)/2, histData);
xline(mean(binoriv_timing_taskA_rel_allSubj),'-',{'Mean'})
xline(median(binoriv_timing_taskA_rel_allSubj),'--',{'Median'})
%     if taskA_number == 2 || taskA_number == 4
%         xlim([0 5])
%     else
    xlim([0 10])
%     end
%     ylim([0 1])
xlabel('Time from trial onset [s]')
%     ylabel('Probability');
ylabel('Counts');
title({['Probability Distribution of task ' num2str(taskA_number)...
    ', Binoriv release'...
    ', Num of data: ' num2str(numel(binoriv_timing_taskA_rel_allSubj))]})
filename = [fig_dir '/Switch_prob_binoriv_rel_' num2str(taskA_number) '_allSubj.png'];
saveas(gcf,filename)
filename = [fig_dir '/Switch_prob_binoriv_rel_' num2str(taskA_number) '_allSubj.fig'];
saveas(gcf,filename)

% Percept switch prob. in phys cond. release across all subj
figure('Position', [100 100 800 600]);
%     histogram(phys_timing_taskA_rel,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(phys_timing_taskA_rel, 'Normalization', 'probability', 'NumBins', 20);
histData = histcounts(phys_timing_taskA_rel_allSubj, binEdges);
bar(binEdges(1:end-1) + diff(binEdges)/2, histData);
xline(mean(phys_timing_taskA_rel_allSubj),'-',{'Mean'})
xline(median(phys_timing_taskA_rel_allSubj),'--',{'Median'})
%     if taskA_number == 2 || taskA_number == 4
%         xlim([0 5])
%     else
    xlim([0 10])
%     end
%     ylim([0 1])
xlabel('Time from trial onset [s]')
%     ylabel('Probability');
ylabel('Counts');
title({['Probability Distribution of task ' num2str(taskA_number)...
    ', Phys release'...
    ', Num of data: ' num2str(numel(phys_timing_taskA_rel_allSubj))]})
filename = [fig_dir '/Switch_prob_phys_rel_' num2str(taskA_number) '_allSubj.png'];
saveas(gcf,filename)
filename = [fig_dir '/Switch_prob_phys_rel_' num2str(taskA_number) '_allSubj.fig'];
saveas(gcf,filename)


