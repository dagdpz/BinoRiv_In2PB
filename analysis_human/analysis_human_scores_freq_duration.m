% Author: Ryo Segawa (whizznihil.kid@gmail.com)
% Plot all trials to the fixation point switch, for all physical trials, and all rivalry trials, relative to the start of the red and blue percept. 
function analysis_human_scores_freq_duration()

clear all
close all

task_number = 2;
subject = 1;

data_dir = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(task_number)]);
% data_dir = dir(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task4']);
data_dir = data_dir(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir.name})); % avoid '.' and '..'

trial_count = 8;
all_trials = 0;
fig_dir = ['figures'];
mkdir(fig_dir)

duration_red_allSubj = [];
duration_blue_allSubj = [];

for subj = 1:numel(data_dir)
% for subj = subject:subject

    duration_binoriv = 0;
    switch_red = 0;
    switch_blue = 0;
    duration_red = [];
    duration_blue = [];
    duration_red_phys = [];
    duration_blue_phys = [];
    
    mkdir([fig_dir '/' data_dir(subj).name])
    subj_fig_dir = ([fig_dir '/' data_dir(subj).name]);
    

    subj_dir = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(task_number) '/' data_dir(subj).name '/*.mat']);
%     subj_dir = dir(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task4/' data_dir(subj).name]);
    for file = 1:numel(subj_dir)
        data = load(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(task_number) '/' data_dir(subj).name '/' subj_dir(file).name]);
