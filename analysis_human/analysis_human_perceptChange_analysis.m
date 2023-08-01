% Author: Ryo Segawa (whizznihil.kid@gmail.com)
function analysis_human_perceptChange_analysis()

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

data_dir_task1 = dir('data_task1');
data_dir_task1 = data_dir_task1(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir_task1.name})); % avoid '.' and '..'
for subj = 1:numel(data_dir_task1)
    binoriv_timing_task1 = [];
    binoriv_timing_task2 = [];
    binoriv_timing_task3 = [];
    binoriv_timing_task4 = [];
    phys_timing_task1 = [];
    phys_timing_task2 = [];
    phys_timing_task3 = [];
    phys_timing_task4 = [];
    

%     mkdir([fig_dir '/' data_dir_task1(subj).name])
%     subj_fig_dir = ([fig_dir '/' data_dir_task1(subj).name]);
    
    %% Extract timings of perceptual change
    % task 1
    subj_dir_task1 = dir(['data_task1/' data_dir_task1(subj).name '/*.mat']);
    for file = 1:numel(subj_dir_task1)
        data_task1 = load(['data_task1/' data_dir_task1(subj).name '/' subj_dir_task1(file).name]);
        
        % Outlier triad exclusion based on eye-tracking quality
%         trial_count_forOutlier = trial_count*2;
%         outlier_trials = [];
%         for trl = 18:numel(data.trial)-17 
%     %     for trl = 1:numel(data.trial)-1 
%             if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3 || data.trial(trl).stimulus == 4
%                 if data.trial(trl).success == 0
%                     trial_count_forOutlier = trial_count_forOutlier - 1;
%                 end
% 
%                 if (data.trial(trl+1).stimulus == 1 || data.trial(trl+1).stimulus == 5) && trial_count_forOutlier == 1
%                     outlier_trials = [outlier_trials (trl-trial_count*2+1:trl+1)];
%                     trial_count_forOutlier = trial_count*2;
%                 elseif (data.trial(trl+1).stimulus == 1 || data.trial(trl+1).stimulus == 5) && trial_count_forOutlier ~= 1
%                     trial_count_forOutlier = trial_count*2;
%                 end
%             end
%         end
%         data.trial(outlier_trials) = [];
        
        % Remove calibration failed blocks
        if strcmp(subj_dir_task1(file).name,'Gokberk2023-01-26_05.mat')
            invalid_trials = [73:90, 91:108, 127:144, 163:180];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Gokberk2023-01-26_07.mat')
            invalid_trials = [55:72, 145:180, 199:235];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Anahita2023-01-26_10.mat')
            invalid_trials = [145:162, 253:270, 325:342];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Giorgio2023-01-27_03.mat')
            invalid_trials = [1:126, 163:198, 253:306, 325:360, 433:468, 505:558, 595:612];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Annalena2023-02-14_03.mat')
            invalid_trials = [145:162, 199:216, 235:308, 327:344, 363:398, 472:489];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Ash2023-02-16_04.mat')
            invalid_trials = [109:126];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Ash2023-02-16_06.mat')
            invalid_trials = [73:90];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Ash2023-02-16_09.mat')
            invalid_trials = [1:18, 55:72, 145:180];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Ash2023-02-16_11.mat')
            invalid_trials = [37:54, 73:90, 109:126];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Ash2023-02-16_13.mat')
            invalid_trials = [19:36];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        elseif strcmp(subj_dir_task1(file).name,'Annika2023-02-21_07.mat')
            invalid_trials = [469:486];
            data_dummy = [];
            for trl = 1:numel(data_task1.trial)
                if ~any(find(data_task1.trial(trl).n == invalid_trials))
                    data_dummy = [data_dummy data_task1.trial(trl)];
                end
            end
            data_task1.trial = data_dummy;
        end
        
        
        for trl = 18:numel(data_task1.trial)-1
%             switch_timing = NaN;
            % Binoriv 
            if data_task1.trial(trl).stimulus == 4 %&& numel(data_task1.trial(trl).chopping_label) == 2
                for sample = 1:data_task1.trial(trl).counter-1
