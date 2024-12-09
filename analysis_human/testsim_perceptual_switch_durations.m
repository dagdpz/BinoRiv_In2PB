% testsim_perceptual_switch_durations
% Igor Kagan, ChatGPT, 2024

% Parameters
num_shapes = 5;                     % Number of shape values
num_scales = 4;                     % Number of scale values
num_epochs = 1000;                  % Number of 40-s epochs per combination of shape and scale
epoch_duration = 40;                % Duration of each epoch in seconds
trial_duration = 5;                 % Duration of each trial in seconds
bin_size = 0.25;                    % Size of each bin in seconds

% Derived Parameters
num_subjects = num_shapes * num_scales;   % Total number of shape-scale combinations
num_trials_per_epoch = epoch_duration / trial_duration;  % Number of 5-s trials in each epoch
num_bins_per_trial = trial_duration / bin_size;          % Number of 0.25-s bins per 5-s trial

% Generate unique combinations of gamma distribution parameters for each subject
shape_vals = linspace(2, 6, num_shapes);
scale_vals = linspace(0.5, 3, num_scales);
[shape_grid, scale_grid] = meshgrid(shape_vals, scale_vals);
shape_params = shape_grid(:);      % Flatten grid for shape parameters
scale_params = scale_grid(:);      % Flatten grid for scale parameters

% Storage for event occurrences and inter-event durations
event_probabilities = zeros(num_bins_per_trial, num_trials_per_epoch);
all_inter_event_durations = cell(1, num_subjects);  % Store inter-event durations for each subject
all_latencies = [];  % Store all latencies within each 5-s trial across subjects

% Set up colormap for plotting different subjects
colors = parula(num_subjects);

% Step 1: Simulate multiple epochs for each shape-scale combination
figure;
subplot(2, 1, 1); hold on;
for subj = 1:num_subjects
    shape_param = shape_params(subj);
    scale_param = scale_params(subj);
    inter_event_durations_subj = [];
    
    for epoch = 1:num_epochs
        event_times = [];               % Reset event times for each epoch
        current_time = 0;
        
        % Generate events based on gamma-distributed inter-event durations
        while current_time < epoch_duration
            inter_event_duration = gamrnd(shape_param, scale_param);
            current_time = current_time + inter_event_duration;
            
            % Record event time if within the 40-second epoch
            if current_time < epoch_duration
                event_times = [event_times, current_time];
                % Store inter-event duration if it's not the first event
                if length(event_times) > 1
                    inter_event_durations_subj = [inter_event_durations_subj, inter_event_duration];
                end
            else
                break;
            end
        end
        
        % Step 2: Bin events within each 5-s trial into 0.25-s bins using histcounts
        for trial = 2:num_trials_per_epoch % if 2, omit first trial
            % Define the start and end time of the 5-s trial
            trial_start = (trial - 1) * trial_duration;
            trial_end = trial * trial_duration;
            
            % Events within the current 5-s trial
            trial_events = event_times(event_times > trial_start & event_times <= trial_end) - trial_start;
            
            % Store the latencies across all subjects and epochs
            all_latencies = [all_latencies, trial_events];
            
            % Bin the trial events into 0.25-s bins using histcounts
            bin_edges = 0:bin_size:trial_duration;
            binned_events = histcounts(trial_events, bin_edges);
            
            % Accumulate event counts in event_probabilities
            event_probabilities(:, trial) = event_probabilities(:, trial) + binned_events';
        end
    end
    
    % Plot the inter-event duration distribution for this combination
    histogram(inter_event_durations_subj, 'Normalization', 'pdf', ...
        'DisplayStyle', 'stairs', 'EdgeColor', colors(subj, :));
    all_inter_event_durations{subj} = inter_event_durations_subj;  % Store for each combination
    
end
title('Distribution of Inter-Event Durations for Each Shape-Scale Combination');
xlabel('Inter-Event Duration (s)');
ylabel('Probability Density');
hold off;

% Plot the combined inter-event duration distribution across all subjects
subplot(2, 1, 2);
histogram(cell2mat(all_inter_event_durations), 'Normalization', 'pdf', 'FaceColor', [0.3, 0.3, 0.8]);
title('Combined Distribution of Inter-Event Durations Across All Subjects');
xlabel('Inter-Event Duration (s)');
ylabel('Probability Density');

% Step 3: Average event probabilities and calculate confidence intervals
% Normalize event probabilities by total epochs across all subjects
event_probabilities = event_probabilities / (num_subjects * num_epochs);

% Calculate mean and standard deviation for confidence interval across trials
mean_event_prob = mean(event_probabilities, 2);
std_event_prob = std(event_probabilities, 0, 2);
ci_event_prob = 1.96 * std_event_prob / sqrt(num_trials_per_epoch * num_subjects * num_epochs);

% Step 4: Calculate the median latency of events across all 5-s trials
median_latency = median(all_latencies);

% Step 5: Plot the mean event probability with confidence intervals
time_bins = (1:num_bins_per_trial) * bin_size - bin_size/2;  % Time bins for the x-axis

figure;
plot(time_bins, mean_event_prob, 'b-', 'LineWidth', 1.5); hold on;
fill([time_bins, fliplr(time_bins)], ...
    [mean_event_prob + ci_event_prob; flipud(mean_event_prob - ci_event_prob)], ...
    'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
set(gca,'Ylim',[0 0.2]);
title(sprintf('Mean Event Probability with 95%% CI, Median Latency: %.2f s', median_latency));
xlabel('Time within 5-s trial (s)');
ylabel('Average Probability of Event');
grid on; hold off;