%         data = load(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task4/' data_dir(subj).name]);


        % Outlier triad exclusion
        trial_count_forOutlier = trial_count*2;
        outlier_trials = [];
        for trl = 18:numel(data.trial)-17 
    %     for trl = 1:numel(data.trial)-1 
            if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3 || data.trial(trl).stimulus == 4
                if data.trial(trl).success == 0
                    trial_count_forOutlier = trial_count_forOutlier - 1;
                end

                if (data.trial(trl+1).stimulus == 1 || data.trial(trl+1).stimulus == 5) && trial_count_forOutlier == 1
                    outlier_trials = [outlier_trials (trl-trial_count*2+1:trl+1)];
                    trial_count_forOutlier = trial_count*2;
                elseif (data.trial(trl+1).stimulus == 1 || data.trial(trl+1).stimulus == 5) && trial_count_forOutlier ~= 1
                    trial_count_forOutlier = trial_count*2;
                end
            end
        end
        data.trial(outlier_trials) = [];
        
        
        %% Extract data 
        all_subj_time = [];
        all_subj_stimulus_label = [];
        all_subj_repo_red = [];
        all_subj_repo_blue = [];
        all_subj_button_switch = [];

        % Get data
%         for trl = 1:numel(data.trial) 
        for trl = 18:numel(data.trial) 
            if ~isempty(data.trial(trl).stimulus) % emergency measure
                if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3 || data.trial(trl).stimulus == 4 %&& data.trial(trl).success == 1% emergency measure
                    all_subj_stimulus_label = vertcat(all_subj_stimulus_label, repmat(data.trial(trl).stimulus, data.trial(trl).counter, 1));
                    all_subj_time = vertcat(all_subj_time, data.trial(trl).tSample_from_time_start);
                    all_subj_repo_red = vertcat(all_subj_repo_red, data.trial(trl).repo_red);
                    all_subj_repo_blue = vertcat(all_subj_repo_blue, data.trial(trl).repo_blue);
                end
            end
            
            % Get the duration of binoriv cond.
            try
                if data.trial(trl).stimulus == 4 && data.trial(trl-1).stimulus ~= 4
                    block_start = data.trial(trl).tSample_from_time_start(1);
                elseif data.trial(trl).stimulus == 4 && data.trial(trl+1).stimulus ~= 4
                    block_end = data.trial(trl).tSample_from_time_start(end);
                    duration_binoriv = duration_binoriv + (block_end - block_start);
                end
            catch
            end
            % in case of dir('data_sameFPs_block')
            try
                if data.trial(trl-1).stimulus ~= 4 && data.trial(trl).stimulus == 4 && data.trial(trl+1).stimulus ~= 4 % in case of dir('data_sameFPs_block')
                    block_start = data.trial(trl).tSample_from_time_start(1);
                    block_end = data.trial(trl).tSample_from_time_start(end);
                    duration_binoriv = duration_binoriv + (block_end - block_start);
                end
            catch
            end
                        
            % Get duration of Phys cond. with trial-based
%             if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3
%                 if data.trial(trl).success == 1 && numel(data.trial(trl).chopping_label) == 2
%                     percept_start_red = [];
%                     percept_start_blue = [];
%                     percept_end_red = [];
%                     percept_end_blue = [];
%                     for sample = 1:data.trial(trl).counter
%                         % Report blue -> red
%                         if sample == 1 && data.trial(trl).repo_red(sample) == 1 
%                             percept_start_red = [percept_start_red data.trial(trl).tSample_from_time_start(1)];
%                         elseif sample == 1 && data.trial(trl).repo_blue(sample) == 1
%                             percept_start_blue = [percept_start_blue data.trial(trl).tSample_from_time_start(1)];
%                         end
%                         if sample == 1
%                             continue
%                         end
% 
%                         if data.trial(trl).repo_red(sample-1) == 0 && data.trial(trl).repo_red(sample) == 1
%                             percept_start_red = [percept_start_red data.trial(trl).tSample_from_time_start(sample)];
%                         elseif data.trial(trl).repo_blue(sample-1) == 0 && data.trial(trl).repo_blue(sample) == 1
%                             percept_start_blue = [percept_start_blue data.trial(trl).tSample_from_time_start(sample)];
%                         end
%                         if data.trial(trl).repo_red(sample-1) == 1 && data.trial(trl).repo_red(sample) == 0
%                             percept_end_red = [percept_end_red data.trial(trl).tSample_from_time_start(sample)];
%                         elseif data.trial(trl).repo_blue(sample-1) == 1 && data.trial(trl).repo_blue(sample) == 0
%                             percept_end_blue = [percept_end_blue data.trial(trl).tSample_from_time_start(sample)];
%                         end
% 
%                         if sample == data.trial(trl).counter && data.trial(trl).repo_red(end) == 1
%                             percept_end_red = [percept_end_red data.trial(trl).tSample_from_time_start(end)];
%                         elseif sample == data.trial(trl).counter && data.trial(trl).repo_blue(end) == 1
%                             percept_end_blue = [percept_end_blue data.trial(trl).tSample_from_time_start(end)];
%                         end
%                     end
% 
%                     if ~isempty(percept_start_red)
%                         for ite = 1:numel(percept_start_red)
%                             duration_red_phys = [duration_red_phys percept_end_red(ite)-percept_start_red(ite)];
%                         end
%                     elseif ~isempty(percept_start_blue)
%                         for ite = 1:numel(percept_start_blue)
%                             duration_blue_phys = [duration_blue_phys percept_end_blue(ite)-percept_start_blue(ite)];
%                         end
%                     end     
%                 end
%             end
            
        end

        % get labels whether button switched
        for sample = 1:numel(all_subj_time)
            if sample == 1
                all_subj_button_switch = vertcat(all_subj_button_switch, 0);
                continue
            end

            % all_subj_button_switch = 1: red onset, -1: red offset, 2: blue onset, -2: blue offset, -3: pressed both onset
            try
                if all_subj_repo_red(sample) == 1 && all_subj_repo_blue(sample) == 1 && all_subj_repo_red(sample+1) == 0 && all_subj_repo_blue(sample+1) == 1
                    all_subj_button_switch = vertcat(all_subj_button_switch, -1);
                    continue
                elseif all_subj_repo_red(sample) == 1 && all_subj_repo_blue(sample) == 1 && all_subj_repo_red(sample+1) == 1 && all_subj_repo_blue(sample+1) == 0
                    all_subj_button_switch = vertcat(all_subj_button_switch, -2);
                    continue
                end
            catch
            end
            if all_subj_repo_red(sample-1) == 0 && all_subj_repo_red(sample) == 1 %&& ~strcmp(latest_colour, 'Red')
                all_subj_button_switch = vertcat(all_subj_button_switch, 1);
                continue
            elseif all_subj_repo_red(sample-1) == 1 && all_subj_repo_red(sample) == 0
                all_subj_button_switch = vertcat(all_subj_button_switch, -1);
                continue
            elseif all_subj_repo_blue(sample-1) == 0 && all_subj_repo_blue(sample) == 1 %&& ~strcmp(latest_colour, 'Blue')
                all_subj_button_switch = vertcat(all_subj_button_switch, 2);
                continue
            elseif all_subj_repo_blue(sample-1) == 1 && all_subj_repo_blue(sample) == 0
                all_subj_button_switch = vertcat(all_subj_button_switch, -2);
                continue
            end

            if all_subj_repo_red(sample) == 0 && all_subj_repo_blue(sample) == 0
                all_subj_button_switch = vertcat(all_subj_button_switch, 0);
                continue
            end
            all_subj_button_switch = vertcat(all_subj_button_switch, 0);
        end

        for sample = 2:numel(all_subj_time)
            % Binoriv
            if all_subj_stimulus_label(sample) == 4
                % Report blue -> red
                if all_subj_button_switch(sample) == 1
                    switch_red = switch_red + 1;
                    
                    onset_label = sample;
                    try
                        offset_label = find(all_subj_button_switch == -1 | all_subj_button_switch == -3);% | all_subj_stimulus_label ~= 4);
                        offset_label = offset_label(offset_label > onset_label);
                        offset_label = offset_label(1);
                        time_series_present = all_subj_time(onset_label:offset_label) - all_subj_time(onset_label);
                        over_border = false;
                        for moment = 2:numel(time_series_present) % in case triads border
                            if (time_series_present(moment)-time_series_present(moment-1)) > 5
                                over_border = true;
                            end
                        end
                        if over_border; continue; end
                        duration_red = [duration_red all_subj_time(offset_label)-all_subj_time(onset_label)];
                    catch
                        continue
                    end

                    
                % Report red -> blue
                elseif all_subj_button_switch(sample) == 2
                    switch_blue = switch_blue + 1;
                    
                    onset_label = sample;
                    try
                        offset_label = find(all_subj_button_switch == -2 | all_subj_button_switch == -3);% | all_subj_stimulus_label ~= 4);
                        offset_label = offset_label(offset_label > onset_label);
                        offset_label = offset_label(1);
                        time_series_present = all_subj_time(onset_label:offset_label) - all_subj_time(onset_label);
                        over_border = false;
                        for moment = 2:numel(time_series_present) % in case triads border
                            if (time_series_present(moment)-time_series_present(moment-1)) > 5
                                over_border = true;
                            end
                        end
                        if over_border; continue; end
                        duration_blue = [duration_blue all_subj_time(offset_label)-all_subj_time(onset_label)];
                    catch
                        continue
                    end
                    
                end
                
            % Phys
            elseif all_subj_stimulus_label(sample) == 2 || all_subj_stimulus_label(sample) == 3
                % Report blue -> red
                if all_subj_button_switch(sample) == 1                    
                    onset_label = sample;
                    if all_subj_stimulus_label(onset_label) ~= 2 % Only successful for phys
                        continue
                    end
                        
                    try
                        offset_label = find(all_subj_button_switch == -1 | all_subj_button_switch == -3); % | all_subj_stimulus_label == 4);
                        offset_label = offset_label(offset_label > onset_label);
                        offset_label = offset_label(1);
                        time_series_present = all_subj_time(onset_label:offset_label) - all_subj_time(onset_label);
                        over_border = false;
                        for moment = 2:numel(time_series_present) % in case triads border
                            if (time_series_present(moment)-time_series_present(moment-1)) > 5
                                over_border = true;
                            end
                        end
                        if over_border; continue; end
                        duration_red_phys = [duration_red_phys all_subj_time(offset_label)-all_subj_time(onset_label)];
                    catch
                        continue
                    end

                    
                % Report red -> blue
                elseif all_subj_button_switch(sample) == 2                    
                    onset_label = sample;
                    if all_subj_stimulus_label(onset_label) ~= 3 % Only successful for phys
                        continue
                    end
                    
                    try
                        offset_label = find(all_subj_button_switch == -2 | all_subj_button_switch == -3); % | all_subj_stimulus_label == 4);
                        offset_label = offset_label(offset_label > onset_label);
                        offset_label = offset_label(1);
                        time_series_present = all_subj_time(onset_label:offset_label) - all_subj_time(onset_label);
                        over_border = false;
                        for moment = 2:numel(time_series_present) % in case triads border
                            if (time_series_present(moment)-time_series_present(moment-1)) > 5
                                over_border = true;
                            end
                        end
                        if over_border; continue; end
                        duration_blue_phys = [duration_blue_phys all_subj_time(offset_label)-all_subj_time(onset_label)];
                    catch
                        continue
                    end
                    
                end 
            end
        end
    end
    
    fprintf('\nWho?: %s \n', data_dir(subj).name)
    %% Calculation
    % Define the bin edges
    binEdges = 0:0.5:40;
    
    % Switch rate per time in BinoRiv cond. [all trials]
    rate_switch = (switch_red + switch_blue)/duration_binoriv;
    fprintf('\n[Switch rate per time] \n%.03f times/sec \n', rate_switch)
    fprintf('\n[Time per perceptual switch] \n%.01f sec/switch \n', 1/rate_switch)
    
    % Duration of percepts in BinoRiv cond. [all trials]
    fprintf('\n[Mean of duration of percept] \n%.01f sec \n', (sum(duration_red)+sum(duration_blue))/(numel(duration_red)+numel(duration_blue)))
    fprintf('\n[Mean of duration of percept for red] \n%.01f sec \n', sum(duration_red)/numel(duration_red))
    fprintf('\n[Mean of duration of percept for blue] \n%.01f sec \n', sum(duration_blue)/numel(duration_blue))
    figure;
