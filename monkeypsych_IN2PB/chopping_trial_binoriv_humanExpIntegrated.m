% Author: Ryo Segawa (whizznihil.kid@gmail.com)
function chopping_trial_binoriv_humanExpIntegrated(file_location)

clear all

task_number = 4;
subj_name = 'RebeccaW';
file_name = 'human2023-09-22_06';
file_location = (['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_beforeChopping\data_task' num2str(task_number) '\' subj_name '\' file_name]);
% file_location = (['D:\Data\human\20230814/human2023-08-14_14']);
% file_location = (['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task4_original']);

load(file_location)

report = true;

num_trial_phys = 8;
num_trial_bino = 8;

interval_blank = false; % in case there is a interval trial within a block

trials_store = struct;

%% Chop the trial(i.e. block) into real trials
for block = 1:numel(trial)
    % block is 'triad' number in this task
    if num_trial_phys == num_trial_bino
        triad_trial = (block-1) * ((num_trial_bino)*2 + 2);
    else
        triad_trial = (block-1) * ((num_trial_phys+num_trial_bino) + 2);
    end
    
    if interval_blank
        triad_trial = (block-1) * ((num_trial_phys+num_trial_bino) + 3);
    end

    % split fixation cue trial
    fix_cue_label = find(trial(block).states == 33);
    fix_cue_label = fix_cue_label(1) - 1;

    % triad based
    trials_store(triad_trial+1).timestamp = trial(block).timestamp;
    trials_store(triad_trial+1).force_hand = NaN;
    trials_store(triad_trial+1).manual_success = NaN;
    trials_store(triad_trial+1).force_small_reward = NaN;
    trials_store(triad_trial+1).microstim = NaN;
    trials_store(triad_trial+1).microstim_interval = NaN;
    trials_store(triad_trial+1).microstim_state = NaN;
    trials_store(triad_trial+1).microstim_start = NaN;
    trials_store(triad_trial+1).microstim_end = NaN;
    trials_store(triad_trial+1).type = trial(block).type;
    trials_store(triad_trial+1).effector = trial(block).effector;
    trials_store(triad_trial+1).rest_hand = NaN;
    trials_store(triad_trial+1).reach_hand = NaN;
    trials_store(triad_trial+1).hand_choice = NaN;
    trials_store(triad_trial+1).choice = NaN;
    trials_store(triad_trial+1).reward_modulation = NaN;
    trials_store(triad_trial+1).small_reward = NaN;
    trials_store(triad_trial+1).CueAuditiv = NaN;
    trials_store(triad_trial+1).completed = trial(block).completed;
    trials_store(triad_trial+1).aborted_state = trial(block).aborted_state;
    trials_store(triad_trial+1).aborted_state_duration = trial(block).aborted_state_duration;
    trials_store(triad_trial+1).abort_code = trial(block).abort_code;
    % trial based
    trials_store(triad_trial+1).n = triad_trial+1;
    trials_store(triad_trial+1).success = trial(block).success(1);
    trials_store(triad_trial+1).stimulus = trial(block).stimulus(1);
    trials_store(triad_trial+1).eye = trial(block).eye(1);
    trials_store(triad_trial+1).hnd = trial(block).hnd(1);
    trials_store(triad_trial+1).reward_size = trial(block).reward_size;
    trials_store(triad_trial+1).task = trial(block).task;
%     trials_store(triad_trial+1).target_selected = trial(block).target_selected(1);
%     trials_store(triad_trial+1).target2_selected = trial(block).target2_selected(1);
%     trials_store(triad_trial+1).reward_selected = trial(block).reward_selected(1);
%     trials_store(triad_trial+1).reward_prob = trial(block).reward_prob(1);
%     trials_store(triad_trial+1).reward_time = trial(block).reward_time(1);
    % state based
    trials_store(triad_trial+1).states = trial(block).states(1:fix_cue_label);
    trials_store(triad_trial+1).states_onset = trial(block).states_onset(1:fix_cue_label);
    trials_store(triad_trial+1).fix_colour = trial(block).fix_colour(1:fix_cue_label);
    trials_store(triad_trial+1).chopping_label = trial(block).chopping_label(1:fix_cue_label);
    onset_counts = sum(trial(block).counter_onset(1:fix_cue_label));
    % sample based
    trials_store(triad_trial+1).tSample_from_time_start = trial(block).tSample_from_time_start(1:onset_counts);
    trials_store(triad_trial+1).state = trial(block).state(1:onset_counts);
    trials_store(triad_trial+1).x_hnd = trial(block).x_hnd(1:onset_counts);
    trials_store(triad_trial+1).y_hnd = trial(block).y_hnd(1:onset_counts);
    trials_store(triad_trial+1).x_eye = trial(block).x_eye(1:onset_counts);
    trials_store(triad_trial+1).y_eye = trial(block).y_eye(1:onset_counts);
    trials_store(triad_trial+1).sen_L = trial(block).sen_L(1:onset_counts);
    trials_store(triad_trial+1).sen_R = trial(block).sen_R(1:onset_counts);
    trials_store(triad_trial+1).jaw = trial(block).jaw(1:onset_counts);
    trials_store(triad_trial+1).counter = onset_counts;
    if report
        trials_store(triad_trial+1).repo_red = trial(block).repo_red(1:onset_counts);
        trials_store(triad_trial+1).repo_blue = trial(block).repo_blue(1:onset_counts);
    end
    trials_store(triad_trial+1).fix_colour_sample = trial(block).fix_colour_sample(1:onset_counts);
    if isfield(trial, 'pupil_size')
        trials_store(triad_trial+1).pupil_size = trial(block).pupil_size(1:onset_counts);
    end

    % split main trials
    main_label = [];
    ite = 0;
    loop = 0;
    if any(find(trial(block).states==20))
        max_main_trials = find(trial(block).states==20);
    else
        max_main_trials = find(trial(block).states==50);
    end
    for label = (fix_cue_label+1):max_main_trials-1
        ite = ite + 1;
        % mono-value based
        trials_store(triad_trial+1+ite).timestamp = trial(block).timestamp;
        trials_store(triad_trial+1+ite).force_hand = NaN;
        trials_store(triad_trial+1+ite).manual_success = NaN;
        trials_store(triad_trial+1+ite).force_small_reward = NaN;
        trials_store(triad_trial+1+ite).microstim = NaN;
        trials_store(triad_trial+1+ite).microstim_interval = NaN;
        trials_store(triad_trial+1+ite).microstim_state = NaN;
        trials_store(triad_trial+1+ite).microstim_start = NaN;
        trials_store(triad_trial+1+ite).microstim_end = NaN;
        trials_store(triad_trial+1+ite).type = trial(block).type;
        trials_store(triad_trial+1+ite).effector = trial(block).effector;
        trials_store(triad_trial+1+ite).rest_hand = NaN;
        trials_store(triad_trial+1+ite).reach_hand = NaN;
        trials_store(triad_trial+1+ite).hand_choice = NaN;
        trials_store(triad_trial+1+ite).choice = NaN;
        trials_store(triad_trial+1+ite).reward_modulation = NaN;
        trials_store(triad_trial+1+ite).small_reward = NaN;
        trials_store(triad_trial+1+ite).CueAuditiv = NaN;
        trials_store(triad_trial+1).completed = trial(block).completed;
        trials_store(triad_trial+1+ite).aborted_state = trial(block).aborted_state;
        trials_store(triad_trial+1+ite).aborted_state_duration = trial(block).aborted_state_duration;
        trials_store(triad_trial+1+ite).abort_code = trial(block).abort_code;
        % trial based
        trials_store(triad_trial+1+ite).n = triad_trial+1+ite;
        trials_store(triad_trial+1+ite).success = trial(block).success(ite+1); % +1 is considering the 1st fixation trial 
        trials_store(triad_trial+1+ite).stimulus = trial(block).stimulus(ite+1);
        trials_store(triad_trial+1+ite).eye = trial(block).eye(ite+1);
%             trials_store(triad_trial+1+ite).hnd = trial(block).hnd(ite+1);
%             trials_store(triad_trial+1+ite).reward_size = trial(block).reward_size;
        trials_store(triad_trial+1+ite).task = trial(block).task; 
%             trials_store(triad_trial+1+ite).target_selected = trial(block).target_selected(ite+1);
%             trials_store(triad_trial+1+ite).target2_selected = trial(block).target2_selected(ite+1);
%             trials_store(triad_trial+1+ite).reward_selected = trial(block).reward_selected(ite+1);
%             trials_store(triad_trial+1+ite).reward_prob = trial(block).reward_prob(ite+1);
%             trials_store(triad_trial+1+ite).reward_time = trial(block).reward_time(ite+1);
        % state based
        trial_start_label = label;
        trials_store(triad_trial+1+ite).states = trial(block).states(trial_start_label:label);
        trials_store(triad_trial+1+ite).states_onset = trial(block).states_onset(trial_start_label:label);
        trials_store(triad_trial+1+ite).fix_colour = trial(block).fix_colour(trial_start_label:label);
        trials_store(triad_trial+1+ite).chopping_label = trial(block).chopping_label(trial_start_label:label);
        onset_counts = sum(trial(block).counter_onset(1:label));
        pre_onset_counts = sum(trial(block).counter_onset(1:trial_start_label-1))+1;
        % sample based
        trials_store(triad_trial+1+ite).tSample_from_time_start = trial(block).tSample_from_time_start(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).state = trial(block).state(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).x_hnd = trial(block).x_hnd(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).y_hnd = trial(block).y_hnd(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).x_eye = trial(block).x_eye(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).y_eye = trial(block).y_eye(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).sen_L = trial(block).sen_L(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).sen_R = trial(block).sen_R(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).jaw = trial(block).jaw(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).counter = onset_counts - pre_onset_counts + 1;
        if report
            trials_store(triad_trial+1+ite).repo_red = trial(block).repo_red(pre_onset_counts:onset_counts);
            trials_store(triad_trial+1+ite).repo_blue = trial(block).repo_blue(pre_onset_counts:onset_counts);
        end
        trials_store(triad_trial+1+ite).fix_colour_sample = trial(block).fix_colour_sample(pre_onset_counts:onset_counts);
        if isfield(trial, 'pupil_size')
            trials_store(triad_trial+1+ite).pupil_size = trial(block).pupil_size(pre_onset_counts:onset_counts);
        end
    end

    % split resting/ITI trial
    if find(trial(block).states == 50)
        rest_label = find(trial(block).states == 50);
        ite = ite + 1;
        % mono-value based
        trials_store(triad_trial+1+ite).timestamp = trial(block).timestamp;
        trials_store(triad_trial+1+ite).force_hand = NaN;
        trials_store(triad_trial+1+ite).manual_success = NaN;
        trials_store(triad_trial+1+ite).force_small_reward = NaN;
        trials_store(triad_trial+1+ite).microstim = NaN;
        trials_store(triad_trial+1+ite).microstim_interval = NaN;
        trials_store(triad_trial+1+ite).microstim_state = NaN;
        trials_store(triad_trial+1+ite).microstim_start = NaN;
        trials_store(triad_trial+1+ite).microstim_end = NaN;
        trials_store(triad_trial+1+ite).type = trial(block).type;
        trials_store(triad_trial+1+ite).effector = trial(block).effector;
        trials_store(triad_trial+1+ite).rest_hand = NaN;
        trials_store(triad_trial+1+ite).reach_hand = NaN;
        trials_store(triad_trial+1+ite).hand_choice = NaN;
        trials_store(triad_trial+1+ite).choice = NaN;
        trials_store(triad_trial+1+ite).reward_modulation = NaN;
        trials_store(triad_trial+1+ite).small_reward = NaN;
        trials_store(triad_trial+1+ite).CueAuditiv = NaN;
        trials_store(block).completed = trial(block).completed;
        trials_store(triad_trial+1+ite).aborted_state = trial(block).aborted_state;
        trials_store(triad_trial+1+ite).aborted_state_duration = trial(block).aborted_state_duration;
        trials_store(triad_trial+1+ite).abort_code = trial(block).abort_code;
        % trial based
        trials_store(triad_trial+1+ite).n = triad_trial+1+ite;
        trials_store(triad_trial+1+ite).success = trial(block).success(ite+1); % +1 is considering the 1st fixation trial 
        trials_store(triad_trial+1+ite).stimulus = trial(block).stimulus(ite+1);
        trials_store(triad_trial+1+ite).eye = trial(block).eye(ite+1);
%         trials_store(triad_trial+1+ite).hnd = trial(block).hnd(ite+1);
%         trials_store(triad_trial+1+ite).reward_size = trial(block).reward_size;
        trials_store(triad_trial+1+ite).task = trial(block).task;
%         trials_store(triad_trial+1+ite).target_selected = trial(block).target_selected(ite+1);
%         trials_store(triad_trial+1+ite).target2_selected = trial(block).target2_selected(ite+1);
%         trials_store(triad_trial+1+ite).reward_selected = trial(block).reward_selected(ite+1);
%         trials_store(triad_trial+1+ite).reward_prob = trial(block).reward_prob(ite+1);
%         trials_store(triad_trial+1+ite).reward_time = trial(block).reward_time(ite+1);
        % state based
        trials_store(triad_trial+1+ite).states = trial(block).states(rest_label);
        trials_store(triad_trial+1+ite).states_onset = trial(block).states_onset(rest_label);
        trials_store(triad_trial+1+ite).fix_colour = {'NaN'};
        trials_store(triad_trial+1+ite).chopping_label = 0;
        onset_counts = sum(trial(block).counter_onset(1:rest_label));
        pre_onset_counts = sum(trial(block).counter_onset(1:rest_label-1))+1;
%         end_triad_counter = sum(trial(block).counter_onset(1:rest_label-1));
%         % sample based
%         trials_store(triad_trial+1+ite).tSample_from_time_start = NaN;
%         trials_store(triad_trial+1+ite).state = NaN;
%         trials_store(triad_trial+1+ite).x_hnd = NaN;
%         trials_store(triad_trial+1+ite).y_hnd = NaN;
%         trials_store(triad_trial+1+ite).x_eye = NaN;
%         trials_store(triad_trial+1+ite).y_eye = NaN;
%         trials_store(triad_trial+1+ite).sen_L = NaN;
%         trials_store(triad_trial+1+ite).sen_R = NaN;
%         trials_store(triad_trial+1+ite).jaw = NaN;
%         trials_store(triad_trial+1+ite).counter = NaN;
%         trials_store(triad_trial+1+ite).repo_red = NaN;
%         trials_store(triad_trial+1+ite).repo_blue = NaN;
%         trials_store(triad_trial+1+ite).fix_colour_sample = NaN;
        % sample based
        trials_store(triad_trial+1+ite).tSample_from_time_start = trial(block).tSample_from_time_start(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).state = trial(block).state(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).x_hnd = trial(block).x_hnd(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).y_hnd = trial(block).y_hnd(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).x_eye = trial(block).x_eye(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).y_eye = trial(block).y_eye(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).sen_L = trial(block).sen_L(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).sen_R = trial(block).sen_R(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).jaw = trial(block).jaw(pre_onset_counts:onset_counts);
        trials_store(triad_trial+1+ite).counter = onset_counts - pre_onset_counts + 1;
        if report
            trials_store(triad_trial+1+ite).repo_red = trial(block).repo_red(pre_onset_counts:onset_counts);
            trials_store(triad_trial+1+ite).repo_blue = trial(block).repo_blue(pre_onset_counts:onset_counts);
        end
        trials_store(triad_trial+1+ite).fix_colour_sample = trial(block).fix_colour_sample(pre_onset_counts:onset_counts);
        if isfield(trial, 'pupil_size')
            trials_store(triad_trial+1+ite).pupil_size = trial(block).pupil_size(pre_onset_counts:onset_counts);
        end
    end
end

trial = trials_store;
mkdir('data_binoriv')


% Get the current date and time as a string
curr_date = datestr(now,'yyyy-mm-dd');

% Count the number of existing .mat files with the current date in the file name
file_counter = 1;
existing_files = dir(['data_binoriv/', curr_date, '*.mat']);
for i = 1:numel(existing_files)
    if ~existing_files(i).isdir
        file_counter = file_counter + 1;
    end
end

% Construct the file name using the current date and the file counter
file_name = ['data_binoriv/' curr_date, '_', num2str(file_counter), '.mat'];

% Save all variables in the workspace to the .mat file
save(file_name, 'SETTINGS','task','trial','VAR');

fprintf('\nData saved in:\n');disp(file_name);