%                     if data_task1.trial(trl).repo_red(sample) ~= data_task1.trial(trl).repo_red(1)
%                         switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);
%                         break
%                     elseif data_task1.trial(trl).repo_blue(sample) ~= data_task1.trial(trl).repo_blue(1)
%                         switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);;
%                         break
%                     end
                    if data_task1.trial(trl).repo_red(sample) == 1 && data_task1.trial(trl).repo_red(sample+1) == 0
                        switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_task1 = [binoriv_timing_task1 switch_timing];
                        continue
                    elseif data_task1.trial(trl).repo_blue(sample) == 1 && data_task1.trial(trl).repo_blue(sample+1) == 0
                        switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_task1 = [binoriv_timing_task1 switch_timing];
                        continue
                    end
                end            
            % Phys
            elseif data_task1.trial(trl).stimulus == 2 || data_task1.trial(trl).stimulus == 3
%                 if numel(data_task1.trial(trl).chopping_label) == 2
                    for sample = 1:data_task1.trial(trl).counter-1
    %                     if data_task1.trial(trl).repo_red(sample) ~= data_task1.trial(trl).repo_red(1)
    %                         switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     elseif data_task1.trial(trl).repo_blue(sample) ~= data_task1.trial(trl).repo_blue(1)
    %                         switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     end
                        if data_task1.trial(trl).repo_red(sample) == 1 && data_task1.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);
                            phys_timing_task1 = [phys_timing_task1 switch_timing];
                            continue
                        elseif data_task1.trial(trl).repo_blue(sample) == 1 && data_task1.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);
                            phys_timing_task1 = [phys_timing_task1 switch_timing];
                            continue
                        end
                    end
%                 end
            end        
        end
    end
    
    if ~exist(['data_task2/' data_dir_task1(subj).name])
        continue
    end
    % task 2
    subj_dir_task2 = dir(['data_task2/' data_dir_task1(subj).name '/*.mat']);
    for file = 1:numel(subj_dir_task2)
        data_task2 = load(['data_task2/' data_dir_task1(subj).name '/' subj_dir_task2(file).name]);
        for trl = 18:numel(data_task2.trial)-1
    %             switch_timing = NaN;
            % Binoriv 
            if data_task2.trial(trl).stimulus == 4 %&& numel(data_task2.trial(trl).chopping_label) == 2
                for sample = 1:data_task2.trial(trl).counter-1
    %                     if data.trial(trl).repo_red(sample) ~= data.trial(trl).repo_red(1)
    %                         switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
    %                         break
    %                     elseif data.trial(trl).repo_blue(sample) ~= data.trial(trl).repo_blue(1)
    %                         switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     end
                    if data_task2.trial(trl).repo_red(sample) == 1 && data_task2.trial(trl).repo_red(sample+1) == 0
                        switch_timing = data_task2.trial(trl).tSample_from_time_start(sample) - data_task2.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_task2 = [binoriv_timing_task2 switch_timing];
                        continue
                    elseif data_task2.trial(trl).repo_blue(sample) == 1 && data_task2.trial(trl).repo_blue(sample+1) == 0
                        switch_timing = data_task2.trial(trl).tSample_from_time_start(sample) - data_task2.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_task2 = [binoriv_timing_task2 switch_timing];
                        continue
                    end
                end            
            % Phys
            elseif data_task2.trial(trl).stimulus == 2 || data_task2.trial(trl).stimulus == 3
    %             if numel(data_task2.trial(trl).chopping_label) == 2
                    for sample = 1:data_task2.trial(trl).counter-1
    %                     if data.trial(trl).repo_red(sample) ~= data.trial(trl).repo_red(1)
    %                         switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     elseif data.trial(trl).repo_blue(sample) ~= data.trial(trl).repo_blue(1)
    %                         switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     end
                        if data_task2.trial(trl).repo_red(sample) == 1 && data_task2.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data_task2.trial(trl).tSample_from_time_start(sample) - data_task2.trial(trl).tSample_from_time_start(1);
                            phys_timing_task2 = [phys_timing_task2 switch_timing];
                            continue
                        elseif data_task2.trial(trl).repo_blue(sample) == 1 && data_task2.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data_task2.trial(trl).tSample_from_time_start(sample) - data_task2.trial(trl).tSample_from_time_start(1);
                            phys_timing_task2 = [phys_timing_task2 switch_timing];
                            continue
                        end
                    end
    %             end
            end
        end
    end
    
    % task 3
    if ~exist(['data_task3/' data_dir_task1(subj).name])
        continue
    end
    subj_dir_task3 = dir(['data_task3/' data_dir_task1(subj).name '/*.mat']);
    for file = 1:numel(subj_dir_task3)
        data_task3 = load(['data_task3/' data_dir_task1(subj).name '/' subj_dir_task3(file).name]);
        
        for trl = 18:numel(data_task3.trial)-1
