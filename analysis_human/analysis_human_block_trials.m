% Author: Ryo Segawa (whizznihil.kid@gmail.com)
% need modification for task 4
function analysis_human_block_trials()

clear all
close all

task_number = 4;
subject = 1;

data_dir = dir(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task' num2str(task_number)]);
% data_dir = dir('data_task2');

data_dir = data_dir(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir.name})); % avoid '.' and '..'

trial_count = 8;
all_trials = 0;
fig_dir = ['figures'];
mkdir(fig_dir)

% For button pressing plot
triad_former = [];
triad_latter = [];
num_superblock = 5;
num_triad = 12;
num_trial = 8;
for spb = 1:num_superblock
    for trd = 1:num_triad
        for trl = 1:num_trial*2
            if spb == 1  
                if trl < num_trial+1
                    triad_former = vertcat(triad_former, ((1+num_trial*2+1)*(trd-1))+1+trl);
                else
                    triad_latter = vertcat(triad_latter, ((1+num_trial*2+1)*(trd-1))+1+trl);
                end

            else
                if trl < num_trial+1
                    triad_former = vertcat(triad_former, ((1+num_trial*2+1)*num_triad*(spb-1))+(1+num_trial*2+1)*(trd-1)+1+trl);
                else
                    triad_latter = vertcat(triad_latter, ((1+num_trial*2+1)*num_triad*(spb-1))+(1+num_trial*2+1)*(trd-1)+1+trl);
                end
            end
        end
    end
end

% for subj = 1:numel(data_dir)
for subj = subject:subject
    close all
    
    triad_counter = 1;
    
    trial_count = num_trial;
    repo_red_begin = [];
    repo_red_end = [];
    repo_blue_begin = [];
    repo_blue_end = [];
    
    mkdir([fig_dir '/' data_dir(subj).name])
    subj_fig_dir = ([fig_dir '/' data_dir(subj).name]);
    