%     histogram(duration_red,25, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(duration_blue,25, 'FaceAlpha', 0.5, 'FaceColor', [0.1 0.1 1])
    histData_binoriv_red = histcounts(duration_red, binEdges);
    histData_binoriv_blue = histcounts(duration_blue, binEdges);
    bar(binEdges(1:end-1) + diff(binEdges)/2, histData_binoriv_red, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
    bar(binEdges(1:end-1) + diff(binEdges)/2, histData_binoriv_blue, 'FaceAlpha', 0.5, 'FaceColor', [0.1 0.1 1]);
    bino_dur = [duration_red duration_blue];
    xline(mean(bino_dur),'--',{'mean'})
    xline(median(bino_dur),'--',{'median'})
    xlabel('Duration of percept [s]')
    xlim([0 25])
    title(['Percept duration for BinoRiv of task ' num2str(task_number)...
        ', Num of data: ' num2str(numel(duration_red)+numel(duration_blue))])
    filename = [subj_fig_dir '/Percept_duration_histogram_task' num2str(task_number) '.png'];
    saveas(gcf,filename)
    filename = [subj_fig_dir '/Percept_duration_histogram_task' num2str(task_number) '.fig'];
    saveas(gcf,filename)
    duration_red_allSubj = [duration_red_allSubj duration_red];
    duration_blue_allSubj = [duration_blue_allSubj duration_blue];

    
    % Duration of percepts in Phys cond. [all trials]
    figure;
%     histogram(duration_red_phys,25, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
%     histogram(duration_blue_phys,25, 'FaceAlpha', 0.5, 'FaceColor', [0.1 0.1 1])
    histData_phys_red = histcounts(duration_red_phys, binEdges);
    histData_phys_blue = histcounts(duration_blue_phys, binEdges);
    bar(binEdges(1:end-1) + diff(binEdges)/2, histData_phys_red, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
    bar(binEdges(1:end-1) + diff(binEdges)/2, histData_phys_blue, 'FaceAlpha', 0.5, 'FaceColor', [0.1 0.1 1]);
    phys_dur = [duration_red_phys duration_blue_phys];
    xline(mean(phys_dur),'--',{'mean'})
    xline(median(phys_dur),'--',{'median'})
    xlabel('Duration of percept [s]')
    xlim([0 25])
    title(['Percept duration for Phys of task ' num2str(task_number)...
        ', Num of data: ' num2str(numel(duration_red_phys)+numel(duration_blue_phys))])
    filename = [subj_fig_dir '/Percept_duration_histogram_phys_task' num2str(task_number) '.png'];
    saveas(gcf,filename)
    filename = [subj_fig_dir '/Percept_duration_histogram_phys_task' num2str(task_number) '.fig'];
    saveas(gcf,filename)

end

% Duration of percepts in BinoRiv cond. [all trials]
fprintf('\n[Mean of duration of percept across all subj] \n%.01f sec \n', (sum(duration_red_allSubj)+sum(duration_blue_allSubj))/(numel(duration_red_allSubj)+numel(duration_blue_allSubj)))
fprintf('\n[Mean of duration of percept for red all subj] \n%.01f sec \n', sum(duration_red_allSubj)/numel(duration_red_allSubj))
fprintf('\n[Mean of duration of percept for blue all subj] \n%.01f sec \n', sum(duration_blue_allSubj)/numel(duration_blue_allSubj))