%             switch_timing = NaN;
            % Binoriv 
            if data_task3.trial(trl).stimulus == 4 %&& numel(data_task1.trial(trl).chopping_label) == 2
                for sample = 1:data_task3.trial(trl).counter-1
%                     if data_task1.trial(trl).repo_red(sample) ~= data_task1.trial(trl).repo_red(1)
%                         switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);
%                         break
%                     elseif data_task1.trial(trl).repo_blue(sample) ~= data_task1.trial(trl).repo_blue(1)
%                         switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);;
%                         break
%                     end
                    if data_task3.trial(trl).repo_red(sample) == 1 && data_task3.trial(trl).repo_red(sample+1) == 0
                        switch_timing = data_task3.trial(trl).tSample_from_time_start(sample) - data_task3.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_task3 = [binoriv_timing_task3 switch_timing];
                        continue
                    elseif data_task3.trial(trl).repo_blue(sample) == 1 && data_task3.trial(trl).repo_blue(sample+1) == 0
                        switch_timing = data_task3.trial(trl).tSample_from_time_start(sample) - data_task3.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_task3 = [binoriv_timing_task3 switch_timing];
                        continue
                    end
                end            
            % Phys
            elseif data_task3.trial(trl).stimulus == 2 || data_task3.trial(trl).stimulus == 3
%                 if numel(data_task3.trial(trl).chopping_label) == 2
                    for sample = 1:data_task3.trial(trl).counter-1
    %                     if data_task3.trial(trl).repo_red(sample) ~= data_task3.trial(trl).repo_red(1)
    %                         switch_timing = data_task3.trial(trl).tSample_from_time_start(sample) - data_task3.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     elseif data_task3.trial(trl).repo_blue(sample) ~= data_task3.trial(trl).repo_blue(1)
    %                         switch_timing = data_task3.trial(trl).tSample_from_time_start(sample) - data_task3.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     end
                        if data_task3.trial(trl).repo_red(sample) == 1 && data_task3.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data_task3.trial(trl).tSample_from_time_start(sample) - data_task3.trial(trl).tSample_from_time_start(1);
                            phys_timing_task3 = [phys_timing_task3 switch_timing];
                            continue
                        elseif data_task3.trial(trl).repo_blue(sample) == 1 && data_task3.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data_task3.trial(trl).tSample_from_time_start(sample) - data_task3.trial(trl).tSample_from_time_start(1);
                            phys_timing_task3 = [phys_timing_task3 switch_timing];
                            continue
                        end
                    end
%                 end
            end            
        end
    end
    
    % task 4
    if ~exist(['data_task4/' data_dir_task1(subj).name])
        continue
    end
    subj_dir_task4 = dir(['data_task4/' data_dir_task1(subj).name '/*.mat']);
    for file = 1:numel(subj_dir_task4)
        data_task4 = load(['data_task4/' data_dir_task1(subj).name '/' subj_dir_task4(file).name]);
        
        for trl = 18:numel(data_task4.trial)-1
%             switch_timing = NaN;
            % Binoriv 
            if data_task4.trial(trl).stimulus == 4 %&& numel(data_task1.trial(trl).chopping_label) == 2
                for sample = 1:data_task4.trial(trl).counter-1
%                     if data_task1.trial(trl).repo_red(sample) ~= data_task1.trial(trl).repo_red(1)
%                         switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);
%                         break
%                     elseif data_task1.trial(trl).repo_blue(sample) ~= data_task1.trial(trl).repo_blue(1)
%                         switch_timing = data_task1.trial(trl).tSample_from_time_start(sample) - data_task1.trial(trl).tSample_from_time_start(1);;
%                         break
%                     end
                    if data_task4.trial(trl).repo_red(sample) == 1 && data_task4.trial(trl).repo_red(sample+1) == 0
                        switch_timing = data_task4.trial(trl).tSample_from_time_start(sample) - data_task4.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_task4 = [binoriv_timing_task4 switch_timing];
                        continue
                    elseif data_task4.trial(trl).repo_blue(sample) == 1 && data_task4.trial(trl).repo_blue(sample+1) == 0
                        switch_timing = data_task4.trial(trl).tSample_from_time_start(sample) - data_task4.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_task4 = [binoriv_timing_task4 switch_timing];
                        continue
                    end
                end            
            % Phys
            elseif data_task4.trial(trl).stimulus == 2 || data_task4.trial(trl).stimulus == 3