%     subj_dir = dir(['data_task2/' data_dir(subj).name '/*.mat']);
    subj_dir = dir(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task' num2str(task_number) '/']);
    subj_dir = subj_dir(~cellfun(@(x) any(regexp(x, '^\.+$')), {subj_dir.name})); % avoid '.' and '..'

    for file = 1:numel(subj_dir)
%         data = load(['data_task2/' data_dir(subj).name '/' subj_dir(file).name]);
        data = load(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task' num2str(task_number) '/' data_dir(subj).name]);

        
        trl_adjustor = 0; % emergency measure 02/Dec
        if file ~= 1
            total_trl = trl;
        else
            total_trl = 0;
        end
        for trl = 1:numel(data.trial) % skip the first triad
            total_trl = total_trl + 1;
            if isempty(data.trial(trl).stimulus) || data.trial(trl).stimulus == 1 || data.trial(trl).stimulus == 5
                continue
            elseif isnan(data.trial(trl).repo_red)
                continue
            end
            
            if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3 || data.trial(trl).stimulus == 4
                all_trials = all_trials + 1;
            end
            prediction = NaN;

            %% Get data of button presses per block 
            if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3 % phys -> BinoRiv
    %             if any(find(trl == triad_former)) % if the trial is the former in triad
                if any(find(trl == triad_former-trl_adjustor)) % if the trial is the former in triad % emergency measure 02/Dec
                    figure(2+triad_counter)
                    if trial_count == 8
%                         plot_zero_time = data.trial(trl).states_onset(1);
                        plot_zero_time = data.trial(trl).tSample_from_time_start(1);
                    end

                    % Get timing
                    if data.trial(trl-1).repo_red(end) == 1 && data.trial(trl).repo_red(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        repo_red_begin = vertcat(repo_red_begin, time_series_present);
                    elseif data.trial(trl-1).repo_red(end) == 0 && data.trial(trl).repo_red(1) == 1
                        time_series_present = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
                        repo_red_begin = vertcat(repo_red_begin, time_series_present);
                    elseif data.trial(trl-1).repo_blue(end) == 1 && data.trial(trl).repo_blue(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                    elseif data.trial(trl-1).repo_blue(end) == 0 && data.trial(trl).repo_blue(1) == 1
                        time_series_present = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
                        repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                    end

                    for moment = 1:data.trial(trl).counter
                        try
                            if data.trial(trl).repo_red(moment-1) == 0 && data.trial(trl).repo_red(moment) == 1
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_red_begin = vertcat(repo_red_begin, time_series_present);
                            elseif data.trial(trl).repo_red(moment-1) == 1 && data.trial(trl).repo_red(moment) == 0
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_red_end = vertcat(repo_red_end, time_series_present);
                            elseif data.trial(trl).repo_blue(moment-1) == 0 && data.trial(trl).repo_blue(moment) == 1
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                            elseif data.trial(trl).repo_blue(moment-1) == 1 && data.trial(trl).repo_blue(moment) == 0
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_blue_end = vertcat(repo_blue_end, time_series_present);
                            end
                        catch
                        end
                    end
                    % if data.trial(trl).repo_red == 1
                    %     repo_red_begin = vertcat(repo_red_begin, data.trial(trl).tSample_from_time_start(1) - plot_zero_time);
                    %     repo_red_end = vertcat(repo_red_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time);
                    % elseif data.trial(trl).repo_blue == 1
                    %     repo_blue_begin = vertcat(repo_blue_begin, data.trial(trl).tSample_from_time_start(1) - plot_zero_time);
                    %     repo_blue_end = vertcat(repo_blue_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time);
                    % end

                    % Paint areas
                    if height(repo_red_begin) > height(repo_red_end) %  Button had been pressed till the end
                        for max_index = 1:height(repo_red_end)
                            area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                        trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time;
                        area([repo_red_begin(height(repo_red_begin)) trial_end], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif height(repo_red_begin) < height(repo_red_end) %  Button had been pressed at first already
                        try
                            for max_index = 1:height(repo_red_begin)
                                area([repo_red_begin(max_index) repo_red_end(1+max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                            end
                        catch
                        end
                        trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        area([trial_start repo_red_end(1,1)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    else
                        for max_index = 1:height(repo_red_begin)
                            area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    end
                    if height(repo_blue_begin) > height(repo_blue_end) %  Button had been pressed till the end
                        for max_index = 1:height(repo_blue_end)
                            area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                        trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time;
                        area([repo_blue_begin(height(repo_blue_begin)) trial_end], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif height(repo_blue_begin) < height(repo_blue_end) %  Button had been pressed at first already
                        try
                            for max_index = 1:height(repo_blue_begin)
                                area([repo_blue_begin(max_index) repo_blue_end(1+max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                            end
                        catch
                        end
                        trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        area([trial_start repo_blue_end(1,1)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    else
                        for max_index = 1:height(repo_blue_begin)
                            area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    end

                    % Plot correct switch
                    if task_number == 4
%                         trial_start = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
%                         trial_end = data.trial(trl+1).tSample_from_time_start(1) - plot_zero_time;
                        trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                        if isempty(data.trial(trl+1).states_onset)
                            trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                        else
                            trial_end = data.trial(trl+1).states_onset(1) - plot_zero_time;
                        end
                    else
                        trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                        trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                    end
                    if data.trial(trl).stimulus == 2
                        area([trial_start trial_end], [2.5 2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif data.trial(trl).stimulus == 3
                        area([trial_start trial_end], [1.5 1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    end
                    % fill the gap of the initialised state
%                     try 
%                         if data.trial(trl).stimulus == 2
%                             area([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [2.5 2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5);
%                         elseif data.trial(trl).stimulus == 3
%                             area([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [1.5 1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5);
%                         end
%                     catch
%                     end

                    % Plot raw eye-tracking data
%                     yyaxis right
%                     % time = downsample(data.trial(trl).tSample_from_time_start - plot_zero_time, 64);
%                     % x_eye_pos = downsample(data.trial(trl).x_eye, 64);
%                     % y_eye_pos = downsample(data.trial(trl).y_eye, 64);
%                     time = data.trial(trl).tSample_from_time_start - plot_zero_time;
%                     x_eye_pos = data.trial(trl).x_eye;
%                     y_eye_pos = data.trial(trl).y_eye;
%                     plot_x_eye = plot(time, x_eye_pos, '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
%                     plot_y_eye = plot(time, y_eye_pos, '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
%                     try % fill the gap between two trials
%                         plot_x_eye_connect = plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [data.trial(trl-1).x_eye(data.trial(trl-1).counter) data.trial(trl).x_eye(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
%                         plot_y_eye_connect = plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [data.trial(trl-1).y_eye(data.trial(trl-1).counter) data.trial(trl).y_eye(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
%                     end
%                     yyaxis left
                    
                    % Plot eye-tracking data as dist. from FPs
                    yyaxis right
                    time_series_present = data.trial(trl).tSample_from_time_start - plot_zero_time;
                    x_eye_present = data.trial(trl).x_eye;
                    y_eye_present = data.trial(trl).y_eye;
                    
                    % For red
                    if data.trial(trl).stimulus == 2
                        if task_number == 4
                            time_series_present = data.trial(trl).tSample_from_time_start - plot_zero_time;
                            x_eye_present = data.trial(trl).x_eye;
                            y_eye_present = data.trial(trl).y_eye;
        %                     x_fp_present = data.trial(trl).eye.x.red;
        %                     y_fp_present = data.trial(trl).eye.y.red;
                            x_fp_present = data.trial(trl).eye.fix.x.red;
                            y_fp_present = data.trial(trl).eye.fix.y.red;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2,  'color', 'r');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'r');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
        %                         x_fp_before = data.trial(trl-1).eye.x.red;
        %                         y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
                            end
                            % For the other FP
        %                     x_fp_present = data.trial(trl).eye.x.blue;
        %                     y_fp_present = data.trial(trl).eye.y.blue;
                            x_fp_present = data.trial(trl).eye.fix.x.blue;
                            y_fp_present = data.trial(trl).eye.fix.y.blue;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
        %                         x_fp_before = data.trial(trl-1).eye.x.red;
        %                         y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(end)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
                            end
                        else
    %                         x_fp_present = data.trial(trl).eye.x.red;
    %                         y_fp_present = data.trial(trl).eye.y.red;
                            x_fp_present = data.trial(trl).eye.fix.x.red;
                            y_fp_present = data.trial(trl).eye.fix.y.red;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2,  'color', 'r');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'r');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
    %                             x_fp_before = data.trial(trl-1).eye.x.red;
    %                             y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
                            end
                        end
                    end
                    % For blue
                    if data.trial(trl).stimulus == 3
                        if task_number == 4
                            time_series_present = data.trial(trl).tSample_from_time_start - plot_zero_time;
                            x_eye_present = data.trial(trl).x_eye;
                            y_eye_present = data.trial(trl).y_eye;
        %                     x_fp_present = data.trial(trl).eye.x.red;
        %                     y_fp_present = data.trial(trl).eye.y.red;
                            x_fp_present = data.trial(trl).eye.fix.x.red;
                            y_fp_present = data.trial(trl).eye.fix.y.red;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2,  'color', 'r');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'r');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
        %                         x_fp_before = data.trial(trl-1).eye.x.red;
        %                         y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
                            end
                            % For the other FP
        %                     x_fp_present = data.trial(trl).eye.x.blue;
        %                     y_fp_present = data.trial(trl).eye.y.blue;
                            x_fp_present = data.trial(trl).eye.fix.x.blue;
                            y_fp_present = data.trial(trl).eye.fix.y.blue;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
        %                         x_fp_before = data.trial(trl-1).eye.x.red;
        %                         y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
                            end
                        else
    %                         x_fp_present = data.trial(trl).eye.x.blue;
    %                         y_fp_present = data.trial(trl).eye.y.blue;
                            x_fp_present = data.trial(trl).eye.fix.x.blue;
                            y_fp_present = data.trial(trl).eye.fix.y.blue;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
    %                             x_fp_before = data.trial(trl-1).eye.x.red;
    %                             y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
                            end
                        end
                    end
                    yyaxis left

                    % plot FPs onset/offset line
                    if task_number == 4
                        xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                    else
                        if task_number == 1 || task_number == 3
                            if data.trial(trl-1).eye.fix.x.red ~= data.trial(trl).eye.fix.x.red ||...
                                data.trial(trl-1).eye.fix.y.red ~= data.trial(trl).eye.fix.y.red
                                xline(data.trial(trl).states_onset(1) - plot_zero_time, '-')
                            else
                                if data.trial(trl).stimulus ~= data.trial(trl-1).stimulus 
                                    xline(data.trial(trl).states_onset(1) - plot_zero_time, '-')
                                else
                                    xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                                end
                            end
                        else
                            xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                        end
                    end
    %                 xline(data.trial(trl).states_onset(2) - plot_zero_time)
    %                 if any(find(data.trial(trl).states == 19)) % 19 is the aborted state
    %                     xline(data.trial(trl).states_onset(find(data.trial(trl).states == 19)) - plot_zero_time)
    %                     try
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 19))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [3 3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 19))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [-3 -3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                     catch
    %                     end
    %                 elseif any(find(data.trial(trl).states == 20)) % 20 is the success state
    %                     xline(data.trial(trl).states_onset(find(data.trial(trl).states == 20)) - plot_zero_time)
    %                     try
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 20))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [3 3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 20))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [-3 -3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                     catch
    %                     end
    %                 end

                    trial_count = trial_count - 1;
                    repo_red_begin = [];
                    repo_red_end = [];
                    repo_blue_begin = [];
                    repo_blue_end = [];
                    if trial_count == 0
                        trial_count = 8;
                    end
                end % any(find(trl == triad_former)) % if the trial is the former in triad
            elseif data.trial(trl).stimulus == 4 % phys -> BinoRiv
    %             if any(find(trl == triad_latter)) % if the trial is the latter in triad
                if any(find(trl == triad_latter-trl_adjustor)) % if the trial is the latter in triad % emergency measure 02/Dec
                    figure(2+triad_counter)
                    % Get timing
                    if data.trial(trl-1).repo_red(data.trial(trl-1).counter) == 1 && data.trial(trl).repo_red(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(end) - plot_zero_time;
                        repo_red_begin = vertcat(repo_red_begin, time_series_present);
                    elseif data.trial(trl-1).repo_blue(data.trial(trl-1).counter) == 1 && data.trial(trl).repo_blue(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(end) - plot_zero_time;
                        repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                    end

                    for moment = 1:data.trial(trl).counter
                        try
                            if data.trial(trl).repo_red(moment-1) == 0 && data.trial(trl).repo_red(moment) == 1
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_red_begin = vertcat(repo_red_begin, time_series_present);
                            elseif data.trial(trl).repo_red(moment-1) == 1 && data.trial(trl).repo_red(moment) == 0
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_red_end = vertcat(repo_red_end, time_series_present);
                            elseif data.trial(trl).repo_blue(moment-1) == 0 && data.trial(trl).repo_blue(moment) == 1
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                            elseif data.trial(trl).repo_blue(moment-1) == 1 && data.trial(trl).repo_blue(moment) == 0
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_blue_end = vertcat(repo_blue_end, time_series_present);
                            end
                        catch
                        end
                    end
                    % if data.trial(trl).repo_red == 1
                    %     repo_red_begin = vertcat(repo_red_begin, data.trial(trl).tSample_from_time_start(1) - plot_zero_time);
                    %     repo_red_end = vertcat(repo_red_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time);
                    % elseif data.trial(trl).repo_blue == 1
                    %     repo_blue_begin = vertcat(repo_blue_begin, data.trial(trl).tSample_from_time_start(1) - plot_zero_time);
                    %     repo_blue_end = vertcat(repo_blue_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time);
                    % end

                    % Paint areas
                    if height(repo_red_begin) > height(repo_red_end) %  Button had been pressed till the end
                        for max_index = 1:height(repo_red_end)
                            area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                        trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time;
                        area([repo_red_begin(height(repo_red_begin)) trial_end], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif height(repo_red_begin) < height(repo_red_end) %  Button had been pressed at first already
                        try
                            for max_index = 1:height(repo_red_begin)
                                area([repo_red_begin(max_index) repo_red_end(1+max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                            end
                        catch
                        end
                        trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        area([trial_start repo_red_end(1,1)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    else
                        for max_index = 1:height(repo_red_begin)
                            area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    end
                    if height(repo_blue_begin) > height(repo_blue_end) %  Button had been pressed till the end
                        for max_index = 1:height(repo_blue_end)
                            area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                        trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time;
                        area([repo_blue_begin(height(repo_blue_begin)) trial_end], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif height(repo_blue_begin) < height(repo_blue_end) %  Button had been pressed at first already
                        try
                            for max_index = 1:height(repo_blue_begin)
                                area([repo_blue_begin(max_index) repo_blue_end(1+max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                            end
                        catch
                        end
                        trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        area([trial_start repo_blue_end(1,1)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    else
                        for max_index = 1:height(repo_blue_begin)
                            area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    end

                    % Plot correct switch
                    if task_number == 4
%                         trial_start = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
%                         trial_end = data.trial(trl+1).tSample_from_time_start(1) - plot_zero_time;
                        trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                        if isempty(data.trial(trl+1).states_onset)
                            trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                        else
                            trial_end = data.trial(trl+1).states_onset(1) - plot_zero_time;
                        end
                    else
                        trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                        trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                    end
                    area([trial_start trial_end], [0.5 0.5], 'FaceColor', [0.6 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    % fill the gap of the initialised state
%                     try 
%                         area([data.trial(trl-1).tSample_from_time_start(end)-plot_zero_time  data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [0.5 0.5], 'FaceColor', [0.6 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5);
%                     catch
%                     end

                    % Plot raw eye-tracking data
%                     yyaxis right
%                     % time = downsample(data.trial(trl).tSample_from_time_start - plot_zero_time, 64);
%                     % x_eye_pos = downsample(data.trial(trl).x_eye, 64);
%                     % y_eye_pos = downsample(data.trial(trl).y_eye, 64);
%                     time = data.trial(trl).tSample_from_time_start - plot_zero_time;
%                     x_eye_pos = data.trial(trl).x_eye;
%                     y_eye_pos = data.trial(trl).y_eye;
%                     plot_x_eye = plot(time, x_eye_pos, '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
%                     plot_y_eye = plot(time, y_eye_pos, '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
%                     try % fill the gap between two trials
%                         plot_x_eye_connect = plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [data.trial(trl-1).x_eye(data.trial(trl-1).counter) data.trial(trl).x_eye(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
%                         plot_y_eye_connect = plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [data.trial(trl-1).y_eye(data.trial(trl-1).counter) data.trial(trl).y_eye(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
%                     catch
%                     end
%                     yyaxis left
                    
                    % Plot eye-tracking data as dist. from FPs
                    yyaxis right
                    % For red
                    time_series_present = data.trial(trl).tSample_from_time_start - plot_zero_time;
                    x_eye_present = data.trial(trl).x_eye;
                    y_eye_present = data.trial(trl).y_eye;
%                     x_fp_present = data.trial(trl).eye.x.red;
%                     y_fp_present = data.trial(trl).eye.y.red;
                    x_fp_present = data.trial(trl).eye.fix.x.red;
                    y_fp_present = data.trial(trl).eye.fix.y.red;
                    distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                    red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                    within_fix_window = [];
                    for sample = 1:numel(distance_present)
                        if distance_present(sample) <= 1.3
                            within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                        elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2,  'color', 'r');
                            within_fix_window = [];
                        end
                    end
                    if ~isempty(within_fix_window)
                        plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'r');
                    end
                    try % fill the gap between two trials
                        x_eye_before = data.trial(trl-1).x_eye;
                        y_eye_before = data.trial(trl-1).y_eye;
%                         x_fp_before = data.trial(trl-1).eye.x.red;
%                         y_fp_before = data.trial(trl-1).eye.y.red;
                        x_fp_before = data.trial(trl-1).eye.fix.x.red;
                        y_fp_before = data.trial(trl-1).eye.fix.y.red;
                        distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                        plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
                    end
                    % For blue
%                     x_fp_present = data.trial(trl).eye.x.blue;
%                     y_fp_present = data.trial(trl).eye.y.blue;
                    x_fp_present = data.trial(trl).eye.fix.x.blue;
                    y_fp_present = data.trial(trl).eye.fix.y.blue;
                    distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                    blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                    within_fix_window = [];
                    for sample = 1:numel(distance_present)
                        if distance_present(sample) <= 1.3
                            within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                        elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                            within_fix_window = [];
                        end
                    end
                    if ~isempty(within_fix_window)
                        plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                    end
                    try % fill the gap between two trials
                        x_eye_before = data.trial(trl-1).x_eye;
                        y_eye_before = data.trial(trl-1).y_eye;
%                         x_fp_before = data.trial(trl-1).eye.x.red;
%                         y_fp_before = data.trial(trl-1).eye.y.red;
                        x_fp_before = data.trial(trl-1).eye.fix.x.red;
                        y_fp_before = data.trial(trl-1).eye.fix.y.red;
                        distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                        plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
                    end
                    yyaxis left

                    % plot FPs onset/offset line
                    if task_number == 4
                        xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                    else
                        if task_number == 1 || task_number == 3
                            if data.trial(trl-1).eye.fix.x.red ~= data.trial(trl).eye.fix.x.red ||...
                                data.trial(trl-1).eye.fix.y.red ~= data.trial(trl).eye.fix.y.red
                                xline(data.trial(trl).states_onset(1) - plot_zero_time, '-')
                            else
                                if data.trial(trl).stimulus ~= data.trial(trl-1).stimulus 
                                    xline(data.trial(trl).states_onset(1) - plot_zero_time, '-')
                                else
                                    xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                                end
                            end
                        else
                            xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                        end
                    end
    %                 xline(data.trial(trl).states_onset(2) - plot_zero_time)
    %                 if any(find(data.trial(trl).states == 19)) % 19 is the aborted state
    %                     xline(data.trial(trl).states_onset(find(data.trial(trl).states == 19)) - plot_zero_time)
    %                     try
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 19))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [3 3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 19))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [-3 -3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                     catch
    %                     end
    %                 elseif any(find(data.trial(trl).states == 20)) % 20 is the success state
    %                     xline(data.trial(trl).states_onset(find(data.trial(trl).states == 20)) - plot_zero_time)
    %                     try
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 20))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [3 3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 20))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [-3 -3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                     catch
    %                     end
    %                 end

                    % Mark if the prediction is not accurate
                    if prediction == false
                        text(double(trial_start), 0, 'NA')
                    end


                    trial_count = trial_count - 1;
                    repo_red_begin = [];
                    repo_red_end = [];
                    repo_blue_begin = [];
                    repo_blue_end = [];
                    if trial_count == 0
                        trial_count = 8;

                        % for eye-traking plot
%                         yyaxis right
%                         ylim([-3.75 3.75]) 
%                         ax = gca;
%                         ax.YColor = 'k';
%                         ylabel('Distance from centre of stimulus (deg)')
%                         legend([plot_x_eye,plot_y_eye])
%                         yyaxis left
                        
                        yyaxis right
                        ax = gca;
                        ax.YColor = 'k';
                        ylabel('Distance from fixation point (°)') 
                        ylim([0 7])
                        legend([red_eye_dist, blue_eye_dist])
                        yyaxis left

                        xlabel('Time [s]')
                        xlim([0 inf])
                        ylabel('Report by button press         Stimulus switch')
                        ylim([-3 3])
                        yticks([-2.5 -1.5 0 0.5 1.5 2.5])
                        yticklabels({'Red', 'Blue', ' ', 'BR','Blue','Red'})
                        set(gca, 'YGrid', 'on', 'XGrid', 'off')
                        title(['Block: ' num2str(triad_counter)])
                        filename = [subj_fig_dir '/ButtonPress_'  num2str(triad_counter) '.png'];
                        saveas(gcf,filename)
                        filename = [subj_fig_dir '/ButtonPress_'  num2str(triad_counter) '.fig'];
                        saveas(gcf,filename)
                        triad_counter = triad_counter + 1;
                    end
                end
            end

            if data.trial(trl).stimulus == 4 % BinoRiv -> phys
    %             if any(find(trl == triad_former)) % if the trial is the former in triad
                if any(find(trl == triad_former-trl_adjustor)) % if the trial is the former in triad % emergency measure 02/Dec
                    figure(2+triad_counter)
                    if trial_count == 8
                        plot_zero_time = data.trial(trl).tSample_from_time_start(1);
                    end

                    % Get timing
                    if data.trial(trl-1).repo_red(data.trial(trl-1).counter) == 1 && data.trial(trl).repo_red(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        repo_red_begin = vertcat(repo_red_begin, time_series_present);
                    elseif data.trial(trl-1).repo_red(data.trial(trl-1).counter) == 0 && data.trial(trl).repo_red(1) == 1
                        time_series_present = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
                        repo_red_begin = vertcat(repo_red_begin, time_series_present);
                    elseif data.trial(trl-1).repo_blue(data.trial(trl-1).counter) == 1 && data.trial(trl).repo_blue(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                    elseif data.trial(trl-1).repo_blue(data.trial(trl-1).counter) == 0 && data.trial(trl).repo_blue(1) == 1
                        time_series_present = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
                        repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                    end

                    for moment = 1:data.trial(trl).counter
                        try
                            if data.trial(trl).repo_red(moment-1) == 0 && data.trial(trl).repo_red(moment) == 1
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_red_begin = vertcat(repo_red_begin, time_series_present);
                            elseif data.trial(trl).repo_red(moment-1) == 1 && data.trial(trl).repo_red(moment) == 0
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_red_end = vertcat(repo_red_end, time_series_present);
                            elseif data.trial(trl).repo_blue(moment-1) == 0 && data.trial(trl).repo_blue(moment) == 1
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                            elseif data.trial(trl).repo_blue(moment-1) == 1 && data.trial(trl).repo_blue(moment) == 0
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_blue_end = vertcat(repo_blue_end, time_series_present);
                            end
                        catch
                        end
                    end
                    % if data.trial(trl).repo_red == 1
                    %     repo_red_begin = vertcat(repo_red_begin, data.trial(trl).tSample_from_time_start(1) - plot_zero_time);
                    %     repo_red_end = vertcat(repo_red_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time);
                    % elseif data.trial(trl).repo_blue == 1
                    %     repo_blue_begin = vertcat(repo_blue_begin, data.trial(trl).tSample_from_time_start(1) - plot_zero_time);
                    %     repo_blue_end = vertcat(repo_blue_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time);
                    % end

                    % Paint areas
                    if height(repo_red_begin) > height(repo_red_end) %  Button had been pressed till the end
                        for max_index = 1:height(repo_red_end)
                            area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                        trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time;
                        area([repo_red_begin(height(repo_red_begin)) trial_end], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif height(repo_red_begin) < height(repo_red_end) %  Button had been pressed at first already
                        try
                            for max_index = 1:height(repo_red_begin)
                                area([repo_red_begin(max_index) repo_red_end(1+max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                            end
                        catch
                        end
                        trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        area([trial_start repo_red_end(1,1)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    else
                        for max_index = 1:height(repo_red_begin)
                            area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    end
                    if height(repo_blue_begin) > height(repo_blue_end) %  Button had been pressed till the end
                        for max_index = 1:height(repo_blue_end)
                            area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                        trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time;
                        area([repo_blue_begin(height(repo_blue_begin)) trial_end], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif height(repo_blue_begin) < height(repo_blue_end) %  Button had been pressed at first already
                        try
                            for max_index = 1:height(repo_blue_begin)
                                area([repo_blue_begin(max_index) repo_blue_end(1+max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                            end
                        catch
                        end
                        trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        area([trial_start repo_blue_end(1,1)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    else
                        for max_index = 1:height(repo_blue_begin)
                            area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    end

                    % Plot correct switch
                    if task_number == 4
%                         trial_start = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
%                         trial_end = data.trial(trl+1).tSample_from_time_start(1) - plot_zero_time;
                        trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                        if isempty(data.trial(trl+1).states_onset)
                            trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                        else
                            trial_end = data.trial(trl+1).states_onset(1) - plot_zero_time;
                        end
                    else
                        trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                        trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                    end
                    area([trial_start trial_end], [0.5 0.5], 'FaceColor', [0.6 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    % fill the gap of the initialised state
%                     try 
%                         area([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [0.5 0.5], 'FaceColor', [0.6 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5);
%                     catch
%                     end

                    % Plot raw eye-tracking data
%                     yyaxis right
%                     % time = downsample(data.trial(trl).tSample_from_time_start - plot_zero_time, 64);
%                     % x_eye_pos = downsample(data.trial(trl).x_eye, 64);
%                     % y_eye_pos = downsample(data.trial(trl).y_eye, 64);
%                     time = data.trial(trl).tSample_from_time_start - plot_zero_time;
%                     x_eye_pos = data.trial(trl).x_eye;
%                     y_eye_pos = data.trial(trl).y_eye;
%                     plot_x_eye = plot(time, x_eye_pos, '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
%                     plot_y_eye = plot(time, y_eye_pos, '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
%                     try % fill the gap between two trials
%                         plot_x_eye_connect = plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [data.trial(trl-1).x_eye(data.trial(trl-1).counter) data.trial(trl).x_eye(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
%                         plot_y_eye_connect = plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [data.trial(trl-1).y_eye(data.trial(trl-1).counter) data.trial(trl).y_eye(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
%                     catch
%                     end
%                     yyaxis left
                    
                    % Plot eye-tracking data as dist. from FPs
                    yyaxis right
                    % For red
                    time_series_present = data.trial(trl).tSample_from_time_start - plot_zero_time;
                    x_eye_present = data.trial(trl).x_eye;
                    y_eye_present = data.trial(trl).y_eye;
%                     x_fp_present = data.trial(trl).eye.x.red;
%                     y_fp_present = data.trial(trl).eye.y.red;
                    x_fp_present = data.trial(trl).eye.fix.x.red;
                    y_fp_present = data.trial(trl).eye.fix.y.red;
                    distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                    red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                    within_fix_window = [];
                    for sample = 1:numel(distance_present)
                        if distance_present(sample) <= 1.3
                            within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                        elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2,  'color', 'r');
                            within_fix_window = [];
                        end
                    end
                    if ~isempty(within_fix_window)
                        plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'r');
                    end
                    try % fill the gap between two trials
                        x_eye_before = data.trial(trl-1).x_eye;
                        y_eye_before = data.trial(trl-1).y_eye;
%                         x_fp_before = data.trial(trl-1).eye.x.red;
%                         y_fp_before = data.trial(trl-1).eye.y.red;
                        x_fp_before = data.trial(trl-1).eye.fix.x.red;
                        y_fp_before = data.trial(trl-1).eye.fix.y.red;
                        distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                        plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
                    end
                    % For blue
%                     x_fp_present = data.trial(trl).eye.x.blue;
%                     y_fp_present = data.trial(trl).eye.y.blue;
                    x_fp_present = data.trial(trl).eye.fix.x.blue;
                    y_fp_present = data.trial(trl).eye.fix.y.blue;
                    distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                    blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                    within_fix_window = [];
                    for sample = 1:numel(distance_present)
                        if distance_present(sample) <= 1.3
                            within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                        elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                            within_fix_window = [];
                        end
                    end
                    if ~isempty(within_fix_window)
                        plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                    end
                    try % fill the gap between two trials
                        x_eye_before = data.trial(trl-1).x_eye;
                        y_eye_before = data.trial(trl-1).y_eye;
%                         x_fp_before = data.trial(trl-1).eye.x.red;
%                         y_fp_before = data.trial(trl-1).eye.y.red;
                        x_fp_before = data.trial(trl-1).eye.fix.x.red;
                        y_fp_before = data.trial(trl-1).eye.fix.y.red;
                        distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                        plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
                    end
                    yyaxis left

                    % plot FPs onset/offset line
                    if task_number == 4
                        xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                    else
                        if task_number == 1 || task_number == 3
                            if data.trial(trl-1).eye.fix.x.red ~= data.trial(trl).eye.fix.x.red ||...
                                data.trial(trl-1).eye.fix.y.red ~= data.trial(trl).eye.fix.y.red
                                xline(data.trial(trl).states_onset(1) - plot_zero_time, '-')
                            else
                                if data.trial(trl).stimulus ~= data.trial(trl-1).stimulus 
                                    xline(data.trial(trl).states_onset(1) - plot_zero_time, '-')
                                else
                                    xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                                end
                            end
                        else
                            xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                        end
                    end
    %                 xline(data.trial(trl).states_onset(2) - plot_zero_time)
    %                 if any(find(data.trial(trl).states == 19)) % 19 is the aborted state
    %                     xline(data.trial(trl).states_onset(find(data.trial(trl).states == 19)) - plot_zero_time)
    %                     try
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 19))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [3 3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 19))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [-3 -3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                     catch
    %                     end
    %                 elseif any(find(data.trial(trl).states == 20)) % 20 is the success state
    %                     xline(data.trial(trl).states_onset(find(data.trial(trl).states == 20)) - plot_zero_time)
    %                     try
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 20))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [3 3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 20))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [-3 -3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                     catch
    %                     end
    %                 end

                    % Mark if the prediction is not accurate
                    if prediction == false
                        text(double(trial_start), 0, 'NA')
                    end

                    trial_count = trial_count - 1;
                    repo_red_begin = [];
                    repo_red_end = [];
                    repo_blue_begin = [];
                    repo_blue_end = [];
                    if trial_count == 0
                        trial_count = 8;
                    end
                end % any(find(trl == triad_former)) % if the trial is the former in triad

            elseif data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3 % Binoriv -> Phys
    %             if any(find(trl == triad_latter)) % if the trial is the latter in triad
                if any(find(trl == triad_latter-trl_adjustor)) % if the trial is the latter in triad % emergency measure 02/Dec
                    figure(2+triad_counter)
                    % Get timing
                    if data.trial(trl-1).repo_red(data.trial(trl-1).counter) == 1 && data.trial(trl).repo_red(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        repo_red_begin = vertcat(repo_red_begin, time_series_present);
                    elseif data.trial(trl-1).repo_blue(data.trial(trl-1).counter) == 1 && data.trial(trl).repo_blue(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                    end

                    for moment = 1:data.trial(trl).counter
                        try
                            if data.trial(trl).repo_red(moment-1) == 0 && data.trial(trl).repo_red(moment) == 1
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_red_begin = vertcat(repo_red_begin, time_series_present);
                            elseif data.trial(trl).repo_red(moment-1) == 1 && data.trial(trl).repo_red(moment) == 0
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_red_end = vertcat(repo_red_end, time_series_present);
                            elseif data.trial(trl).repo_blue(moment-1) == 0 && data.trial(trl).repo_blue(moment) == 1
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                            elseif data.trial(trl).repo_blue(moment-1) == 1 && data.trial(trl).repo_blue(moment) == 0
                                time_series_present = data.trial(trl).tSample_from_time_start(moment) - plot_zero_time;
                                repo_blue_end = vertcat(repo_blue_end, time_series_present);
                            end
                        catch
                        end
                    end
                    % if data.trial(trl).repo_red == 1
                    %     repo_red_begin = vertcat(repo_red_begin, data.trial(trl).tSample_from_time_start(1) - plot_zero_time);
                    %     repo_red_end = vertcat(repo_red_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time);
                    % elseif data.trial(trl).repo_blue == 1
                    %     repo_blue_begin = vertcat(repo_blue_begin, data.trial(trl).tSample_from_time_start(1) - plot_zero_time);
                    %     repo_blue_end = vertcat(repo_blue_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time);
                    % end

                    % Paint areas
                    if height(repo_red_begin) > height(repo_red_end) %  Button had been pressed till the end
                        for max_index = 1:height(repo_red_end)
                            area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                        trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time;
                        area([repo_red_begin(height(repo_red_begin)) trial_end], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif height(repo_red_begin) < height(repo_red_end) %  Button had been pressed at first already
                        try
                            for max_index = 1:height(repo_red_begin)
                                area([repo_red_begin(max_index) repo_red_end(1+max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                            end
                        catch
                        end
                        trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        area([trial_start repo_red_end(1,1)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    else
                        for max_index = 1:height(repo_red_begin)
                            area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    end
                    if height(repo_blue_begin) > height(repo_blue_end) %  Button had been pressed till the end
                        for max_index = 1:height(repo_blue_end)
                            area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                        trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - plot_zero_time;
                        area([repo_blue_begin(height(repo_blue_begin)) trial_end], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif height(repo_blue_begin) < height(repo_blue_end) %  Button had been pressed at first already
                        try
                            for max_index = 1:height(repo_blue_begin)
                                area([repo_blue_begin(max_index) repo_blue_end(1+max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                            end
                        catch
                        end
                        trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - plot_zero_time;
                        area([trial_start repo_blue_end(1,1)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    else
                        for max_index = 1:height(repo_blue_begin)
                            area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    end

                    % Plot correct switch
                    if task_number == 4
%                         trial_start = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
%                         trial_end = data.trial(trl+1).tSample_from_time_start(1) - plot_zero_time;
                        trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                        if isempty(data.trial(trl+1).states_onset)
                            trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                        else
                            trial_end = data.trial(trl+1).states_onset(1) - plot_zero_time;
                        end
                    else
                        trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                        trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                    end
                    if data.trial(trl).stimulus == 2
                        area([trial_start trial_end], [2.5 2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    elseif data.trial(trl).stimulus == 3
                        area([trial_start trial_end], [1.5 1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    end
                    % fill the gap of the initialised state
%                     try 
%                         if data.trial(trl).stimulus == 2
%                             area([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [2.5 2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5);
%                         elseif data.trial(trl).stimulus == 3
%                             area([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [1.5 1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5);
%                         end
%                     catch    
%                     end

                    % Plot raw eye-tracking data
%                     yyaxis right
%                     % time = downsample(data.trial(trl).tSample_from_time_start - plot_zero_time, 64);
%                     % x_eye_pos = downsample(data.trial(trl).x_eye, 64);
%                     % y_eye_pos = downsample(data.trial(trl).y_eye, 64);
%                     time = data.trial(trl).tSample_from_time_start - plot_zero_time;
%                     x_eye_pos = data.trial(trl).x_eye;
%                     y_eye_pos = data.trial(trl).y_eye;
%                     plot_x_eye = plot(time, x_eye_pos, '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
%                     plot_y_eye = plot(time, y_eye_pos, '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
%                     try % fill the gap between two trials
%                         plot_x_eye_connect = plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [data.trial(trl-1).x_eye(data.trial(trl-1).counter) data.trial(trl).x_eye(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
%                         plot_y_eye_connect = plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [data.trial(trl-1).y_eye(data.trial(trl-1).counter) data.trial(trl).y_eye(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
%                     catch
%                     end
%                     yyaxis left
                    
                    % Plot eye-tracking data as dist. from FPs
                    yyaxis right
                    time_series_present = data.trial(trl).tSample_from_time_start - plot_zero_time;
                    x_eye_present = data.trial(trl).x_eye;
                    y_eye_present = data.trial(trl).y_eye;
                    
                    % For red
                    if data.trial(trl).stimulus == 2
                        if task_number == 4
                            time_series_present = data.trial(trl).tSample_from_time_start - plot_zero_time;
                            x_eye_present = data.trial(trl).x_eye;
                            y_eye_present = data.trial(trl).y_eye;
        %                     x_fp_present = data.trial(trl).eye.x.red;
        %                     y_fp_present = data.trial(trl).eye.y.red;
                            x_fp_present = data.trial(trl).eye.fix.x.red;
                            y_fp_present = data.trial(trl).eye.fix.y.red;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2,  'color', 'r');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'r');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
        %                         x_fp_before = data.trial(trl-1).eye.x.red;
        %                         y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
                            end
                            % For the other FP
        %                     x_fp_present = data.trial(trl).eye.x.blue;
        %                     y_fp_present = data.trial(trl).eye.y.blue;
                            x_fp_present = data.trial(trl).eye.fix.x.blue;
                            y_fp_present = data.trial(trl).eye.fix.y.blue;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
        %                         x_fp_before = data.trial(trl-1).eye.x.red;
        %                         y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
                            end
                        else
    %                         x_fp_present = data.trial(trl).eye.x.red;
    %                         y_fp_present = data.trial(trl).eye.y.red;
                            x_fp_present = data.trial(trl).eye.fix.x.red;
                            y_fp_present = data.trial(trl).eye.fix.y.red;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2,  'color', 'r');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'r');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
    %                             x_fp_before = data.trial(trl-1).eye.x.red;
    %                             y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
                            end
                        end
                    end
                    % For blue
                    if data.trial(trl).stimulus == 3
                        if task_number == 4
                            time_series_present = data.trial(trl).tSample_from_time_start - plot_zero_time;
                            x_eye_present = data.trial(trl).x_eye;
                            y_eye_present = data.trial(trl).y_eye;
        %                     x_fp_present = data.trial(trl).eye.x.red;
        %                     y_fp_present = data.trial(trl).eye.y.red;
                            x_fp_present = data.trial(trl).eye.fix.x.red;
                            y_fp_present = data.trial(trl).eye.fix.y.red;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2,  'color', 'r');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'r');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
        %                         x_fp_before = data.trial(trl-1).eye.x.red;
        %                         y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'r', 'DisplayName','Dist of x-axis from centre of stimulus');
                            end
                            % For the other FP
        %                     x_fp_present = data.trial(trl).eye.x.blue;
        %                     y_fp_present = data.trial(trl).eye.y.blue;
                            x_fp_present = data.trial(trl).eye.fix.x.blue;
                            y_fp_present = data.trial(trl).eye.fix.y.blue;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                            end
                            try % fill the gap between two trials
                                x_eye_before = data.trial(trl-1).x_eye;
                                y_eye_before = data.trial(trl-1).y_eye;
        %                         x_fp_before = data.trial(trl-1).eye.x.red;
        %                         y_fp_before = data.trial(trl-1).eye.y.red;
                                x_fp_before = data.trial(trl-1).eye.fix.x.red;
                                y_fp_before = data.trial(trl-1).eye.fix.y.red;
                                distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
                                plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
                            end
                        else
    %                         x_fp_present = data.trial(trl).eye.x.blue;
    %                         y_fp_present = data.trial(trl).eye.y.blue;
                            x_fp_present = data.trial(trl).eye.fix.x.blue;
                            y_fp_present = data.trial(trl).eye.fix.y.blue;
                            distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                            blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                            within_fix_window = [];
                            for sample = 1:numel(distance_present)
                                if distance_present(sample) <= 1.3
                                    within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                                elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                    plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                                    within_fix_window = [];
                                end
                            end
                            if ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 2, 'color', 'b');
                            end
    %                         try % fill the gap between two trials
    %                             x_eye_before = data.trial(trl-1).x_eye;
    %                             y_eye_before = data.trial(trl-1).y_eye;
    % %                             x_fp_before = data.trial(trl-1).eye.x.red;
    % %                             y_fp_before = data.trial(trl-1).eye.y.red;
    %                             x_fp_before = data.trial(trl-1).eye.fix.x.red;
    %                             y_fp_before = data.trial(trl-1).eye.fix.y.red;
    %                             distance_before = sqrt((x_eye_before-x_fp_before).^2 + (y_eye_before-y_fp_before).^2);
    %                             plot([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-plot_zero_time   data.trial(trl).tSample_from_time_start(1)-plot_zero_time], [distance_before(end) distance_present(1)], '-', 'color', 'b', 'DisplayName','Dist of y-axis from centre of stimulus');
    %                         end
                        end
                    end
                    yyaxis left

                    % plot FPs onset/offset line
                    if task_number == 4
                        xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                    else
                        if task_number == 1 || task_number == 3
                            if data.trial(trl-1).eye.fix.x.red ~= data.trial(trl).eye.fix.x.red ||...
                                data.trial(trl-1).eye.fix.y.red ~= data.trial(trl).eye.fix.y.red
                                xline(data.trial(trl).states_onset(1) - plot_zero_time, '-')
                            else
                                if data.trial(trl).stimulus ~= data.trial(trl-1).stimulus 
                                    xline(data.trial(trl).states_onset(1) - plot_zero_time, '-')
                                else
                                    xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                                end
                            end
                        else
                            xline(data.trial(trl).states_onset(1) - plot_zero_time, '--')
                        end
                    end
    %                 xline(data.trial(trl).states_onset(2) - plot_zero_time)
    %                 if any(find(data.trial(trl).states == 19)) % 19 is the aborted state
    %                     xline(data.trial(trl).states_onset(find(data.trial(trl).states == 19)) - plot_zero_time)
    %                     try
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 19))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [3 3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 19))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [-3 -3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                     catch
    %                     end
    %                 elseif any(find(data.trial(trl).states == 20)) % 20 is the success state
    %                     xline(data.trial(trl).states_onset(find(data.trial(trl).states == 20)) - plot_zero_time)
    %                     try
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 20))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [3 3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                         area([(data.trial(trl).states_onset(find(data.trial(trl).states == 20))-plot_zero_time) (data.trial(trl+1).states_onset(2)-plot_zero_time)], [-3 -3], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);
    %                     catch
    %                     end
    %                 end

                    trial_count = trial_count - 1;
                    repo_red_begin = [];
                    repo_red_end = [];
                    repo_blue_begin = [];
                    repo_blue_end = [];
                    if trial_count == 0
                        trial_count = 8;

                        % for eye-traking plot
%                         yyaxis right
%                         ylim([-3.75 3.75]) 
%                         ax = gca;
%                         ax.YColor = 'k';
%                         ylabel('Distance from centre of stimulus (deg)')
%                         legend([plot_x_eye, plot_y_eye])
%                         yyaxis left
                        
                        yyaxis right
                        ax = gca;
                        ax.YColor = 'k';
                        ylabel('Distance from fixation point (°)') 
                        ylim([0 7])
%                         legend([red_eye_dist, blue_eye_dist])
                        yyaxis left

                        xlabel('Time [s]')
                        xlim([0 inf])
                        ylabel('Report by button press         Stimulus switch')
                        ylim([-3 3])
                        yticks([-2.5 -1.5 0 0.5 1.5 2.5])
                        yticklabels({'Red', 'Blue', ' ', 'BR','Blue','Red'})
                        set(gca, 'YGrid', 'on', 'XGrid', 'off')
                        title(['Block: ' num2str(triad_counter)])
                        filename = [subj_fig_dir '/ButtonPress_'  num2str(triad_counter) '.png'];
                        saveas(gcf,filename)
                        filename = [subj_fig_dir '/ButtonPress_'  num2str(triad_counter) '.fig'];
                        saveas(gcf,filename)
                        triad_counter = triad_counter + 1;
                    end
                end
            end


            %% Trial-based button pressing & dist from FPs with trigger
            % Plot button pressing
            if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3 || data.trial(trl).stimulus == 4
                figure(100+trl)
                trial_zero_time = data.trial(trl).tSample_from_time_start(1);

                % Get timing
                try
                    if data.trial(trl-1).repo_red(data.trial(trl-1).counter) == 1 && data.trial(trl).repo_red(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - trial_zero_time;
                        repo_red_begin = vertcat(repo_red_begin, time_series_present);
                    elseif data.trial(trl-1).repo_red(data.trial(trl-1).counter) == 0 && data.trial(trl).repo_red(1) == 1
                        time_series_present = data.trial(trl).tSample_from_time_start(1) - trial_zero_time;
                        repo_red_begin = vertcat(repo_red_begin, time_series_present);
                    elseif data.trial(trl-1).repo_blue(data.trial(trl-1).counter) == 1 && data.trial(trl).repo_blue(1) == 1
                        time_series_present = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - trial_zero_time;
                        repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                    elseif data.trial(trl-1).repo_blue(data.trial(trl-1).counter) == 0 && data.trial(trl).repo_blue(1) == 1
                        time_series_present = data.trial(trl).tSample_from_time_start(1) - trial_zero_time;
                        repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                    end
                catch
                end

                for moment = 1:data.trial(trl).counter
                    try
                        if data.trial(trl).repo_red(moment-1) == 0 && data.trial(trl).repo_red(moment) == 1
                            time_series_present = data.trial(trl).tSample_from_time_start(moment) - trial_zero_time;
                            repo_red_begin = vertcat(repo_red_begin, time_series_present);
                        elseif data.trial(trl).repo_red(moment-1) == 1 && data.trial(trl).repo_red(moment) == 0
                            time_series_present = data.trial(trl).tSample_from_time_start(moment) - trial_zero_time;
                            repo_red_end = vertcat(repo_red_end, time_series_present);
                        elseif data.trial(trl).repo_blue(moment-1) == 0 && data.trial(trl).repo_blue(moment) == 1
                            time_series_present = data.trial(trl).tSample_from_time_start(moment) - trial_zero_time;
                            repo_blue_begin = vertcat(repo_blue_begin, time_series_present);
                        elseif data.trial(trl).repo_blue(moment-1) == 1 && data.trial(trl).repo_blue(moment) == 0
                            time_series_present = data.trial(trl).tSample_from_time_start(moment) - trial_zero_time;
                            repo_blue_end = vertcat(repo_blue_end, time_series_present);
                        end
                    catch
                    end
                end
                % if data.trial(trl).repo_red == 1
                %     repo_red_begin = vertcat(repo_red_begin, data.trial(trl).tSample_from_time_start(1) - trial_zero_time);
                %     repo_red_end = vertcat(repo_red_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - trial_zero_time);
                % elseif data.trial(trl).repo_blue == 1
                %     repo_blue_begin = vertcat(repo_blue_begin, data.trial(trl).tSample_from_time_start(1) - trial_zero_time);
                %     repo_blue_end = vertcat(repo_blue_end, data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - trial_zero_time);
                % end

                % Paint areas
                if height(repo_red_begin) > height(repo_red_end) %  Button had been pressed till the end
                    for max_index = 1:height(repo_red_end)
                        area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    end
                    trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - trial_zero_time;
                    area([repo_red_begin(height(repo_red_begin)) trial_end], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                elseif height(repo_red_begin) < height(repo_red_end) %  Button had been pressed at first already
                    try
                        for max_index = 1:height(repo_red_begin)
                            area([repo_red_begin(max_index) repo_red_end(1+max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    catch
                    end
                    trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - trial_zero_time;
                    area([trial_start repo_red_end(1,1)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                else
                    for max_index = 1:height(repo_red_begin)
                        area([repo_red_begin(max_index) repo_red_end(max_index)], [-2.5 -2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    end
                end
                if height(repo_blue_begin) > height(repo_blue_end) %  Button had been pressed till the end
                    for max_index = 1:height(repo_blue_end)
                        area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    end
                    trial_end = data.trial(trl).tSample_from_time_start(data.trial(trl).counter) - trial_zero_time;
                    area([repo_blue_begin(height(repo_blue_begin)) trial_end], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                elseif height(repo_blue_begin) < height(repo_blue_end) %  Button had been pressed at first already
                    try
                        for max_index = 1:height(repo_blue_begin)
                            area([repo_blue_begin(max_index) repo_blue_end(1+max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                        end
                    catch
                    end
                    trial_start = data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter) - trial_zero_time;
                    area([trial_start repo_blue_end(1,1)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                else
                    for max_index = 1:height(repo_blue_begin)
                        area([repo_blue_begin(max_index) repo_blue_end(max_index)], [-1.5 -1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                    end
                end

                % Plot correct switch
                if task_number == 4
%                     trial_start = data.trial(trl).tSample_from_time_start(1) - plot_zero_time;
%                     trial_end = data.trial(trl+1).tSample_from_time_start(1) - plot_zero_time;
                    trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                    if isempty(data.trial(trl+1).states_onset)
                        trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                    else
                        trial_end = data.trial(trl+1).states_onset(1) - plot_zero_time;
                    end
                else
                    trial_start = data.trial(trl).states_onset(1) - plot_zero_time;
                    trial_end = data.trial(trl).tSample_from_time_start(end) - plot_zero_time;
                end
                if data.trial(trl).stimulus == 2
                    area([trial_start trial_end], [2.5 2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                elseif data.trial(trl).stimulus == 3
                    area([trial_start trial_end], [1.5 1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                elseif data.trial(trl).stimulus == 4
                    area([trial_start trial_end], [0.5 0.5], 'FaceColor', [0.6 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5); hold on;
                end
                % fill the gap of the initialised state
%                 try 
%                     if data.trial(trl).stimulus == 2
%                         area([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-trial_zero_time   data.trial(trl).tSample_from_time_start(1)-trial_zero_time], [2.5 2.5], 'FaceColor', [0.8 0.2 0], 'EdgeColor', 'none', 'FaceAlpha', .5);
%                     elseif data.trial(trl).stimulus == 3
%                         area([data.trial(trl-1).tSample_from_time_start(data.trial(trl-1).counter)-trial_zero_time   data.trial(trl).tSample_from_time_start(1)-trial_zero_time], [1.5 1.5], 'FaceColor', [0 0.2 0.8], 'EdgeColor', 'none', 'FaceAlpha', .5);
%                     end
%                 catch
%                 end
                xlabel('Time [s]')
                xlim([0 inf])
                ylabel('Report by button press         Stimulus switch')
                ylim([-3 3])
                yticks([-2.5 -1.5 0 0.5 1.5 2.5])
                yticklabels({'Red', 'Blue', ' ', 'BR','Blue','Red'})

                % Plot raw eye-tracking data
                yyaxis right
                time_series_present = data.trial(trl).tSample_from_time_start - data.trial(trl).tSample_from_time_start(1);

                % For red
                if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 4
                    if task_number == 4
                        x_eye_present = data.trial(trl).x_eye;
                        y_eye_present = data.trial(trl).y_eye;
    %                     x_fp_present = data.trial(trl).eye.x.red;
    %                     y_fp_present = data.trial(trl).eye.y.red;
                        x_fp_present = data.trial(trl).eye.fix.x.red;
                        y_fp_present = data.trial(trl).eye.fix.y.red;
                        distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                        red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                        within_fix_window = [];
                        for sample = 1:numel(distance_present)
                            if distance_present(sample) <= 1.3
                                within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                            elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3,  'color', 'r');
                                within_fix_window = [];
                            end
                        end
                        if ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'r');
                        end
%                           x_fp_present = data.trial(trl).eye.x.blue;
    %                     y_fp_present = data.trial(trl).eye.y.blue;
                        x_fp_present = data.trial(trl).eye.fix.x.blue;
                        y_fp_present = data.trial(trl).eye.fix.y.blue;
                        distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                        blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                        within_fix_window = [];
                        for sample = 1:numel(distance_present)
                            if distance_present(sample) <= 1.3
                                within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                            elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'b');
                                within_fix_window = [];
                            end
                        end
                        if ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'b');
                        end
                    else
                        x_eye_present = data.trial(trl).x_eye;
                        y_eye_present = data.trial(trl).y_eye;
    %                     x_fp_present = data.trial(trl).eye.x.red;
    %                     y_fp_present = data.trial(trl).eye.y.red;
                        x_fp_present = data.trial(trl).eye.fix.x.red;
                        y_fp_present = data.trial(trl).eye.fix.y.red;
                        distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                        red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                        within_fix_window = [];
                        for sample = 1:numel(distance_present)
                            if distance_present(sample) <= 1.3
                                within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                            elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3,  'color', 'r');
                                within_fix_window = [];
                            end
                        end
                        if ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'r');
                        end
                    end
                end
                                        
                % For blue
                if data.trial(trl).stimulus == 3 || data.trial(trl).stimulus == 4
                    if task_number == 4
                        x_eye_present = data.trial(trl).x_eye;
                        y_eye_present = data.trial(trl).y_eye;
    %                     x_fp_present = data.trial(trl).eye.x.red;
    %                     y_fp_present = data.trial(trl).eye.y.red;
                        x_fp_present = data.trial(trl).eye.fix.x.red;
                        y_fp_present = data.trial(trl).eye.fix.y.red;
                        distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                        red_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'r', 'DisplayName','Dist from red eye spot'); hold on 
                        within_fix_window = [];
                        for sample = 1:numel(distance_present)
                            if distance_present(sample) <= 1.3
                                within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                            elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3,  'color', 'r');
                                within_fix_window = [];
                            end
                        end
                        if ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'r');
                        end
%                           x_fp_present = data.trial(trl).eye.x.blue;
    %                     y_fp_present = data.trial(trl).eye.y.blue;
                        x_fp_present = data.trial(trl).eye.fix.x.blue;
                        y_fp_present = data.trial(trl).eye.fix.y.blue;
                        distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                        blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                        within_fix_window = [];
                        for sample = 1:numel(distance_present)
                            if distance_present(sample) <= 1.3
                                within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                            elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'b');
                                within_fix_window = [];
                            end
                        end
                        if ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'b');
                        end
                    else
    %                     x_fp_present = data.trial(trl).eye.x.blue;
    %                     y_fp_present = data.trial(trl).eye.y.blue;
                        x_fp_present = data.trial(trl).eye.fix.x.blue;
                        y_fp_present = data.trial(trl).eye.fix.y.blue;
                        distance_present = sqrt((x_eye_present-x_fp_present).^2 + (y_eye_present-y_fp_present).^2);
                        blue_eye_dist = plot(time_series_present, distance_present, '-', 'color', 'b', 'DisplayName','Dist from red blue spot');
                        within_fix_window = [];
                        for sample = 1:numel(distance_present)
                            if distance_present(sample) <= 1.3
                                within_fix_window = vertcat(within_fix_window, [time_series_present(sample) distance_present(sample)]);
                            elseif distance_present(sample) > 1.3 && ~isempty(within_fix_window)
                                plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'b');
                                within_fix_window = [];
                            end
                        end
                        if ~isempty(within_fix_window)
                            plot(within_fix_window(:,1), within_fix_window(:,2), '-', 'LineWidth', 3, 'color', 'b');
                        end
                    end
                end

                % Mark ITI area
    %             STATE_INI_duration = data.trial(trl).states_onset(2) - data.trial(trl).states_onset(1);
    %             area([0 STATE_INI_duration], [7 7], 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceAlpha', .5);

                % Trigger line (i.e. beggining of button pressing)
    %             try
    %                 if repo_red_begin(1) > repo_blue_begin(1)
    %                     trigger = repo_blue_begin(1);
    %                 elseif repo_red_begin(1) < repo_blue_begin(1)
    %                     trigger = repo_red_begin(1);
    %                 end
    %                 xline(trigger, '--')
    %             catch
    %                 if ~isempty(repo_red_begin) && isempty(repo_blue_begin)
    %                     trigger = repo_red_begin(1);
    %                 elseif ~isempty(repo_blue_begin) && isempty(repo_red_begin)
    %                     trigger = repo_blue_begin(1);
    %                 end
    %                 xline(trigger, '--')
    %             end

                % Mark states
                for state = 1:numel(data.trial(trl).states)
                    if data.trial(trl).states(state) == 33
                        aqc_onset = data.trial(trl).states_onset(state) - data.trial(trl).states_onset(1);
                        xline(aqc_onset, '-')
                    elseif data.trial(trl).states(state) == 34
                        hold_onset = data.trial(trl).states_onset(state) - data.trial(trl).states_onset(1);
                        xline(hold_onset, '--')
                    end
                end
                
                ax = gca;
                ax.YColor = 'k';
                ylabel('Distance from fixation point (°)') 
        %                         xticks([1.5 3 4.5])
        %                         xticklabels({'1500', '3000', '4500 '})
                ylim([0 7])
                if data.trial(trl).stimulus == 2
                    legend(red_eye_dist)
                elseif data.trial(trl).stimulus == 3
                    legend(blue_eye_dist)
                elseif data.trial(trl).stimulus == 4
                    legend([red_eye_dist, blue_eye_dist])
                end
                if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3
                    if data.trial(trl).success == 1
                        title(['Block: ' num2str(triad_counter) ', trial: ' num2str(total_trl) ', Switch: Phys, Fixation: Successed'])
                    else
                        title(['Block: ' num2str(triad_counter) ', trial: ' num2str(total_trl) ', Switch: Phys, Fixation: Failed'])
                    end
                elseif data.trial(trl).stimulus == 4
                    if data.trial(trl).success == 1
                        title(['Block: ' num2str(triad_counter) ', trial: ' num2str(total_trl) ', Switch: BinoRiv, Fixation: Successed'])
                    else
                        title(['Block: ' num2str(triad_counter) ', trial: ' num2str(total_trl) ', Switch: BinoRiv, Fixation: Failed'])
                    end
                end
                filename = [subj_fig_dir '/trial_'  num2str(total_trl) '.png'];
                saveas(gcf,filename)
                filename = [subj_fig_dir '/trial_'  num2str(total_trl) '.fig'];
                saveas(gcf,filename)
                close
               

                repo_red_begin = [];
                repo_red_end = [];
                repo_blue_begin = [];
                repo_blue_end = [];
                
            end % if data.trial(trl).stimulus == 2 || data.trial(trl).stimulus == 3 || data.trial(trl).stimulus == 4
        end
    end
end
        