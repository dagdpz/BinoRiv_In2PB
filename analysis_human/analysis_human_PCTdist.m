% Author: Ryo Segawa (whizznihil.kid@gmail.com)
% Comparison of perceptual change timing probabilities between arbitrary tasks
function analysis_human_PCTdist()

clear all
close all

taskA_number = 1;
taskB_number = 2;
subject = 10;

data_dir_taskA = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(taskA_number)]);
data_dir_taskA = data_dir_taskA(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir_taskA.name})); % avoid '.' and '..'

trial_count = 8;
fig_dir = ['figures'];
mkdir(fig_dir)

prob_dist_bino_taskA = [];
prob_dist_phys_taskA = [];
prob_dist_bino_taskB = [];
prob_dist_phys_taskB = [];

% for subj = 1:numel(data_dir_taskA)
for subj = subject:subject
    close all
    binoriv_timing_taskA = [];
    phys_timing_taskA = [];
    binoriv_timing_taskB = [];
    phys_timing_taskB = [];

    mkdir([fig_dir '/' data_dir_taskA(subj).name])
    subj_fig_dir = ([fig_dir '/' data_dir_taskA(subj).name]);
    
    subj_dir_taskB = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(taskB_number) '/' data_dir_taskA(subj).name '/*.mat']);
    data_taskB = load(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(taskB_number) '/' data_dir_taskA(subj).name '/' subj_dir_taskB(1).name]);
    
    subj_dir = dir(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/*.mat']);
    for file = 1:numel(subj_dir)
        data_taskA = load(['Y:\Projects\Binocular_rivalry\human_experiment\open_resource/data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/' subj_dir(file).name]);

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
        
        
        %% Trial-based plot
        % For the task A
        for trl = 18:numel(data_taskA.trial)-1
%             switch_timing = NaN;
            % Binoriv 
            if data_taskA.trial(trl).stimulus == 4 %&& numel(data_taskA.trial(trl).chopping_label) == 2
                for sample = 1:data_taskA.trial(trl).counter-1
%                     if data_taskA.trial(trl).repo_red(sample) ~= data_taskA.trial(trl).repo_red(1)
%                         switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
%                         break
%                     elseif data_taskA.trial(trl).repo_blue(sample) ~= data_taskA.trial(trl).repo_blue(1)
%                         switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);;
%                         break
%                     end
                    if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_taskA = [binoriv_timing_taskA switch_timing];
                        continue
                    elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                        binoriv_timing_taskA = [binoriv_timing_taskA switch_timing];
                        continue
                    end
                end            
            % Phys
            elseif data_taskA.trial(trl).stimulus == 2 || data_taskA.trial(trl).stimulus == 3
%                 if numel(data_taskA.trial(trl).chopping_label) == 2
                    for sample = 1:data_taskA.trial(trl).counter-1
    %                     if data_taskA.trial(trl).repo_red(sample) ~= data_taskA.trial(trl).repo_red(1)
    %                         switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     elseif data_taskA.trial(trl).repo_blue(sample) ~= data_taskA.trial(trl).repo_blue(1)
    %                         switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);;
    %                         break
    %                     end
                        if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                            phys_timing_taskA = [phys_timing_taskA switch_timing];
                            continue
                        elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                            phys_timing_taskA = [phys_timing_taskA switch_timing];
                            continue
                        end
                    end
%                 end
            end            
        end
        
        
    end
    
    
    % For the task B
    for trl = 18:numel(data_taskB.trial)-1
%             switch_timing = NaN;
        % Binoriv 
        if data_taskB.trial(trl).stimulus == 4 %&& numel(data_taskB.trial(trl).chopping_label) == 2
            for sample = 1:data_taskB.trial(trl).counter-1
%                     if data.trial(trl).repo_red(sample) ~= data.trial(trl).repo_red(1)
%                         switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);
%                         break
%                     elseif data.trial(trl).repo_blue(sample) ~= data.trial(trl).repo_blue(1)
%                         switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);;
%                         break
%                     end
                if data_taskB.trial(trl).repo_red(sample) == 1 && data_taskB.trial(trl).repo_red(sample+1) == 0
                    switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                    binoriv_timing_taskB = [binoriv_timing_taskB switch_timing];
                    continue
                elseif data_taskB.trial(trl).repo_blue(sample) == 1 && data_taskB.trial(trl).repo_blue(sample+1) == 0
                    switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                    binoriv_timing_taskB = [binoriv_timing_taskB switch_timing];
                    continue
                end
            end            
        % Phys
        elseif data_taskB.trial(trl).stimulus == 2 || data_taskB.trial(trl).stimulus == 3
%             if numel(data_taskB.trial(trl).chopping_label) == 2
                for sample = 1:data_taskB.trial(trl).counter-1
%                     if data.trial(trl).repo_red(sample) ~= data.trial(trl).repo_red(1)
%                         switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);;
%                         break
%                     elseif data.trial(trl).repo_blue(sample) ~= data.trial(trl).repo_blue(1)
%                         switch_timing = data.trial(trl).tSample_from_time_start(sample) - data.trial(trl).tSample_from_time_start(1);;
%                         break
%                     end
                    if data_taskB.trial(trl).repo_red(sample) == 1 && data_taskB.trial(trl).repo_red(sample+1) == 0
                        switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                        phys_timing_taskB = [phys_timing_taskB switch_timing];
                        continue
                    elseif data_taskB.trial(trl).repo_blue(sample) == 1 && data_taskB.trial(trl).repo_blue(sample+1) == 0
                        switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                        phys_timing_taskB = [phys_timing_taskB switch_timing];
                        continue
                    end
                end
%             end
        end
    end
    
    % Percept switch prob. in BinoRiv cond. [all trials]
    figure;
%     histogram(binoriv_timing_taskA,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
    histogram(binoriv_timing_taskA, 'Normalization', 'probability', 'NumBins', 20);
    [prob_bino_taskA, edges] = histcounts(binoriv_timing_taskA, 10, 'Normalization', 'probability');
    prob_dist_bino_taskA = [prob_dist_bino_taskA prob_bino_taskA'];
    xlim([0 5])
%     ylim([0 1])
    xlabel('Time from trial onset [s]')
    ylabel('Probability');
    title(['Probability Distribution of task ' num2str(taskA_number)]);
%     filename = [subj_fig_dir '/Switch_prob_bino.png'];
%     saveas(gcf,filename)
%     filename = [subj_fig_dir '/Switch_prob_bino.fig'];
%     saveas(gcf,filename)

    figure;
%     histogram(binoriv_timing_taskB,20, 'FaceAlpha', 0.5, 'FaceColor', [1 0.1 0.1]); hold on
    histogram(binoriv_timing_taskB, 'Normalization', 'probability', 'NumBins', 20);
    [prob_bino_taskB, edges] = histcounts(binoriv_timing_taskB, 10, 'Normalization', 'probability');
    prob_dist_bino_taskB = [prob_dist_bino_taskB, prob_bino_taskB'];
    xlim([0 5])
%     ylim([0 1])
    xlabel('Time from trial onset [s]')
    ylabel('Probability');
    title(['Probability Distribution of task ' num2str(taskB_number)]);
%     filename = [subj_fig_dir '/Switch_prob_bino_FPcentre.png'];
%     saveas(gcf,filename)
%     filename = [subj_fig_dir '/Switch_prob_bino_FPcentre.fig'];
%     saveas(gcf,filename)
    
    % stats test
    [h, p_ks, ksstat] = kstest2(binoriv_timing_taskA', binoriv_timing_taskB');
    disp(['Subject: ' data_dir_taskA(subj).name]);
    disp(['p-value [KS test]: ' num2str(p_ks)]);
    [p_mw, h, mwstat] = ranksum(binoriv_timing_taskA', binoriv_timing_taskB');
    disp(['Subject: ' data_dir_taskA(subj).name]);
    disp(['p-value [Mann-Whitney]: ' num2str(p_mw)]);
    figure;
    % Estimate the PDFs using ksdensity
    [f1,x1] = ksdensity(binoriv_timing_taskA');
    [f2,x2] = ksdensity(binoriv_timing_taskB');
    % Plot the PDFs on the same axes
    plot(x1,f1,'LineWidth',2);
    hold on;
    plot(x2,f2,'LineWidth',2);
    xlim([0 5])
    legend(['task ' num2str(taskA_number)],['task ' num2str(taskB_number)]);
    xlabel('Data values');
    ylabel('Probability density');
    title(['Comparison of Two Distributions: p=' num2str(p_ks)]);
%     filename = [subj_fig_dir '/Switch_prob_density_FPeffect.png'];
%     saveas(gcf,filename)
%     filename = [subj_fig_dir '/Switch_prob_density_FPeffect.fig'];
%     saveas(gcf,filename)
    
    % Create Q-Q plot with line of best fit
%     figure;
%     qqplot(binoriv_timing_taskA',binoriv_timing_taskB',fitdist())
%     filename = [subj_fig_dir '/Switch_prob_QQ_FPeffect.png'];
%     saveas(gcf,filename)
%     filename = [subj_fig_dir '/Switch_prob_QQ_FPeffect.fig'];
%     saveas(gcf,filename)

end