%                 if numel(data_task4.trial(trl).chopping_label) == 2
                    for sample = 1:data_task4.trial(trl).counter-1
    %                     if data_task4.trial(trl).repo_red(sample) ~= data_task4.trial(trl).repo_red(1)
    %                         switch_timing = data_task4.trial(trl).tSample_from_time_start(sample) - data_task4.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     elseif data_task4.trial(trl).repo_blue(sample) ~= data_task4.trial(trl).repo_blue(1)
    %                         switch_timing = data_task4.trial(trl).tSample_from_time_start(sample) - data_task4.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     end
                        if data_task4.trial(trl).repo_red(sample) == 1 && data_task4.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data_task4.trial(trl).tSample_from_time_start(sample) - data_task4.trial(trl).tSample_from_time_start(1);
                            phys_timing_task4 = [phys_timing_task4 switch_timing];
                            continue
                        elseif data_task4.trial(trl).repo_blue(sample) == 1 && data_task4.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data_task4.trial(trl).tSample_from_time_start(sample) - data_task4.trial(trl).tSample_from_time_start(1);
                            phys_timing_task4 = [phys_timing_task4 switch_timing];
                            continue
                        end
                    end
%                 end
            end            
        end
        
        %% data store
        subj_num = subj_num + 1;
        
        % Switch effect
        table_count_switchEffect = table_count_switchEffect + 1;
        preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'PCT_binoriv', binoriv_timing_task1, 'PCT_binoriv_mean', median(binoriv_timing_task1),...
            'PCT_phys', phys_timing_task1, 'PCT_phys_mean', median(phys_timing_task1)); % PCT: Percept Changed Timing
        table_count_switchEffect = table_count_switchEffect + 1;
        preprocessedData_switchEffect(table_count_switchEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'PCT_binoriv', binoriv_timing_task2, 'PCT_binoriv_mean', median(binoriv_timing_task2),...
            'PCT_phys', phys_timing_task2, 'PCT_phys_mean', median(phys_timing_task2));
        
        % FPj effect
        table_count_FPjEffect = table_count_FPjEffect + 1;
        preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'PCT_binoriv', binoriv_timing_task2, 'PCT_binoriv_mean', median(binoriv_timing_task2),...
            'PCT_phys', phys_timing_task2, 'PCT_phys_mean', median(phys_timing_task2));
        table_count_FPjEffect = table_count_FPjEffect + 1;
        preprocessedData_FPjEffect(table_count_FPjEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'PCT_binoriv', binoriv_timing_task3, 'PCT_binoriv_mean', median(binoriv_timing_task3),...
            'PCT_phys', phys_timing_task3, 'PCT_phys_mean', median(phys_timing_task3));
        
        % Saccade effect
        table_count_SacEffect = table_count_SacEffect + 1;
        preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'PCT_binoriv', binoriv_timing_task2, 'PCT_binoriv_mean', median(binoriv_timing_task2),...
            'PCT_phys', phys_timing_task2, 'PCT_phys_mean', median(phys_timing_task2));
        table_count_SacEffect = table_count_SacEffect + 1;
        preprocessedData_SacEffect(table_count_SacEffect,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'PCT_binoriv', binoriv_timing_task4, 'PCT_binoriv_mean', median(binoriv_timing_task4),...
            'PCT_phys', phys_timing_task4, 'PCT_phys_mean', median(phys_timing_task4));
        
        % Interaction
        table_count_interaction = table_count_interaction + 1;
        preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 1, 'WithSaccade', 1, 'WithFPj', 1, 'PCT_binoriv', binoriv_timing_task1, 'PCT_binoriv_mean', median(binoriv_timing_task1),...
            'PCT_phys', phys_timing_task1, 'PCT_phys_mean', median(phys_timing_task1)); % PCT: Percept Changed Timing
        table_count_interaction = table_count_interaction + 1;
        preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 2, 'WithSaccade', 0, 'WithFPj', 0, 'PCT_binoriv', binoriv_timing_task2, 'PCT_binoriv_mean', median(binoriv_timing_task2),...
            'PCT_phys', phys_timing_task2, 'PCT_phys_mean', median(phys_timing_task2));
        table_count_interaction = table_count_interaction + 1;
        preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 3, 'WithSaccade', 0, 'WithFPj', 1, 'PCT_binoriv', binoriv_timing_task3, 'PCT_binoriv_mean', median(binoriv_timing_task3),...
            'PCT_phys', phys_timing_task3, 'PCT_phys_mean', median(phys_timing_task3));
        table_count_interaction = table_count_interaction + 1;
        preprocessedData_interaction(table_count_interaction,:) = struct('Individual', data_dir_task1(subj).name, 'SubjectID', subj_num,...
            'Task', 4, 'WithSaccade', 1, 'WithFPj', 0, 'PCT_binoriv', binoriv_timing_task4, 'PCT_binoriv_mean', median(binoriv_timing_task4),...
            'PCT_phys', phys_timing_task4, 'PCT_phys_mean', median(phys_timing_task4));
        
        
    end
            
end

%% LME analysis 
% data cleaning
preprocessedData_switchEffect_table=struct2table(preprocessedData_switchEffect);
% preprocessedData_switchEffect_table.WithSaccade = categorical(preprocessedData_switchEffect_table.WithSaccade);
% preprocessedData_switchEffect_table.WithFPj = categorical(preprocessedData_switchEffect_table.WithFPj);
% preprocessedData_switchEffect_table.Task = categorical(preprocessedData_switchEffect_table.Task);
% preprocessedData_switchEffect_table.SubjectID = categorical(preprocessedData_switchEffect_table.SubjectID);
preprocessedData_switchEffect_table.PCT_binoriv_mean = double(preprocessedData_switchEffect_table.PCT_binoriv_mean);
rowsToRemove = strcmp(preprocessedData_switchEffect_table.Individual, 'Annalena');
preprocessedData_switchEffect_table(rowsToRemove, :) = [];

preprocessedData_FPjEffect_table=struct2table(preprocessedData_FPjEffect);
% preprocessedData_FPjEffect_table.WithSaccade = categorical(preprocessedData_FPjEffect_table.WithSaccade);
% preprocessedData_FPjEffect_table.WithFPj = categorical(preprocessedData_FPjEffect_table.WithFPj);
% preprocessedData_FPjEffect_table.Task = categorical(preprocessedData_FPjEffect_table.Task);
% preprocessedData_FPjEffect_table.SubjectID = categorical(preprocessedData_FPjEffect_table.SubjectID);
preprocessedData_FPjEffect_table.PCT_binoriv_mean = double(preprocessedData_FPjEffect_table.PCT_binoriv_mean);

preprocessedData_SacEffect_table=struct2table(preprocessedData_SacEffect);
% preprocessedData_SacEffect_table.WithSaccade = categorical(preprocessedData_SacEffect_table.WithSaccade);
% preprocessedData_SacEffect_table.WithFPj = categorical(preprocessedData_SacEffect_table.WithFPj);
% preprocessedData_SacEffect_table.Task = categorical(preprocessedData_SacEffect_table.Task);
% preprocessedData_SacEffect_table.SubjectID = categorical(preprocessedData_SacEffect_table.SubjectID);
preprocessedData_SacEffect_table.PCT_binoriv_mean = double(preprocessedData_SacEffect_table.PCT_binoriv_mean);

preprocessedData_interaction_table=struct2table(preprocessedData_interaction);
% preprocessedData_interaction_table.WithSaccade = categorical(preprocessedData_interaction_table.WithSaccade);
% preprocessedData_interaction_table.WithFPj = categorical(preprocessedData_interaction_table.WithFPj);
% preprocessedData_interaction_table.Task = categorical(preprocessedData_interaction_table.Task);
% preprocessedData_interaction_table.SubjectID = categorical(preprocessedData_interaction_table.SubjectID);
preprocessedData_interaction_table.PCT_binoriv_mean = double(preprocessedData_interaction_table.PCT_binoriv_mean);
rowsToRemove = strcmp(preprocessedData_interaction_table.Individual, 'Annalena') & preprocessedData_interaction_table.Task==1;
preprocessedData_interaction_table(rowsToRemove, :) = [];

% Effect of percept switch after FPj
lme_switchEffect = fitlme(preprocessedData_switchEffect_table, 'PCT_binoriv_mean ~ Task + (1|SubjectID)');
disp(lme_switchEffect);
randomEffects(lme_switchEffect)

% FPj effect
lme_FPjEffect = fitlme(preprocessedData_FPjEffect_table, 'PCT_binoriv_mean ~ Task + (1|SubjectID)');
disp(lme_FPjEffect);
randomEffects(lme_FPjEffect)

% Saccade effect
lme_SacEffect = fitlme(preprocessedData_SacEffect_table, 'PCT_binoriv_mean ~ Task + (1|SubjectID)');
disp(lme_SacEffect);
randomEffects(lme_SacEffect)

% Saccade+FPj effect
lme_interaction = fitlme(preprocessedData_interaction_table, 'PCT_binoriv_mean ~ WithSaccade*WithFPj + (1|SubjectID)');
disp(lme_interaction);
randomEffects(lme_interaction)

