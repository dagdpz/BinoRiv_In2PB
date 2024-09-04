% Author: Ryo Segawa (whizznihil.kid@gmail.com)
% Contributor: Ege Kingir (ege.kingir@med.uni-goettingen.de)
%% Distinguishes between two types of perceptual switches: Completed or Incomplete:
      %%% Gets perceptual switch latencies (PSLs) of completed and incomplete switches by investigating the timings of following state transitions:
            % Blue (or Red) -> PieceWise perception (both buttons pressed or no buttons pressed) -> Red (or Blue) means COMPLETED SWITCH
            % Blue (or Red) -> PieceWise perception -> Blue (or Red) means INCOMPLETE SWITCH
      %%% Plots gaze locations around the times of completed perceptual switches.
      %%% Performs single-task statistical tests to investigate the time-locking effect of external factors on PSLs
      %%% Plots test results coming from a single task.

%% Matlab 2021

clear all
close all
clc

taskNum=input('Enter the task number (1,2,3, or 4): ');

for taskA_number=taskNum:taskNum
    
    % subject = 17; %should be order: so for example for subject19 and task1, you should put 17 here because subject19 comes 17th in the folder...
    % task_pseudoChooping = true for ONLY TASK 2. Otherwise set it to false!
    if taskA_number ==2
        taskA_pseudoChopping = true; % Assign pseudo FP positions to task2 with the same random numbers as task1 and task3 to mimic the same reaction time plot scales as task1 and task3
    else
        taskA_pseudoChopping = false;
    end

    if taskA_number==1
        taskColor = [0.3 0.5 0.9];
    elseif taskA_number==2
        taskColor = [0.8 0.4 0.4];
    elseif taskA_number==3
        taskColor = [0.7 0.4 0.7];
    elseif taskA_number==4
        taskColor = [0.5 0.7 0.4];
    end
    
    data_dir_taskA = dir(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskA_number)]);
    data_dir_taskA = data_dir_taskA(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir_taskA.name})); % avoid '.' and '..'
    
    trial_count = 8;
    fig_dir = ['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\figures'];
    
    prob_dist_bino_taskA = [];
    prob_dist_phys_taskA = [];
    prob_dist_bino_taskB = [];
    prob_dist_phys_taskB = [];
    
    binoriv_timing_taskA_ins_allSubj = [];
    phys_timing_taskA_ins_allSubj = [];
    binoriv_timing_taskA_rel_allSubj = [];
    phys_timing_taskA_rel_allSubj = [];

    binoriv_first_switchTimingsAll = [];
    
    binoriv_timing_taskA_ins_allSubjF1 = [];
    binoriv_timing_taskA_rel_allSubjF1 = [];
    
    which_switch_ins_allSubj = [];
    which_switch_rel_allSubj = [];
    
    disturb_timing_ins_allSubj = [];
    disturb_timing_rel_allSubj = [];
    
    disturb_timing_ins_allSubjPhys = [];
    disturb_timing_rel_allSubjPhys = [];
    
    bb=0; %these two are for instances to count the switches from red to blue (bb) and blue to red (rr), respectively
    rr=0;
    bb_phys = 0;
    rr_phys = 0;

    red_distR =[];
    blue_distR =[];
    red_distB = [];
    blue_distB = [];

    
    if taskA_number==1
        temp_dir = ['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task1\meanMedians\'];
        load([temp_dir 'trialsWithCombinedPS_inF1.mat']); 
    end

    trueAfterCombinedAll = [];
    
    
    for subj = 1:numel(data_dir_taskA)

    % for subj = subject:subject
        close all
        binoriv_timing_taskA_ins = [];
        phys_timing_taskA_ins = [];
        binoriv_timing_taskA_rel = [];
        phys_timing_taskA_rel = [];
        binoriv_timing_taskA_ins_f1 = [];
        binoriv_timing_taskA_rel_f1 = [];
        phys_timing_taskA_ins_f1 = [];
        phys_timing_taskA_rel_f1 = [];
        which_switch_ins = [];
        which_switch_rel = [];
        distCenter = [];
        distCenterPhys = [];
        distCenterTrl = [];
        distCenterTrlPhys = [];

        which_switch_rel = [];

        binoriv_first_switchTimings = [];
        
        num_red_presented = 0;
        num_blue_presented = 0;
        num_bino_presented = 0;
        num_red_cong = 0; % congruent with the stimulus
        num_blue_cong = 0;
    
        bb=0; %these two are for instances to count the switches from red to blue (bb) and blue to red (rr), respectively
        rr=0;
        b2p=0;
        r2p=0;
        p2r=0;
        p2b=0;
        b2p_trial=[];
        b2p_all=[];
        r2p_trial=[];
        r2p_all=[];
        p2b_trial=[];
        p2b_all=[];
        p2r_trial=[];
        p2r_all=[];
        
        b2pPhys=0;
        r2pPhys=0;
        p2rPhys=0;
        p2bPhys=0;
        b2p_trialPhys=[];
        b2p_allPhys=[];
        r2p_trialPhys=[];
        r2p_allPhys=[];
        p2b_trialPhys=[];
        p2b_allPhys=[];
        p2r_trialPhys=[];
        p2r_allPhys=[];
    
        disturb=0; %number of disturbances in perception
        disturbPhys=0;
        disturb_timing_ins = [];
        disturb_timing_rel = [];
    
        disturb_timing_insPhys = [];
        disturb_timing_relPhys = [];
    

        bb_phys = 0;
        rr_phys = 0;
        bbrel_phys =0;
        rrrel_phys = 0;
        red_distR =[];
        blue_distR =[];
        red_distB = [];
        blue_distB = [];

        red_distR_phys = [];
        blue_distR_phys = [];
        red_distB_phys = [];
        blue_distB_phys = [];

        

        trials_f1_Switch = []; %trial numbers where a switch within the first second happened (to calculate the percentage of such trials)
        trials_f1_Disturb = [];

        trueAfterCombined = [];

    
        mkdir([fig_dir '/' data_dir_taskA(subj).name])
        subj_fig_dir = ([fig_dir '/' data_dir_taskA(subj).name]);
        
        
        subj_dir = dir(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/*.mat']);
    %     subj_dir = dir(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task1/' data_dir_taskA(subj).name]);
        for file = 1:numel(subj_dir)
            data_taskA = load(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/' subj_dir(file).name]);
    %         data_taskA = load(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task1/' data_dir_taskA(subj).name]);
            %%  Interpolation -- added by EK 03.05.24
            X = []; %x coordinates of the eye
            Y = []; %y coordinates of the eye
            t = []; %time points at which samples are originally drawn from
            for tr=1:size(data_taskA.trial,2)
                X = [X data_taskA.trial(tr).x_eye'];
                Y = [Y data_taskA.trial(tr).y_eye'];
                t = [t data_taskA.trial(tr).tSample_from_time_start'];
            end
    
            [X_int,t_int] = resample(double(X),double(t),100);
            Y_int = resample(double(Y),double(t),100);

            
            % Calc num of phys stim presented & num of congruence:
            % If the last percept choice within a physical trial aligns with the physical stimulus, it is a successful trial
            for trl = 18:numel(data_taskA.trial)-1            
                if data_taskA.trial(trl).stimulus == 2
                    num_red_presented = num_red_presented + 1;
                    if (data_taskA.trial(trl).repo_red(data_taskA.trial(trl).counter) == 1) && (data_taskA.trial(trl).repo_blue(data_taskA.trial(trl).counter) == 0) 
                        num_red_cong = num_red_cong + 1;
                    end
                elseif data_taskA.trial(trl).stimulus == 3
                    num_blue_presented = num_blue_presented + 1;
                    if (data_taskA.trial(trl).repo_blue(data_taskA.trial(trl).counter) == 1) && (data_taskA.trial(trl).repo_red(data_taskA.trial(trl).counter) == 0)
                        num_blue_cong = num_blue_cong + 1;
                    end
                elseif data_taskA.trial(trl).stimulus == 4 && data_taskA.trial(trl-1).stimulus == 4 %because we discard the first trials from binoriv blocks.
                    num_bino_presented = num_bino_presented +1;
                end

            end
            %% Task 1 or 3 (or 2)
            if taskA_number == 2 && taskA_pseudoChopping
                rng(12345); %set the seed so that you create the same sequence of random numbers each time
                fix_loc_label = randi([1 4],1,numel(data_taskA.trial));
                for trl = 1:numel(data_taskA.trial)                
                    if fix_loc_label(trl) == 1
                        data_taskA.trial(trl).eye.fix.x.red = -1;
                        data_taskA.trial(trl).eye.fix.y.red = -1;
                    elseif fix_loc_label(trl) == 2
                        data_taskA.trial(trl).eye.fix.x.red = -2;
                        data_taskA.trial(trl).eye.fix.y.red = -2;
                    elseif fix_loc_label(trl) == 3
                        data_taskA.trial(trl).eye.fix.x.red = -3;
                        data_taskA.trial(trl).eye.fix.y.red = -3;
                    elseif fix_loc_label(trl) == 4
                        data_taskA.trial(trl).eye.fix.x.red = -4;
                        data_taskA.trial(trl).eye.fix.y.red = -4;
                    end
                end
            end
            
            if taskA_number == 1 || taskA_number == 3 || taskA_pseudoChopping
                %% Button insertion
                for trl = 18:numel(data_taskA.trial)-1               
                    % Binoriv 
                    if data_taskA.trial(trl).stimulus == 4
                        switch_count=0; %count the number of switches that happen within a trial! -- we are interested in binoriv condition only.
                        rb=0; %counter for red to blue switches
                        br=0; %counter for blue to red switches
                        f1=0; %whether a perceptual switch happened within the first second of a trial or not!
                        if data_taskA.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                            continue
                        end
                        trl_indices = find(t_int>data_taskA.trial(trl).tSample_from_time_start(1) & t_int<data_taskA.trial(trl).tSample_from_time_start(end));
                        X_eyeTrial = X_int(trl_indices);
                        Y_eyeTrial = Y_int(trl_indices);
                        distCenterTrl(end+1,:) = sqrt((X_eyeTrial(21:480)).^2 + (Y_eyeTrial(21:480)).^2);

                        for loop = 1:8
                            if data_taskA.trial(trl-loop).stimulus ~= 4
                                
                                for sample = 1:data_taskA.trial(trl).counter-1 %you are searching through all samples to find at which point after the FP jump there is a switch in perception.
                                    
                                    if (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %b2p - cond1
                                        b2p=b2p+1;
                                        b2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        b2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        b2p_trial(end+1) = b2p_timing;
                                        b2p_all(end+1) = b2p_timing_cum;
                                        
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %b2p - cond2
                                        b2p=b2p+1;
                                        b2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        b2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        b2p_trial(end+1) = b2p_timing;
                                        b2p_all(end+1) = b2p_timing_cum;
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %r2p - cond1
                                        r2p=r2p+1;
                                        r2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        r2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        r2p_trial(end+1) = r2p_timing;
                                        r2p_all(end+1) = r2p_timing_cum;
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %r2p - cond2
                                        r2p=r2p+1;
                                        r2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        r2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        r2p_trial(end+1) = r2p_timing;
                                        r2p_all(end+1) = r2p_timing_cum;
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %p2b - cond1
                                        p2b=p2b+1;
                                        p2b_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        p2b_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        p2b_all(end+1) = p2b_timing_cum;
                                        
                                        if ~isempty(p2b_all) && ~isempty(r2p_all)
                                            if (isempty(b2p_all) && (p2b_all(end)> r2p_all(end))) || ((p2b_all(end)> r2p_all(end)) && (r2p_all(end)>b2p_all(end)))
                                                switch_count = switch_count+1;
                                                rb=rb+1;
                                                switch_timing_ins = p2b_timing;
                                                switch_timing_rel = r2p_trial(end);
                                                which_switch_rel = [which_switch_rel switch_count];

                                                if switch_timing_ins <= 5
                                                    binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                    bb=bb+1;
                                                    %%% eye tracking -- Red
                                                    int_indices = find(t_int<r2p_all(end)+2 & t_int>r2p_all(end)-2);
                                                    x_eye_present = X_int(int_indices);
                                                    y_eye_present = Y_int(int_indices);
                                                    x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                    y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                    red_distB(bb,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
            
                                                    %%% eye tracking -- Blue
                                                    x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                    y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                    blue_distB(bb,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                                    distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
                                                                                                
                                                    if switch_timing_ins <= 1
                                                        binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins]; %so right now, f1 is used for the cases where only 1 switch happened within a trial!
                                                    end
                                                end
                                                if switch_timing_rel <=5
                                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];
                                                    
                                                    if switch_timing_rel <= 1
                                                        trials_f1_Switch = [trials_f1_Switch trl];
                                                    end
        
                                                    if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                    end

                                                    if switch_count==1
                                                        binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                    end

                                                    if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                        trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                    end
                                                end
                                            else
                                                disturb = disturb+1;
                                                disturb_timing_ins = [disturb_timing_ins p2b_timing];
                                                disturb_timing_rel = [disturb_timing_rel b2p_trial(end)];
                                                if b2p_trial(end) <= 1
                                                    trials_f1_Disturb = [trials_f1_Disturb trl];
                                                end
                                            end
                                        end
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %p2b - cond2
                                        p2b=p2b+1;
                                        p2b_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        p2b_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        p2b_all(end+1) = p2b_timing_cum;
    
                                        if ~isempty(p2b_all) && ~isempty(r2p_all)
                                            if (isempty(b2p_all) && (p2b_all(end)> r2p_all(end))) || ((p2b_all(end)> r2p_all(end)) && (r2p_all(end)>b2p_all(end)))
                                                switch_count = switch_count+1;
                                                rb=rb+1;
                                                switch_timing_ins = p2b_timing;
                                                switch_timing_rel = r2p_trial(end); %the last release from the red to piecewise-perception, before the switch to the blue perception.
                                                which_switch_rel = [which_switch_rel switch_count];
                                                if switch_timing_ins <= 5
                                                    binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                    bb=bb+1;
                                                    %%% eye tracking -- Red
                                                    int_indices = find(t_int<r2p_all(end)+2 & t_int>r2p_all(end)-2);
                                                    x_eye_present = X_int(int_indices);
                                                    y_eye_present = Y_int(int_indices);
                                                    x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                    y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                    red_distB(bb,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
            
                                                    %%% eye tracking -- Blue
                                                    x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                    y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                    blue_distB(bb,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                                    distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
        
                                                    if switch_timing_ins <= 1
                                                        binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                    end
                                                end
                                                if switch_timing_rel <=5
                                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                    if switch_timing_rel <= 1
                                                        trials_f1_Switch = [trials_f1_Switch trl];
                                                    end
        
                                                    if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                    end

                                                    if switch_count==1
                                                        binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                    end

                                                    if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                        trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                    end
                                                end
                                            else
                                                disturb = disturb+1;
                                                disturb_timing_ins = [disturb_timing_ins p2b_timing];
                                                disturb_timing_rel = [disturb_timing_rel b2p_trial(end)];
                                                if b2p_trial(end) <= 1
                                                    trials_f1_Disturb = [trials_f1_Disturb trl];
                                                end
                                            end
                                        end
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %p2r - cond1
                                        p2r=p2r+1;
                                        p2r_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        p2r_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        p2r_all(end+1) = p2r_timing_cum;
    
                                        if ~isempty(p2b_all) && ~isempty(b2p_all)
                                            if (isempty(r2p_all) && (p2r_all(end)> b2p_all(end))) || ((p2r_all(end)> b2p_all(end)) && (b2p_all(end)> r2p_all(end)))
                                                switch_count = switch_count+1;
                                                br=br+1;
                                                switch_timing_ins = p2r_timing;
                                                switch_timing_rel = b2p_trial(end);
                                                which_switch_rel = [which_switch_rel switch_count];
                                                if switch_timing_ins <= 5
                                                    binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                    rr=rr+1;
                                                    %%% eye tracking -- Red
                                                    int_indices = find(t_int<b2p_all(end)+2 & t_int>b2p_all(end)-2);
                                                    x_eye_present = X_int(int_indices);
                                                    y_eye_present = Y_int(int_indices);
                                                    x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                    y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                    red_distR(rr,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
            
                                                    %%% eye tracking -- Blue
                                                    x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                    y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                    blue_distR(rr,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                                    distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
        
                                                    if switch_timing_ins <= 1
                                                        binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                    end
                                                end
                                                if switch_timing_rel <=5
                                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                    if switch_timing_rel <= 1
                                                        trials_f1_Switch = [trials_f1_Switch trl];
                                                    end
        
                                                    if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                    end

                                                    if switch_count==1
                                                        binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                    end

                                                    if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                        trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                    end
                                                end
                                            else
                                                disturb = disturb+1;
                                                disturb_timing_ins = [disturb_timing_ins p2r_timing];
                                                disturb_timing_rel = [disturb_timing_rel r2p_trial(end)];
                                                if r2p_trial(end) <= 1
                                                    trials_f1_Disturb = [trials_f1_Disturb trl];
                                                end
                                            end
                                        end
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %p2r - cond2
                                        p2r=p2r+1;
                                        p2r_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        p2r_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        p2r_all(end+1) = p2r_timing_cum;
    
                                        if ~isempty(p2b_all) && ~isempty(b2p_all)
                                            if (isempty(r2p_all) && (p2r_all(end)> b2p_all(end))) || ((p2r_all(end)> b2p_all(end)) && (b2p_all(end)> r2p_all(end)))
                                                switch_count = switch_count+1;
                                                br=br+1;
                                                switch_timing_ins = p2r_timing;
                                                switch_timing_rel = b2p_trial(end);
                                                which_switch_rel = [which_switch_rel switch_count];
                                                if switch_timing_ins <= 5
                                                    binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                    rr=rr+1;
                                                    %%% eye tracking -- Red
                                                    int_indices = find(t_int<b2p_all(end)+2 & t_int>b2p_all(end)-2);
                                                    x_eye_present = X_int(int_indices);
                                                    y_eye_present = Y_int(int_indices);
                                                    x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                    y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                    red_distR(rr,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
            
                                                    %%% eye tracking -- Blue
                                                    x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                    y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                    blue_distR(rr,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                                    distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
        
                                                    if switch_timing_ins <= 1
                                                        binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                    end
                                                end
                                                if switch_timing_rel <=5
                                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                    if switch_timing_rel <= 1
                                                        trials_f1_Switch = [trials_f1_Switch trl];
                                                    end
        
                                                    if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                    end

                                                    if switch_count==1
                                                        binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                    end

                                                    if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                        trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                    end
                                                end
                                            else
                                                disturb = disturb+1;
                                                disturb_timing_ins = [disturb_timing_ins p2r_timing];
                                                disturb_timing_rel = [disturb_timing_rel r2p_trial(end)];
                                                if r2p_trial(end) <= 1
                                                    trials_f1_Disturb = [trials_f1_Disturb trl];
                                                end
                                            end
                                        end
    
                                    end
                                end
    
                                break
                            end
    
                            if data_taskA.trial(trl-loop).eye.fix.x.red == data_taskA.trial(trl).eye.fix.x.red &&...
                                data_taskA.trial(trl-loop).eye.fix.y.red == data_taskA.trial(trl).eye.fix.y.red

                                if any(find(data_taskA.trial(trl-loop).repo_red)) == 1 && any(find(data_taskA.trial(trl-loop).repo_blue)) == 1
                                    break
                                elseif any(find(data_taskA.trial(trl-loop).repo_red)) == 0 && any(find(data_taskA.trial(trl-loop).repo_red)) == 1 ||...
                                        any(find(data_taskA.trial(trl-loop).repo_blue)) == 0 && any(find(data_taskA.trial(trl-loop).repo_blue)) == 1 
                                    break
                                else
                                    for sample = 1:data_taskA.trial(trl).counter-1
                                        if (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %b2p - cond1
                                            b2p=b2p+1;
                                            b2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                            b2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                            b2p_trial(end+1) = b2p_timing;
                                            b2p_all(end+1) = b2p_timing_cum;
                                            
                                        elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %b2p - cond2
                                            b2p=b2p+1;
                                            b2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                            b2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                            b2p_trial(end+1) = b2p_timing;
                                            b2p_all(end+1) = b2p_timing_cum;
        
                                        elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %r2p - cond1
                                            r2p=r2p+1;
                                            r2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                            r2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                            r2p_trial(end+1) = r2p_timing;
                                            r2p_all(end+1) = r2p_timing_cum;
        
                                        elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %r2p - cond2
                                            r2p=r2p+1;
                                            r2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                            r2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                            r2p_trial(end+1) = r2p_timing;
                                            r2p_all(end+1) = r2p_timing_cum;
        
                                        elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %p2b - cond1
                                            p2b=p2b+1;
                                            p2b_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                            p2b_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                            p2b_all(end+1) = p2b_timing_cum;
    
                                            if ~isempty(p2b_all) && ~isempty(r2p_all)
                                                if (isempty(b2p_all) && (p2b_all(end)> r2p_all(end))) || ((p2b_all(end)> r2p_all(end)) && (r2p_all(end)>b2p_all(end)))
                                                    switch_count = switch_count+1;
                                                    rb=rb+1;
                                                    switch_timing_ins = p2b_timing;
                                                    switch_timing_rel = r2p_trial(end);
                                                    which_switch_rel = [which_switch_rel switch_count];
                                                    if switch_timing_ins <= 5
                                                        binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                        bb=bb+1;
                                                        %%% eye tracking -- Red
                                                        int_indices = find(t_int<r2p_all(end)+2 & t_int>r2p_all(end)-2);
                                                        x_eye_present = X_int(int_indices);
                                                        y_eye_present = Y_int(int_indices);
                                                        x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                        y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                        red_distB(bb,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                
                                                        %%% eye tracking -- Blue
                                                        x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                        y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                        blue_distB(bb,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                        
                                                        distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
            
                                                        if switch_timing_ins <= 1
                                                            binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                        end
                                                    end
                                                    if switch_timing_rel <=5
                                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                        if switch_timing_rel <= 1
                                                            trials_f1_Switch = [trials_f1_Switch trl];
                                                        end
            
                                                        if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                            binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                        end

                                                        if switch_count==1
                                                            binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                        end

                                                        if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                            trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                        end
                                                    end
                                                else
                                                    disturb = disturb+1;
                                                    disturb_timing_ins = [disturb_timing_ins p2b_timing];
                                                    disturb_timing_rel = [disturb_timing_rel b2p_trial(end)];
                                                    if b2p_trial(end) <= 1
                                                        trials_f1_Disturb = [trials_f1_Disturb trl];
                                                    end
                                                end
                                            end
        
                                        elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %p2b - cond2
                                            p2b=p2b+1;
                                            p2b_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                            p2b_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                            p2b_all(end+1) = p2b_timing_cum;
                                            
                                            if ~isempty(p2b_all) && ~isempty(r2p_all)
                                                if (isempty(b2p_all) && (p2b_all(end)> r2p_all(end))) || ((p2b_all(end)> r2p_all(end)) && (r2p_all(end)>b2p_all(end)))
                                                    switch_count = switch_count+1;
                                                    rb=rb+1;
                                                    switch_timing_ins = p2b_timing;
                                                    switch_timing_rel = r2p_trial(end);
                                                    which_switch_rel = [which_switch_rel switch_count];
                                                    if switch_timing_ins <= 5
                                                        binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                        bb=bb+1;
                                                        %%% eye tracking -- Red
                                                        int_indices = find(t_int<r2p_all(end)+2 & t_int>r2p_all(end)-2);
                                                        x_eye_present = X_int(int_indices);
                                                        y_eye_present = Y_int(int_indices);
                                                        x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                        y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                        red_distB(bb,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                
                                                        %%% eye tracking -- Blue
                                                        x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                        y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                        blue_distB(bb,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                        
                                                        distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
            
                                                        if switch_timing_ins <= 1
                                                            binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                        end
                                                    end
                                                    if switch_timing_rel <=5
                                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                        if switch_timing_rel <= 1
                                                            trials_f1_Switch = [trials_f1_Switch trl];
                                                        end
            
                                                        if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                            binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                        end

                                                        if switch_count==1
                                                            binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                        end

                                                        if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                            trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                        end
                                                    end
                                                else
                                                    disturb = disturb+1;
                                                    disturb_timing_ins = [disturb_timing_ins p2b_timing];
                                                    disturb_timing_rel = [disturb_timing_rel b2p_trial(end)];
                                                    if b2p_trial(end) <= 1
                                                        trials_f1_Disturb = [trials_f1_Disturb trl];
                                                    end
                                                end
                                            end
        
                                        elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %p2r - cond1
                                            p2r=p2r+1;
                                            p2r_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                            p2r_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                            p2r_all(end+1) = p2r_timing_cum;
    
                                            if ~isempty(p2b_all) && ~isempty(b2p_all)
                                                if (isempty(r2p_all) && (p2r_all(end)> b2p_all(end))) || ((p2r_all(end)> b2p_all(end)) && (b2p_all(end)> r2p_all(end)))
                                                    switch_count = switch_count+1;
                                                    br=br+1;
                                                    switch_timing_ins = p2r_timing;
                                                    switch_timing_rel = b2p_trial(end);
                                                    which_switch_rel = [which_switch_rel switch_count];
                                                    if switch_timing_ins <= 5
                                                        binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                        rr=rr+1;
                                                        %%% eye tracking -- Red
                                                        int_indices = find(t_int<b2p_all(end)+2 & t_int>b2p_all(end)-2);
                                                        x_eye_present = X_int(int_indices);
                                                        y_eye_present = Y_int(int_indices);
                                                        x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                        y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                        red_distR(rr,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                
                                                        %%% eye tracking -- Blue
                                                        x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                        y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                        blue_distR(rr,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                        
                                                        distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
            
                                                        if switch_timing_ins <= 1
                                                            binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                        end
                                                    end
                                                    if switch_timing_rel <=5
                                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                        if switch_timing_rel <= 1
                                                            trials_f1_Switch = [trials_f1_Switch trl];
                                                        end
            
                                                        if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                            binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                        end

                                                        if switch_count==1
                                                            binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                        end

                                                        if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                            trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                        end
                                                    end
                                                else
                                                    disturb = disturb+1;
                                                    disturb_timing_ins = [disturb_timing_ins p2r_timing];
                                                    disturb_timing_rel = [disturb_timing_rel r2p_trial(end)];
                                                    if r2p_trial(end) <= 1
                                                        trials_f1_Disturb = [trials_f1_Disturb trl];
                                                    end
                                                end
                                            end
        
                                        elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %p2r - cond2
                                            p2r=p2r+1;
                                            p2r_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                            p2r_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                            p2r_all(end+1) = p2r_timing_cum;
    
                                            if ~isempty(p2b_all) && ~isempty(b2p_all)
                                                if (isempty(r2p_all) && (p2r_all(end)> b2p_all(end))) || ((p2r_all(end)> b2p_all(end)) && (b2p_all(end)> r2p_all(end)))
                                                    switch_count = switch_count+1;
                                                    br=br+1;
                                                    switch_timing_ins = p2r_timing;
                                                    switch_timing_rel = b2p_trial(end);
                                                    which_switch_rel = [which_switch_rel switch_count];
                                                    if switch_timing_ins <= 5
                                                        binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                        rr=rr+1;
                                                        %%% eye tracking -- Red
                                                        int_indices = find(t_int<b2p_all(end)+2 & t_int>b2p_all(end)-2);
                                                        x_eye_present = X_int(int_indices);
                                                        y_eye_present = Y_int(int_indices);
                                                        x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                        y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                        red_distR(rr,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                
                                                        %%% eye tracking -- Blue
                                                        x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                        y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                        blue_distR(rr,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                        
                                                        distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
            
                                                        if switch_timing_ins <= 1
                                                            binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                        end
                                                    end
                                                    if switch_timing_rel <=5
                                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                        if switch_timing_rel <= 1
                                                            trials_f1_Switch = [trials_f1_Switch trl];
                                                        end
            
                                                        if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                            binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                        end

                                                        if switch_count==1
                                                            binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                        end

                                                        if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                            trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                        end
                                                    end
                                                else
                                                    disturb = disturb+1;
                                                    disturb_timing_ins = [disturb_timing_ins p2r_timing];
                                                    disturb_timing_rel = [disturb_timing_rel r2p_trial(end)];
                                                    if r2p_trial(end) <= 1
                                                        trials_f1_Disturb = [trials_f1_Disturb trl];
                                                    end
                                                end
                                            end
    
                                        end
                                    end        
                                end
                                break
                            else
                                for sample = 1:data_taskA.trial(trl).counter-1
                                    if (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %b2p - cond1
                                        b2p=b2p+1;
                                        b2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        b2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        b2p_trial(end+1) = b2p_timing;
                                        b2p_all(end+1) = b2p_timing_cum;
                                        
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %b2p - cond2
                                        b2p=b2p+1;
                                        b2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        b2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        b2p_trial(end+1) = b2p_timing;
                                        b2p_all(end+1) = b2p_timing_cum;
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %r2p - cond1
                                        r2p=r2p+1;
                                        r2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        r2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        r2p_trial(end+1) = r2p_timing;
                                        r2p_all(end+1) = r2p_timing_cum;
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %r2p - cond2
                                        r2p=r2p+1;
                                        r2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        r2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        r2p_trial(end+1) = r2p_timing;
                                        r2p_all(end+1) = r2p_timing_cum;
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %p2b - cond1
                                        p2b=p2b+1;
                                        p2b_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        p2b_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        p2b_all(end+1) = p2b_timing_cum;
    
                                        if ~isempty(p2b_all) && ~isempty(r2p_all)
                                            if (isempty(b2p_all) && (p2b_all(end)> r2p_all(end))) || ((p2b_all(end)> r2p_all(end)) && (r2p_all(end)>b2p_all(end)))
                                                switch_count = switch_count+1;
                                                rb=rb+1;
                                                switch_timing_ins = p2b_timing;
                                                switch_timing_rel = r2p_trial(end);
                                                which_switch_rel = [which_switch_rel switch_count];
                                                if switch_timing_ins <= 5
                                                    binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                    bb=bb+1;
                                                    %%% eye tracking -- Red
                                                    int_indices = find(t_int<r2p_all(end)+2 & t_int>r2p_all(end)-2);
                                                    x_eye_present = X_int(int_indices);
                                                    y_eye_present = Y_int(int_indices);
                                                    x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                    y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                    red_distB(bb,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
            
                                                    %%% eye tracking -- Blue
                                                    x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                    y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                    blue_distB(bb,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                                    distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
        
                                                    if switch_timing_ins <= 1
                                                        binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                    end
                                                end
                                                if switch_timing_rel <=5
                                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                    if switch_timing_rel <= 1
                                                        trials_f1_Switch = [trials_f1_Switch trl];
                                                    end
        
                                                    if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                    end

                                                    if switch_count==1
                                                        binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                    end

                                                    if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                        trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                    end
                                                end
                                            else
                                                disturb = disturb+1;
                                                disturb_timing_ins = [disturb_timing_ins p2b_timing];
                                                disturb_timing_rel = [disturb_timing_rel b2p_trial(end)];
                                                if b2p_trial(end) <= 1
                                                    trials_f1_Disturb = [trials_f1_Disturb trl];
                                                end
                                            end
                                        end
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %p2b - cond2
                                        p2b=p2b+1;
                                        p2b_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        p2b_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        p2b_all(end+1) = p2b_timing_cum;
    
                                        if ~isempty(p2b_all) && ~isempty(r2p_all)
                                            if (isempty(b2p_all) && (p2b_all(end)> r2p_all(end))) || ((p2b_all(end)> r2p_all(end)) && (r2p_all(end)>b2p_all(end)))
                                                switch_count = switch_count+1;
                                                rb=rb+1;
                                                switch_timing_ins = p2b_timing;
                                                switch_timing_rel = r2p_trial(end);
                                                which_switch_rel = [which_switch_rel switch_count];
                                                if switch_timing_ins <= 5
                                                    binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                    bb=bb+1;
                                                    %%% eye tracking -- Red
                                                    int_indices = find(t_int<r2p_all(end)+2 & t_int>r2p_all(end)-2);
                                                    x_eye_present = X_int(int_indices);
                                                    y_eye_present = Y_int(int_indices);
                                                    x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                    y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                    red_distB(bb,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
            
                                                    %%% eye tracking -- Blue
                                                    x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                    y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                    blue_distB(bb,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                                    distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
        
                                                    if switch_timing_ins <= 1
                                                        binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                    end
                                                end
                                                if switch_timing_rel <=5
                                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                    if switch_timing_rel <= 1
                                                        trials_f1_Switch = [trials_f1_Switch trl];
                                                    end
        
                                                    if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                    end

                                                    if switch_count==1
                                                        binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                    end

                                                    if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                        trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                    end
                                                end
                                            else
                                                disturb = disturb+1;
                                                disturb_timing_ins = [disturb_timing_ins p2b_timing];
                                                disturb_timing_rel = [disturb_timing_rel b2p_trial(end)];
                                                if b2p_trial(end) <= 1
                                                    trials_f1_Disturb = [trials_f1_Disturb trl];
                                                end
                                            end
                                        end
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %p2r - cond1
                                        p2r=p2r+1;
                                        p2r_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        p2r_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        p2r_all(end+1) = p2r_timing_cum;
    
                                        if ~isempty(p2b_all) && ~isempty(b2p_all)
                                            if (isempty(r2p_all) && (p2r_all(end)> b2p_all(end))) || ((p2r_all(end)> b2p_all(end)) && (b2p_all(end)> r2p_all(end)))
                                                switch_count = switch_count+1;
                                                br=br+1;
                                                switch_timing_ins = p2r_timing;
                                                switch_timing_rel = b2p_trial(end);
                                                which_switch_rel = [which_switch_rel switch_count];
                                                if switch_timing_ins <= 5
                                                    binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                    rr=rr+1;
                                                    %%% eye tracking -- Red
                                                    int_indices = find(t_int<b2p_all(end)+2 & t_int>b2p_all(end)-2);
                                                    x_eye_present = X_int(int_indices);
                                                    y_eye_present = Y_int(int_indices);
                                                    x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                    y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                    red_distR(rr,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
            
                                                    %%% eye tracking -- Blue
                                                    x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                    y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                    blue_distR(rr,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                                    distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
        
                                                    if switch_timing_ins <= 1
                                                        binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                    end
                                                end
                                                if switch_timing_rel <=5
                                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                    if switch_timing_rel <= 1
                                                        trials_f1_Switch = [trials_f1_Switch trl];
                                                    end
        
                                                    if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                                    end

                                                    if switch_count==1
                                                        binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                    end

                                                    if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                        trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                    end
                                                end
                                            else
                                                disturb = disturb+1;
                                                disturb_timing_ins = [disturb_timing_ins p2r_timing];
                                                disturb_timing_rel = [disturb_timing_rel r2p_trial(end)];
                                                if r2p_trial(end) <= 1
                                                    trials_f1_Disturb = [trials_f1_Disturb trl];
                                                end
                                            end
                                        end
    
                                    elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %p2r - cond2
                                        p2r=p2r+1;
                                        p2r_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        p2r_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                        p2r_all(end+1) = p2r_timing_cum;
    
                                        if ~isempty(p2b_all) && ~isempty(b2p_all)
                                            if (isempty(r2p_all) && (p2r_all(end)> b2p_all(end))) || ((p2r_all(end)> b2p_all(end)) && (b2p_all(end)> r2p_all(end)))
                                                switch_count = switch_count+1;
                                                br=br+1;
                                                switch_timing_ins = p2r_timing;
                                                switch_timing_rel = b2p_trial(end);
                                                which_switch_rel = [which_switch_rel switch_count];
                                                if switch_timing_ins <= 5
                                                    binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                                    rr=rr+1;
                                                    %%% eye tracking -- Red
                                                    int_indices = find(t_int<b2p_all(end)+2 & t_int>b2p_all(end)-2);
                                                    x_eye_present = X_int(int_indices);
                                                    y_eye_present = Y_int(int_indices);
                                                    x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                    y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                    red_distR(rr,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
            
                                                    %%% eye tracking -- Blue
                                                    x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                    y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                    blue_distR(rr,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                                    distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
        
                                                    if switch_timing_ins <= 1
                                                        binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                                    end
                                                end
                                                if switch_timing_rel <=5
                                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                                    if switch_timing_rel <= 1
                                                        trials_f1_Switch = [trials_f1_Switch trl];
                                                    end
        
                                                    if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_ins];
                                                    end

                                                    if switch_count==1
                                                        binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                                    end
 
                                                    if taskA_number==1 && ismember(trl,trials_w_PC_inF1{subj,1}) && switch_timing_rel>1
                                                        trueAfterCombined = [trueAfterCombined switch_timing_rel];
                                                    end
                                                end
                                            else
                                                disturb = disturb+1;
                                                disturb_timing_ins = [disturb_timing_ins p2r_timing];
                                                disturb_timing_rel = [disturb_timing_rel r2p_trial(end)];
                                                if r2p_trial(end) <= 1
                                                    trials_f1_Disturb = [trials_f1_Disturb trl];
                                                end
                                            end
                                        end
                                    end
                                end
                                break
                            end
                        end
    
    
    
                    % Phys 
                    elseif data_taskA.trial(trl).stimulus == 2  && data_taskA.trial(trl+1).stimulus ~= 2 %red
                        for loop = 1:4
                            if data_taskA.trial(trl-loop).stimulus ~= 2
                                min_trl = trl-loop + 1;
                            end
                        end
                        trlPhys_indices = find(t_int>data_taskA.trial(trl).tSample_from_time_start(1) & t_int<data_taskA.trial(trl).tSample_from_time_start(end));
                        X_eyeTrialP = X_int(trlPhys_indices);
                        Y_eyeTrialP = Y_int(trlPhys_indices);
                        distCenterTrlPhys(end+1,:) = sqrt((X_eyeTrialP(21:480)).^2 + (Y_eyeTrialP(21:480).^2));
                        
                        percept_change = false;
                        for cont_trl = min_trl:trl
                            for sample = 1:data_taskA.trial(cont_trl).counter-1
                                if (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %b2p - cond1
                                    b2pPhys=b2pPhys+1;
                                    b2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    b2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    b2p_trialPhys(end+1) = b2p_timingPhys;
                                    b2p_allPhys(end+1) = b2p_timing_cumPhys;
                                    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %b2p - cond2
                                    b2pPhys=b2pPhys+1;
                                    b2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    b2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    b2p_trialPhys(end+1) = b2p_timingPhys;
                                    b2p_allPhys(end+1) = b2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %r2p - cond1
                                    r2pPhys=r2pPhys+1;
                                    r2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    r2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    r2p_trialPhys(end+1) = r2p_timingPhys;
                                    r2p_allPhys(end+1) = r2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %r2p - cond2
                                    r2pPhys=r2pPhys+1;
                                    r2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    r2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    r2p_trialPhys(end+1) = r2p_timingPhys;
                                    r2p_allPhys(end+1) = r2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %p2b - cond1
                                    p2bPhys=p2bPhys+1;
                                    p2b_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2b_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2b_allPhys(end+1) = p2b_timing_cumPhys;
                                    
                                    if ~isempty(p2b_allPhys) && ~isempty(r2p_allPhys)
                                        if (isempty(b2p_allPhys) && (p2b_allPhys(end)> r2p_allPhys(end))) || ((p2b_allPhys(end)> r2p_allPhys(end)) && (r2p_allPhys(end)>b2p_allPhys(end)))
                                            switch_timing_insPhys = p2b_timingPhys;
                                            switch_timing_relPhys = r2p_trialPhys(end);
                                            percept_change = true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                bb_phys=bb_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<r2p_allPhys(end)+2 & t_int>r2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
    
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2b_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys b2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %p2b - cond2
                                    p2bPhys=p2bPhys+1;
                                    p2b_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2b_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2b_allPhys(end+1) = p2b_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(r2p_allPhys)
                                        if (isempty(b2p_allPhys) && (p2b_allPhys(end)> r2p_allPhys(end))) || ((p2b_allPhys(end)> r2p_allPhys(end)) && (r2p_allPhys(end)>b2p_allPhys(end)))
                                            switch_timing_insPhys = p2b_timingPhys;
                                            switch_timing_relPhys = r2p_trialPhys(end); %the last release from the red to piecewise-perception, before the switch to the blue perception.
                                            percept_change = true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                bb_phys=bb_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<r2p_allPhys(end)+2 & t_int>r2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end

                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2b_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys b2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %p2r - cond1
                                    p2rPhys=p2rPhys+1;
                                    p2r_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2r_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2r_allPhys(end+1) = p2r_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(b2p_allPhys)
                                        if (isempty(r2p_allPhys) && (p2r_allPhys(end)> b2p_allPhys(end))) || ((p2r_allPhys(end)> b2p_allPhys(end)) && (b2p_allPhys(end)> r2p_allPhys(end)))
                                            switch_timing_insPhys = p2r_timingPhys;
                                            switch_timing_relPhys = b2p_trialPhys(end);
                                            percept_change = true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                rr_phys=rr_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<b2p_allPhys(end)+2 & t_int>b2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
    
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2r_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys r2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %p2r - cond2
                                    p2rPhys=p2rPhys+1;
                                    p2r_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2r_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2r_allPhys(end+1) = p2r_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(b2p_allPhys)
                                        if (isempty(r2p_allPhys) && (p2r_allPhys(end)> b2p_allPhys(end))) || ((p2r_allPhys(end)> b2p_allPhys(end)) && (b2p_allPhys(end)> r2p_allPhys(end)))
                                            switch_timing_insPhys = p2r_timingPhys;
                                            switch_timing_relPhys = b2p_trialPhys(end);
                                            percept_change = true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                rr_phys=rr_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<b2p_allPhys(end)+2 & t_int>b2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end

                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2r_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys r2p_trialPhys(end)];
                                        end
                                    end
                                    
                                end
                            end
                            if percept_change
                                break
                            end
                        end                     
    
                    elseif data_taskA.trial(trl).stimulus == 3 && data_taskA.trial(trl+1).stimulus ~= 3 %blue
                        for loop = 1:4
                            if data_taskA.trial(trl-loop).stimulus ~= 3
                                min_trl = trl-loop + 1;
                            end
                        end

                        trlPhys_indices = find(t_int>data_taskA.trial(trl).tSample_from_time_start(1) & t_int<data_taskA.trial(trl).tSample_from_time_start(end));
                        X_eyeTrialP = X_int(trlPhys_indices);
                        Y_eyeTrialP = Y_int(trlPhys_indices);
                        distCenterTrlPhys(end+1,:) = sqrt((X_eyeTrialP(21:480)).^2 + (Y_eyeTrialP(21:480).^2));
                        
                        percept_change = false;
                        for cont_trl = min_trl:trl
                            for sample = 1:data_taskA.trial(cont_trl).counter-1
                                if (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %b2p - cond1
                                    b2pPhys=b2pPhys+1;
                                    b2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    b2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    b2p_trialPhys(end+1) = b2p_timingPhys;
                                    b2p_allPhys(end+1) = b2p_timing_cumPhys;
                                    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %b2p - cond2
                                    b2pPhys=b2pPhys+1;
                                    b2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    b2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    b2p_trialPhys(end+1) = b2p_timingPhys;
                                    b2p_allPhys(end+1) = b2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %r2p - cond1
                                    r2pPhys=r2pPhys+1;
                                    r2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    r2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    r2p_trialPhys(end+1) = r2p_timingPhys;
                                    r2p_allPhys(end+1) = r2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %r2p - cond2
                                    r2pPhys=r2pPhys+1;
                                    r2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    r2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    r2p_trialPhys(end+1) = r2p_timingPhys;
                                    r2p_allPhys(end+1) = r2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %p2b - cond1
                                    p2bPhys=p2bPhys+1;
                                    p2b_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2b_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2b_allPhys(end+1) = p2b_timing_cumPhys;
                                    
                                    if ~isempty(p2b_allPhys) && ~isempty(r2p_allPhys)
                                        if (isempty(b2p_allPhys) && (p2b_allPhys(end)> r2p_allPhys(end))) || ((p2b_allPhys(end)> r2p_allPhys(end)) && (r2p_allPhys(end)>b2p_allPhys(end)))
                                            switch_timing_insPhys = p2b_timingPhys;
                                            switch_timing_relPhys = r2p_trialPhys(end);
                                            percept_change = true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                bb_phys=bb_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<r2p_allPhys(end)+2 & t_int>r2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
    
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2b_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys b2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %p2b - cond2
                                    p2bPhys=p2bPhys+1;
                                    p2b_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2b_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2b_allPhys(end+1) = p2b_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(r2p_allPhys)
                                        if (isempty(b2p_allPhys) && (p2b_allPhys(end)> r2p_allPhys(end))) || ((p2b_allPhys(end)> r2p_allPhys(end)) && (r2p_allPhys(end)>b2p_allPhys(end)))

                                            switch_timing_insPhys = p2b_timingPhys;
                                            switch_timing_relPhys = r2p_trialPhys(end); %the last release from the red to piecewise-perception, before the switch to the blue perception.
                                            percept_change = true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                bb_phys=bb_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<r2p_allPhys(end)+2 & t_int>r2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end

                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2b_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys b2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %p2r - cond1
                                    p2rPhys=p2rPhys+1;
                                    p2r_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2r_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2r_allPhys(end+1) = p2r_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(b2p_allPhys)
                                        if (isempty(r2p_allPhys) && (p2r_allPhys(end)> b2p_allPhys(end))) || ((p2r_allPhys(end)> b2p_allPhys(end)) && (b2p_allPhys(end)> r2p_allPhys(end)))

                                            switch_timing_insPhys = p2r_timingPhys;
                                            switch_timing_relPhys = b2p_trialPhys(end);
                                            percept_change = true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                rr_phys=rr_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<b2p_allPhys(end)+2 & t_int>b2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
    
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2r_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys r2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %p2r - cond2
                                    p2rPhys=p2rPhys+1;
                                    p2r_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2r_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2r_allPhys(end+1) = p2r_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(b2p_allPhys)
                                        if (isempty(r2p_allPhys) && (p2r_allPhys(end)> b2p_allPhys(end))) || ((p2r_allPhys(end)> b2p_allPhys(end)) && (b2p_allPhys(end)> r2p_allPhys(end)))
                                            switch_timing_insPhys = p2r_timingPhys;
                                            switch_timing_relPhys = b2p_trialPhys(end);
                                            percept_change = true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                rr_phys=rr_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<b2p_allPhys(end)+2 & t_int>b2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end

                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2r_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys r2p_trialPhys(end)];
                                        end
                                    end
    
                                end
                            end
                            if percept_change
                                break
                            end
                        end
                        
                    end        
                end
    
            elseif taskA_number == 2 || taskA_number == 4
                if taskA_number == 2 && taskA_pseudoChopping
                    continue
                end
                %% Button insertion
    %             for trl = 1:numel(data_taskA.trial)-1
                for trl = 18:numel(data_taskA.trial)-1
                    switch_count=0; %count the number of switches that happen within a trial! -- we are interested in binoriv condition only.
                    rb=0; %counter for red to blue switches
                    br=0; %counter for blue to red switches
                    f1=0; %whether a perceptual switch happened within the first second of a trial or not!
                    % Binoriv 
                    if data_taskA.trial(trl).stimulus == 4
                        if data_taskA.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                            continue
                        end
                        
                        if data_taskA.trial(trl-1).stimulus == 1 || data_taskA.trial(trl-1).stimulus == 2 || data_taskA.trial(trl-1).stimulus == 3 % remove the first trial from each block
                            continue
                        end
                        for sample = 1:data_taskA.trial(trl).counter-1
                            if (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %b2p - cond1
                                b2p=b2p+1;
                                b2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                b2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                b2p_trial(end+1) = b2p_timing;
                                b2p_all(end+1) = b2p_timing_cum;
                                
                            elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %b2p - cond2
                                b2p=b2p+1;
                                b2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                b2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                b2p_trial(end+1) = b2p_timing;
                                b2p_all(end+1) = b2p_timing_cum;
    
                            elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %r2p - cond1
                                r2p=r2p+1;
                                r2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                r2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                r2p_trial(end+1) = r2p_timing;
                                r2p_all(end+1) = r2p_timing_cum;
    
                            elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %r2p - cond2
                                r2p=r2p+1;
                                r2p_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                r2p_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                r2p_trial(end+1) = r2p_timing;
                                r2p_all(end+1) = r2p_timing_cum;
    
                            elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %p2b - cond1
                                p2b=p2b+1;
                                p2b_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                p2b_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                p2b_all(end+1) = p2b_timing_cum;
                                
                                if ~isempty(p2b_all) && ~isempty(r2p_all)
                                    if (isempty(b2p_all) && (p2b_all(end)> r2p_all(end))) || ((p2b_all(end)> r2p_all(end)) && (r2p_all(end)>b2p_all(end)))
                                        switch_count = switch_count+1;
                                        rb=rb+1;
                                        switch_timing_ins = p2b_timing;
                                        switch_timing_rel = r2p_trial(end);
                                        which_switch_rel = [which_switch_rel switch_count];
                                        if switch_timing_ins <= 5
                                            binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                            bb=bb+1;
                                            %%% eye tracking -- Red
                                            int_indices = find(t_int<r2p_all(end)+2 & t_int>r2p_all(end)-2);
                                            x_eye_present = X_int(int_indices);
                                            y_eye_present = Y_int(int_indices);
                                            x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                            y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                            red_distB(bb,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
    
                                            %%% eye tracking -- Blue
                                            x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                            y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                            blue_distB(bb,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                            distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
    
                                            if switch_timing_ins <= 1
                                                binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins]; %so right now, f1 is used for the cases where only 1 switch happened within a trial!
                                            end
                                        end
                                        if switch_timing_rel <=5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                            if switch_timing_rel <= 1
                                                trials_f1_Switch = [trials_f1_Switch trl];
                                            end
    
                                            if switch_timing_rel <=1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                            end

                                            if switch_count==1
                                                binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                            end
                                        end
                                    else
                                        disturb = disturb+1;
                                        disturb_timing_ins = [disturb_timing_ins p2b_timing];
                                        disturb_timing_rel = [disturb_timing_rel b2p_trial(end)];
                                        if b2p_trial(end) <= 1
                                            trials_f1_Disturb = [trials_f1_Disturb trl];
                                        end
                                    end
                                end
    
                            elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 0 && data_taskA.trial(trl).repo_blue(sample+1) == 1) %p2b - cond2
                                p2b=p2b+1;
                                p2b_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                p2b_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                p2b_all(end+1) = p2b_timing_cum;
    
                                if ~isempty(p2b_all) && ~isempty(r2p_all)
                                    if (isempty(b2p_all) && (p2b_all(end)> r2p_all(end))) || ((p2b_all(end)> r2p_all(end)) && (r2p_all(end)>b2p_all(end)))
                                        switch_count = switch_count+1;
                                        rb=rb+1;
                                        switch_timing_ins = p2b_timing;
                                        switch_timing_rel = r2p_trial(end); %the last release from the red to piecewise-perception, before the switch to the blue perception.
                                        which_switch_rel = [which_switch_rel switch_count];
                                        if switch_timing_ins <= 5
                                            binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                            bb=bb+1;
                                            %%% eye tracking -- Red
                                            int_indices = find(t_int<r2p_all(end)+2 & t_int>r2p_all(end)-2);
                                            x_eye_present = X_int(int_indices);
                                            y_eye_present = Y_int(int_indices);
                                            x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                            y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                            red_distB(bb,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
    
                                            %%% eye tracking -- Blue
                                            x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                            y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                            blue_distB(bb,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                            distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
    
    
                                            if switch_timing_ins <= 1
                                                binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                            end
                                        end
                                        if switch_timing_rel <=5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                            if switch_timing_rel <= 1
                                                trials_f1_Switch = [trials_f1_Switch trl];
                                            end
    
                                            if switch_timing_rel <=1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                            end

                                            if switch_count==1
                                                binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                            end
                                        end
                                    else
                                        disturb = disturb+1;
                                        disturb_timing_ins = [disturb_timing_ins p2b_timing];
                                        disturb_timing_rel = [disturb_timing_rel b2p_trial(end)];
                                        if b2p_trial(end) <= 1
                                            trials_f1_Disturb = [trials_f1_Disturb trl];
                                        end
                                    end
                                end
    
                            elseif (data_taskA.trial(trl).repo_red(sample) == 0 && data_taskA.trial(trl).repo_blue(sample) == 0) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %p2r - cond1
                                p2r=p2r+1;
                                p2r_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                p2r_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                p2r_all(end+1) = p2r_timing_cum;
    
                                if ~isempty(p2b_all) && ~isempty(b2p_all)
                                    if (isempty(r2p_all) && (p2r_all(end)> b2p_all(end))) || ((p2r_all(end)> b2p_all(end)) && (b2p_all(end)> r2p_all(end)))
                                        switch_count = switch_count+1;
                                        br=br+1;
                                        switch_timing_ins = p2r_timing;
                                        switch_timing_rel = b2p_trial(end);
                                        which_switch_rel = [which_switch_rel switch_count];
                                        if switch_timing_ins <= 5
                                            binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                            rr=rr+1;
                                            %%% eye tracking -- Red
                                            int_indices = find(t_int<b2p_all(end)+2 & t_int>b2p_all(end)-2);
                                            x_eye_present = X_int(int_indices);
                                            y_eye_present = Y_int(int_indices);
                                            x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                            y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                            red_distR(rr,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
    
                                            %%% eye tracking -- Blue
                                            x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                            y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                            blue_distR(rr,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                            distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
    
    
                                            if switch_timing_ins <= 1
                                                binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                            end
                                        end
                                        if switch_timing_rel <=5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];

                                            if switch_timing_rel <= 1
                                                trials_f1_Switch = [trials_f1_Switch trl];
                                            end

                                            if switch_timing_rel <=1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                            end

                                            if switch_count==1
                                                binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                            end
                                        end
                                    else
                                        disturb = disturb+1;
                                        disturb_timing_ins = [disturb_timing_ins p2r_timing];
                                        disturb_timing_rel = [disturb_timing_rel r2p_trial(end)];
                                        if r2p_trial(end) <= 1
                                            trials_f1_Disturb = [trials_f1_Disturb trl];
                                        end
                                    end
                                end
    
                            elseif (data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_blue(sample) == 1) && (data_taskA.trial(trl).repo_red(sample+1) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0) %p2r - cond2
                                p2r=p2r+1;
                                p2r_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                p2r_timing_cum = data_taskA.trial(trl).tSample_from_time_start(sample);
                                p2r_all(end+1) = p2r_timing_cum;
    
                                if ~isempty(p2b_all) && ~isempty(b2p_all)
                                    if (isempty(r2p_all) && (p2r_all(end)> b2p_all(end))) || ((p2r_all(end)> b2p_all(end)) && (b2p_all(end)> r2p_all(end)))
                                        switch_count = switch_count+1;
                                        br=br+1;
                                        switch_timing_ins = p2r_timing;
                                        switch_timing_rel = b2p_trial(end);
                                        which_switch_rel = [which_switch_rel switch_count];
                                        
                                        if switch_timing_ins <= 5
                                            binoriv_timing_taskA_ins = [binoriv_timing_taskA_ins switch_timing_ins];

                                            rr=rr+1;
                                            %%% eye tracking -- Red
                                            int_indices = find(t_int<b2p_all(end)+2 & t_int>b2p_all(end)-2);
                                            x_eye_present = X_int(int_indices);
                                            y_eye_present = Y_int(int_indices);
                                            x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                            y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                            red_distR(rr,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
    
                                            %%% eye tracking -- Blue
                                            x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                            y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                            blue_distR(rr,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);
                                                    
                                            distCenter(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2); %look at the distance between gaze location and the center of the screen.
    
                                            if switch_timing_ins <= 1
                                                binoriv_timing_taskA_ins_f1 = [binoriv_timing_taskA_ins_f1 switch_timing_ins];
                                            end
                                        end
                                        if switch_timing_rel <=5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing_rel];
    
                                            if switch_timing_rel <= 1
                                                trials_f1_Switch = [trials_f1_Switch trl];
                                            end
                                            
                                            if switch_timing_rel <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing_rel];
                                            end

                                            if switch_count==1
                                                binoriv_first_switchTimings = [binoriv_first_switchTimings switch_timing_rel];
                                            end
                                        end
                                    else
                                        disturb = disturb+1;
                                        disturb_timing_ins = [disturb_timing_ins p2r_timing];
                                        disturb_timing_rel = [disturb_timing_rel r2p_trial(end)];
                                        if r2p_trial(end) <= 1
                                            trials_f1_Disturb = [trials_f1_Disturb trl];
                                        end
                                    end
                                end
    
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
                                if (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %b2p - cond1
                                    b2pPhys=b2pPhys+1;
                                    b2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    b2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    b2p_trialPhys(end+1) = b2p_timingPhys;
                                    b2p_allPhys(end+1) = b2p_timing_cumPhys;
                                    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %b2p - cond2
                                    b2pPhys=b2pPhys+1;
                                    b2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    b2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    b2p_trialPhys(end+1) = b2p_timingPhys;
                                    b2p_allPhys(end+1) = b2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %r2p - cond1
                                    r2pPhys=r2pPhys+1;
                                    r2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    r2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    r2p_trialPhys(end+1) = r2p_timingPhys;
                                    r2p_allPhys(end+1) = r2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %r2p - cond2
                                    r2pPhys=r2pPhys+1;
                                    r2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    r2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    r2p_trialPhys(end+1) = r2p_timingPhys;
                                    r2p_allPhys(end+1) = r2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %p2b - cond1
                                    p2bPhys=p2bPhys+1;
                                    p2b_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2b_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2b_allPhys(end+1) = p2b_timing_cumPhys;
                                    
                                    if ~isempty(p2b_allPhys) && ~isempty(r2p_allPhys)
                                        if (isempty(b2p_allPhys) && (p2b_allPhys(end)> r2p_allPhys(end))) || ((p2b_allPhys(end)> r2p_allPhys(end)) && (r2p_allPhys(end)>b2p_allPhys(end)))
                                            switch_timing_insPhys = p2b_timingPhys;
                                            switch_timing_relPhys = r2p_trialPhys(end);
                                            percept_change=true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                bb_phys=bb_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<r2p_allPhys(end)+2 & t_int>r2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
    
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2b_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys b2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %p2b - cond2
                                    p2bPhys=p2bPhys+1;
                                    p2b_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2b_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2b_allPhys(end+1) = p2b_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(r2p_allPhys)
                                        if (isempty(b2p_allPhys) && (p2b_allPhys(end)> r2p_allPhys(end))) || ((p2b_allPhys(end)> r2p_allPhys(end)) && (r2p_allPhys(end)>b2p_allPhys(end)))
                                            switch_timing_insPhys = p2b_timingPhys;
                                            switch_timing_relPhys = r2p_trialPhys(end); %the last release from the red to piecewise-perception, before the switch to the blue perception.
                                            percept_change=true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                bb_phys=bb_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<r2p_allPhys(end)+2 & t_int>r2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end

                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2b_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys b2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %p2r - cond1
                                    p2rPhys=p2rPhys+1;
                                    p2r_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2r_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2r_allPhys(end+1) = p2r_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(b2p_allPhys)
                                        if (isempty(r2p_allPhys) && (p2r_allPhys(end)> b2p_allPhys(end))) || ((p2r_allPhys(end)> b2p_allPhys(end)) && (b2p_allPhys(end)> r2p_allPhys(end)))
                                            switch_timing_insPhys = p2r_timingPhys;
                                            switch_timing_relPhys = b2p_trialPhys(end);
                                            percept_change=true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                rr_phys=rr_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<b2p_allPhys(end)+2 & t_int>b2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
    
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2r_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys r2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %p2r - cond2
                                    p2rPhys=p2rPhys+1;
                                    p2r_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2r_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2r_allPhys(end+1) = p2r_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(b2p_allPhys)
                                        if (isempty(r2p_allPhys) && (p2r_allPhys(end)> b2p_allPhys(end))) || ((p2r_allPhys(end)> b2p_allPhys(end)) && (b2p_allPhys(end)> r2p_allPhys(end)))
                                            switch_timing_insPhys = p2r_timingPhys;
                                            switch_timing_relPhys = b2p_trialPhys(end);
                                            percept_change=true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                rr_phys=rr_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<b2p_allPhys(end)+2 & t_int>b2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end

                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2r_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys r2p_trialPhys(end)];
                                        end
                                    end
                                    
                                end
                            end
                            if percept_change
                                break
                            end
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
                                if (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %b2p - cond1
                                    b2pPhys=b2pPhys+1;
                                    b2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    b2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    b2p_trialPhys(end+1) = b2p_timingPhys;
                                    b2p_allPhys(end+1) = b2p_timing_cumPhys;
                                    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %b2p - cond2
                                    b2pPhys=b2pPhys+1;
                                    b2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    b2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    b2p_trialPhys(end+1) = b2p_timingPhys;
                                    b2p_allPhys(end+1) = b2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %r2p - cond1
                                    r2pPhys=r2pPhys+1;
                                    r2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    r2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    r2p_trialPhys(end+1) = r2p_timingPhys;
                                    r2p_allPhys(end+1) = r2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %r2p - cond2
                                    r2pPhys=r2pPhys+1;
                                    r2p_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    r2p_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    r2p_trialPhys(end+1) = r2p_timingPhys;
                                    r2p_allPhys(end+1) = r2p_timing_cumPhys;
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %p2b - cond1
                                    p2bPhys=p2bPhys+1;
                                    p2b_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2b_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2b_allPhys(end+1) = p2b_timing_cumPhys;
                                    
                                    if ~isempty(p2b_allPhys) && ~isempty(r2p_allPhys)
                                        if (isempty(b2p_allPhys) && (p2b_allPhys(end)> r2p_allPhys(end))) || ((p2b_allPhys(end)> r2p_allPhys(end)) && (r2p_allPhys(end)>b2p_allPhys(end)))
 
                                            switch_timing_insPhys = p2b_timingPhys;
                                            switch_timing_relPhys = r2p_trialPhys(end);
                                            percept_change=true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                bb_phys=bb_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<r2p_allPhys(end)+2 & t_int>r2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
    
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2b_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys b2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 0 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 1) %p2b - cond2
                                    p2bPhys=p2bPhys+1;
                                    p2b_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2b_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2b_allPhys(end+1) = p2b_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(r2p_allPhys)
                                        if (isempty(b2p_allPhys) && (p2b_allPhys(end)> r2p_allPhys(end))) || ((p2b_allPhys(end)> r2p_allPhys(end)) && (r2p_allPhys(end)>b2p_allPhys(end)))                                           
                                            switch_timing_insPhys = p2b_timingPhys;
                                            switch_timing_relPhys = r2p_trialPhys(end); %the last release from the red to piecewise-perception, before the switch to the blue perception.
                                            percept_change=true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                bb_phys=bb_phys+1;

                                                int_indices = find(t_int<r2p_allPhys(end)+2 & t_int>r2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distB_phys(bb_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
 
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2b_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys b2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 0 && data_taskA.trial(cont_trl).repo_blue(sample) == 0) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %p2r - cond1
                                    p2rPhys=p2rPhys+1;
                                    p2r_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2r_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2r_allPhys(end+1) = p2r_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(b2p_allPhys)
                                        if (isempty(r2p_allPhys) && (p2r_allPhys(end)> b2p_allPhys(end))) || ((p2r_allPhys(end)> b2p_allPhys(end)) && (b2p_allPhys(end)> r2p_allPhys(end)))
                                            switch_timing_insPhys = p2r_timingPhys;
                                            switch_timing_relPhys = b2p_trialPhys(end);
                                            percept_change=true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                rr_phys=rr_phys+1;
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<b2p_allPhys(end)+2 & t_int>b2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end
    
                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2r_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys r2p_trialPhys(end)];
                                        end
                                    end
    
                                elseif (data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample) == 1) && (data_taskA.trial(cont_trl).repo_red(sample+1) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0) %p2r - cond2
                                    p2rPhys=p2rPhys+1;
                                    p2r_timingPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    p2r_timing_cumPhys = data_taskA.trial(cont_trl).tSample_from_time_start(sample);
                                    p2r_allPhys(end+1) = p2r_timing_cumPhys;
    
                                    if ~isempty(p2b_allPhys) && ~isempty(b2p_allPhys)
                                        if (isempty(r2p_allPhys) && (p2r_allPhys(end)> b2p_allPhys(end))) || ((p2r_allPhys(end)> b2p_allPhys(end)) && (b2p_allPhys(end)> r2p_allPhys(end)))
    %                                             switch_count = switch_count+1;
    %                                             br=br+1;
                                            switch_timing_insPhys = p2r_timingPhys;
                                            switch_timing_relPhys = b2p_trialPhys(end);
                                            percept_change=true;
                                            if switch_timing_insPhys <= 5
                                                phys_timing_taskA_ins = [phys_timing_taskA_ins switch_timing_insPhys];

                                                rr_phys=rr_phys+1;
                %                                 time_mm=floor(binoriv_timing_taskA_ins(end)*1000);
                                                %%% eye tracking -- Red
                                                int_indices = find(t_int<b2p_allPhys(end)+2 & t_int>b2p_allPhys(end)-2);
                                                x_eye_present = X_int(int_indices);
                                                y_eye_present = Y_int(int_indices);
                                                x_fp_red = data_taskA.trial(trl).eye.fix.x.red;
                                                y_fp_red = data_taskA.trial(trl).eye.fix.y.red;
                                                red_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_red).^2 + (y_eye_present-y_fp_red).^2);
                                                %%% eye tracking -- Blue
                                                x_fp_blue = data_taskA.trial(trl).eye.fix.x.blue;
                                                y_fp_blue = data_taskA.trial(trl).eye.fix.y.blue;
                                                blue_distR_phys(rr_phys,:) = sqrt((x_eye_present-x_fp_blue).^2 + (y_eye_present-y_fp_blue).^2);

                                                distCenterPhys(end+1,:) = sqrt((x_eye_present).^2 + (y_eye_present).^2);

                                                if switch_timing_insPhys <= 1
                                                    phys_timing_taskA_ins_f1 = [phys_timing_taskA_ins_f1 switch_timing_insPhys];
                                                end
    
                                            end
                                            if switch_timing_relPhys <=5
                                                phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing_relPhys];

                                                if switch_timing_relPhys <= 1
                                                    phys_timing_taskA_rel_f1 = [phys_timing_taskA_rel_f1 switch_timing_relPhys];
                                                end

                                            end
                                        else
                                            disturbPhys = disturbPhys+1;
                                            disturb_timing_insPhys = [disturb_timing_insPhys p2r_timingPhys];
                                            disturb_timing_relPhys = [disturb_timing_relPhys r2p_trialPhys(end)];
                                        end
                                    end
                                    
                                end
                            end
                            if percept_change
                                break
                            end
                        end
                        
                    end  
                end
                
            end

        end

        binoriv_first_switchTimingsAll = [binoriv_first_switchTimingsAll binoriv_first_switchTimings];
        % Define the bin edges
        binEdges = 0:0.25:5;

        % Percept switch prob. in BinoRiv cond. release
        figure('Position', [100 100 800 600]);
        histogram(binoriv_timing_taskA_rel,'norm','probability','BinEdges',binEdges, 'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
        xline(mean(binoriv_timing_taskA_rel),'-',{'Mean'})
        xline(median(binoriv_timing_taskA_rel),'--',{'Median'})
        xlim([-0.5 5.5])
        xlabel('Time from trial onset [s]')
        ylabel('Counts');
        title(['Probability Distribution of task ' num2str(taskA_number)...
            ', Binoriv release'...
            ', Num of data: ' num2str(numel(binoriv_timing_taskA_rel))]);
        filename = [subj_fig_dir '/Switch_prob_bino_rel_trueSwitch' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename)
        filename = [subj_fig_dir '/Switch_prob_bino_rel_trueSwitch' num2str(taskA_number) '.fig'];
        saveas(gcf,filename)
        close;
        binoriv_timing_taskA_rel_allSubj = [binoriv_timing_taskA_rel_allSubj binoriv_timing_taskA_rel];
        binoriv_timings_bySubj{subj,1} = binoriv_timing_taskA_rel;
        binoriv_timing_taskA_rel_allSubjF1 = [binoriv_timing_taskA_rel_allSubjF1 binoriv_timing_taskA_rel_f1];
    
        if taskA_number==1
            which_switch_rel_allSubj = [which_switch_rel_allSubj which_switch_rel];
        end
        secondary_switches_rel = find(which_switch_rel>1);
        percent_secondaries_rel(subj) = length(secondary_switches_rel)/length(which_switch_rel);
        secondary_switchCount(subj) = length(secondary_switches_rel);
        
        
        % Percept switch prob. in Phys cond. release
        figure('Position', [100 100 800 600]);
        histogram(phys_timing_taskA_rel,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
        xline(mean(phys_timing_taskA_rel),'-',{'Mean'})
        xline(median(phys_timing_taskA_rel),'--',{'Median'})
        xlim([-0.5 5.5])
        xlabel('Time from trial onset [s]')
        ylabel('Counts');
        title({['Probability Distribution of task ' num2str(taskA_number)...
            ', Phys release'...
            ', Num of data: ' num2str(numel(phys_timing_taskA_rel))]},...
            {['Num of red presented: ' num2str(num_red_presented)...
            ', Num of blue presented: ' num2str(num_blue_presented),...
            ', Num of red correct: ' num2str(num_red_cong)...
            ', Num of blue correct: ' num2str(num_blue_cong),...
            ', Success rate: ' num2str(100*(num_red_cong+num_blue_cong)/(num_red_presented+num_blue_presented)) '%']})
        filename = [subj_fig_dir '/Switch_prob_phys_rel_trueSwitch' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename)
        filename = [subj_fig_dir '/Switch_prob_phys_rel_trueSwitch' num2str(taskA_number) '.fig'];
        saveas(gcf,filename)
        close;
        phys_timing_taskA_rel_allSubj = [phys_timing_taskA_rel_allSubj phys_timing_taskA_rel];
        phys_timings_bySubj{subj,1} = phys_timing_taskA_rel;
    
    
        %% plot histogram for the timings of disturbances in perception, with respect to Fixation Point Jumps

        disturb_timing_rel = disturb_timing_rel(disturb_timing_rel < 5); % we do not take timings bigger than 5 into the analyses.
        figure;
        histogram(disturb_timing_rel,'Normalization', 'probability', 'FaceAlpha', 0.5, 'NumBins', 20);
        xline(mean(disturb_timing_rel),'-',{'Binoriv mean'})
        xline(median(disturb_timing_rel),'--',{'Binoriv median'})
        xlabel('Time from trial onset [s]');
        ylabel('Probability');
        title(['Timings of disturbed perception - Button Release ' num2str(taskA_number)]);
        filename = [subj_fig_dir '/disturbedPerception_release' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename)
        filename = [subj_fig_dir '/disturbedPerception_release' num2str(taskA_number) '.fig'];
        saveas(gcf,filename)
        close;
    
        disturb_timing_ins_allSubj = [disturb_timing_ins_allSubj disturb_timing_ins];
        disturb_timing_rel_allSubj = [disturb_timing_rel_allSubj disturb_timing_rel];
    
        %% EK: 28.03.24 -- Create a table and save the mean/median for the switch timings in this current task
        
        %%% Binoriv condition       
        taskA_binoriv_rel_means(subj,1) = mean(binoriv_timing_taskA_rel);
        taskA_binoriv_rel_medians(subj,1) = median(binoriv_timing_taskA_rel);
        taskA_binoriv_rel_std(subj,1) = std(binoriv_timing_taskA_rel);
        taskA_binoriv_rel_iqr(subj,1) = iqr(binoriv_timing_taskA_rel);
    
        %%% Phys condition
    
        taskA_phys_rel_means(subj,1) = mean(phys_timing_taskA_rel);
        taskA_phys_rel_medians(subj,1) = median(phys_timing_taskA_rel);
        taskA_phys_rel_std(subj,1) = std(phys_timing_taskA_rel);
        taskA_phys_rel_iqr(subj,1) = iqr(phys_timing_taskA_rel);

        %%% Perceptual disturbances
        taskA_disturb_means(subj,1) = mean(disturb_timing_rel);
        taskA_disturb_medians(subj,1) = median(disturb_timing_rel);
        taskA_disturb_std(subj,1) = std(disturb_timing_rel);
        taskA_disturb_iqr(subj,1) = iqr(disturb_timing_rel);

        trials_f1_Switch = unique(trials_f1_Switch);
        trials_f1_Disturb = unique(trials_f1_Disturb);
        taskA_percentTrial_f1Switch = 100*(numel(trials_f1_Switch)/num_bino_presented);
        taskA_percentTrial_f1Disturb = 100*(numel(trials_f1_Disturb)/num_bino_presented);
        
        trials_f1_Change = [trials_f1_Disturb trials_f1_Switch];
        trials_f1_Change = unique(trials_f1_Change);
        
        taskA_percentTrial_f1Change = 100*(numel(trials_f1_Change)/num_bino_presented); %in what percentage of trials was a perceptual change induced within the first second?

        %%% General info
        general_info.num_red_presented(subj,1) = num_red_presented;
        general_info.num_blue_presented(subj,1) = num_blue_presented; %physical trial count
        general_info.success_rate(subj,1) = 100*(num_red_cong+num_blue_cong)/(num_red_presented+num_blue_presented);
        general_info.num_bino_presented(subj,1) = num_bino_presented;
        general_info.disturbedSwitches(subj,1) = disturb;
        general_info.completedSwitches(subj,1) = numel(binoriv_timing_taskA_rel);
        general_info.rate_switches_inF1(subj,1) =  100*(numel(binoriv_timing_taskA_rel_f1(binoriv_timing_taskA_rel_f1<1))/numel(binoriv_timing_taskA_rel));
        general_info.rate_PhysSwitches_inF1(subj,1) = 100*(numel(phys_timing_taskA_rel_f1)/numel(phys_timing_taskA_rel));
        general_info.rate_disturb_inF1(subj,1) = 100*(numel(disturb_timing_rel(disturb_timing_rel<1))/numel(disturb_timing_rel));
        general_info.ratio_trials_w_f1Change(subj,1) = taskA_percentTrial_f1Change;
        general_info.ratio_trials_w_f1TrueSwitch(subj,1) = taskA_percentTrial_f1Switch;

        %% plot the distances to each fixation point : All eye-tracking plots should also be based on button insertion!
        %%% Around the time of switch from red to blue
        time_range = linspace(-2,2,400);
        figure;
        pr = plot(time_range,median(red_distB,1),'r','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(red_distB,1) + iqr(red_distB,1)/sqrt(size(red_distB,1))];
        curve2 = [median(red_distB,1) - iqr(red_distB,1)/sqrt(size(red_distB,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'r','FaceAlpha',0.5);
    
        hold on
        pb = plot(time_range,median(blue_distB,1),'b','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(blue_distB,1) + std(blue_distB,1)/sqrt(size(blue_distB,1))];
        curve2 = [median(blue_distB,1) - std(blue_distB,1)/sqrt(size(blue_distB,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'b','FaceAlpha',0.5);    
    
        median_red_distB(subj,:) = median(red_distB,1);
        median_blue_distB(subj,:) = median(blue_distB,1);
    
        legend([pr pb],'Distance to Red FP','Distance to Blue FP');
        xlabel('Time wrt perceptual switch report (Button Press)');
        ylabel('Distance to the fixation spot (°)');
        title(['Subj ' subj_fig_dir(end-1:end) ': Switches from red to blue'])
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
    
        filename=[subj_fig_dir '/GazeDistances_R2B_1707_interpTask' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[subj_fig_dir '/GazeDistances_R2B_1707_interpTask' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;

    % %     %%% Around the time of switch from blue to red
        figure;

        hold on
        pr = plot(time_range,median(red_distR,1),'r','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(red_distR,1) + std(red_distR,1)/sqrt(size(red_distR,1))];
        curve2 = [median(red_distR,1) - std(red_distR,1)/sqrt(size(red_distR,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'r','FaceAlpha',0.5);
    
        hold on
        pb = plot(time_range,median(blue_distR,1),'b','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(blue_distR,1) + std(blue_distR,1)/sqrt(size(blue_distR,1))];
        curve2 = [median(blue_distR,1) - std(blue_distR,1)/sqrt(size(blue_distR,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'b','FaceAlpha',0.5); 
    
        median_red_distR(subj,:) = median(red_distR,1);
        median_blue_distR(subj,:) = median(blue_distR,1);
    
        legend([pr pb],'Distance to Red FP','Distance to Blue FP');
        xlabel('Time wrt perceptual switch report (Button Press)');
        ylabel('Distance to the fixation spot (°)');
        title(['Subj ' subj_fig_dir(end-1:end) ': Switches from blue to red']);
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
        filename=[subj_fig_dir '/GazeDistances_B2R_1707_interpTask' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[subj_fig_dir '/GazeDistances_B2R_1707_interpTask' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;

        %% Now combine the R-to-B and B-to-R switches, and plot the gaze for overall NonTarget to Target switches

        target = [red_distR; blue_distB];
        non_target = [red_distB; blue_distR];

        figure;
        pr = plot(time_range,median(target,1),'color',[0.8500 0.3250 0.0980],'LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(target,1) + std(target,1)/sqrt(size(target,1))];
        curve2 = [median(target,1) - std(target,1)/sqrt(size(target,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, [0.8500 0.3250 0.0980],'FaceAlpha',0.5);
    
        hold on
        pb = plot(time_range,median(non_target,1),'color',[0.5 0.5 0.5],'LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(non_target,1) + std(non_target,1)/sqrt(size(non_target,1))];
        curve2 = [median(non_target,1) - std(non_target,1)/sqrt(size(non_target,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween,[0.5 0.5 0.5],'FaceAlpha',0.5);

        legend([pr pb],'Distance to Target FP','Distance to Previous FP');
        xlabel('Time wrt perceptual switch report (Button Press)');
        ylabel('Distance to the fixation spot (°)');
        title(['Subj ' subj_fig_dir(end-1:end) ': Switches towards target FP'])
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
    
        filename=[subj_fig_dir '/GazeDistances_2target_1707_interpTask' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[subj_fig_dir '/GazeDistances_2target_1707_interpTask' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;
    
        median_target(subj,:) = median(target,1);
        median_non_target(subj,:) = median(non_target,1);
    
        %% LETS ALSO LOOK AT THE DISTANCE OF THE GAZE TO THE CENTER IF TASK NUMBER IS 2 or 3
        time_rangeTrial = 0.21:0.01:4.8;
        median_centerTrl(subj,:) = median(distCenterTrl,1);
        median_centerTrlPhys(subj,:) = median(distCenterTrlPhys,1);

        if taskA_number == 2 || taskA_number == 3
            dc = plot(time_range,median(distCenter,1),'k','LineWidth',4);
            hold on
            x2 = [time_range, fliplr(time_range)];
            curve1 = [median(distCenter,1) + std(distCenter,1)/sqrt(size(distCenter,1))];
            curve2 = [median(distCenter,1) - std(distCenter,1)/sqrt(size(distCenter,1))];
            inBetween = [curve1, fliplr(curve2)];
            fill(x2, inBetween, 'k','FaceAlpha',0.5);
    
            ylim([0 4.5]);
            set(gca,'FontSize',36,'FontWeight','Bold')
            set(gcf, 'Position', get(0, 'Screensize'));
            title(['Subj ' subj_fig_dir(end-1:end) ': Distance to Center']);
            filename=[subj_fig_dir '/GazeDistance2Center_1707' num2str(taskA_number) '.tiff'];
            saveas(gcf,filename);
            filename=[subj_fig_dir '/GazeDistance2Center_1707' num2str(taskA_number) '.fig'];
            saveas(gcf,filename);
            close;
    
            dcP = plot(time_range,median(distCenterPhys,1),'k','LineWidth',4);
            hold on
            x2 = [time_range, fliplr(time_range)];
            curve1 = [median(distCenterPhys,1) + std(distCenterPhys,1)/sqrt(size(distCenterPhys,1))];
            curve2 = [median(distCenterPhys,1) - std(distCenterPhys,1)/sqrt(size(distCenterPhys,1))];
            inBetween = [curve1, fliplr(curve2)];
            fill(x2, inBetween, 'k','FaceAlpha',0.5);
    
            ylim([0 4.5]);
            set(gca,'FontSize',36,'FontWeight','Bold')
            set(gcf, 'Position', get(0, 'Screensize'));
            title(['Subj ' subj_fig_dir(end-1:end) ':Distance to Center - PHYS']);
            filename=[subj_fig_dir '/GazeDistance2Center_1707_phys' num2str(taskA_number) '.tiff'];
            saveas(gcf,filename);
            filename=[subj_fig_dir '/GazeDistance2Center_1707_phys' num2str(taskA_number) '.fig'];
            saveas(gcf,filename);
            close;
    
            median_distCenter(subj,:) = median(distCenter,1);
            median_distCenterPhys(subj,:) = median(distCenterPhys,1);
        end
    
    
    %% Physical condition
        %% Button Insertion
        %%% Around the time of switch from red to blue
        time_range = linspace(-2,2,400);
        figure;
        pr = plot(time_range,median(red_distB_phys,1),'r','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(red_distB_phys,1) + std(red_distB_phys,1)/sqrt(size(red_distB_phys,1))];
        curve2 = [median(red_distB_phys,1) - std(red_distB_phys,1)/sqrt(size(red_distB_phys,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'r','FaceAlpha',0.5);
        hold on
        pb = plot(time_range,median(blue_distB_phys,1),'b','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(blue_distB_phys,1) + std(blue_distB_phys,1)/sqrt(size(blue_distB_phys,1))];
        curve2 = [median(blue_distB_phys,1) - std(blue_distB_phys,1)/sqrt(size(blue_distB_phys,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'b','FaceAlpha',0.5); 
    
        median_red_distB_phys(subj,:) = median(red_distB_phys,1);
        median_blue_distB_phys(subj,:) = median(blue_distB_phys,1);

    
        legend([pr pb],'Distance to Red FP','Distance to Blue FP');
        xlabel('Time wrt perceptual switch report (Button Press)');
        ylabel('Distance to the fixation spot (°)');
        title(['Subj ' subj_fig_dir(end-1:end) ': PHYSICAL Switches from red to blue'])
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
    
        filename=[subj_fig_dir '/GazeDistances_R2B_1707_phys_interpTask' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[subj_fig_dir '/GazeDistances_R2B_1707_phys_interpTask' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;
    % 
    %     %%% Around the time of switch from blue to red
        figure;
        pr = plot(time_range,median(red_distR_phys,1),'r','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(red_distR_phys,1) + std(red_distR_phys,1)/sqrt(size(red_distR_phys,1))];
        curve2 = [median(red_distR_phys,1) - std(red_distR_phys,1)/sqrt(size(red_distR_phys,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'r','FaceAlpha',0.5);
        hold on
        pb = plot(time_range,median(blue_distR_phys,1),'b','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(blue_distR_phys,1) + std(blue_distR_phys,1)/sqrt(size(blue_distR_phys,1))];
        curve2 = [median(blue_distR_phys,1) - std(blue_distR_phys,1)/sqrt(size(blue_distR_phys,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'b','FaceAlpha',0.5);
    
        median_red_distR_phys(subj,:) = median(red_distR_phys,1);
        median_blue_distR_phys(subj,:) = median(blue_distR_phys,1);
    
        legend([pr pb],'Distance to Red FP','Distance to Blue FP');
        xlabel('Time wrt perceptual switch report (Button Press)');
        ylabel('Distance to the fixation spot (°)');
        title(['Subj ' subj_fig_dir(end-1:end) ': PHYSICAL Switches from blue to red'])
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
    
        filename=[subj_fig_dir '/GazeDistances_B2R_1707_phys_interpTask' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[subj_fig_dir '/GazeDistances_B2R_1707_phys_interpTask' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;

        %%% Combined switch to target
        targetPhys = [red_distR_phys; blue_distB_phys];
        non_targetPhys = [red_distB_phys; blue_distR_phys];

        figure;
        pr = plot(time_range,median(targetPhys,1),'color',[0.8500 0.3250 0.0980],'LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(targetPhys,1) + std(targetPhys,1)/sqrt(size(targetPhys,1))];
        curve2 = [median(targetPhys,1) - std(targetPhys,1)/sqrt(size(targetPhys,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, [0.8500 0.3250 0.0980],'FaceAlpha',0.5);
    
        hold on
        pb = plot(time_range,median(non_targetPhys,1),'color',[0.5 0.5 0.5],'LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(non_targetPhys,1) + std(non_targetPhys,1)/sqrt(size(non_targetPhys,1))];
        curve2 = [median(non_targetPhys,1) - std(non_targetPhys,1)/sqrt(size(non_targetPhys,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween,[0.5 0.5 0.5],'FaceAlpha',0.5);

        legend([pr pb],'Distance to Target FP','Distance to Previous FP');
        xlabel('Time wrt perceptual switch report (Button Press)');
        ylabel('Distance to the fixation spot (°)');
        title(['Subj ' subj_fig_dir(end-1:end) ': PHYSICAL Switches towards target FP'])
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
    
        filename=[subj_fig_dir '/GazeDistances_2target_1707_phys_interpTask' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[subj_fig_dir '/GazeDistances_2target_1707_phys_interpTask' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;
    
        median_targetPhys(subj,:) = median(targetPhys,1);
        median_non_targetPhys(subj,:) = median(non_targetPhys,1);
    
        trueAfterCombinedAll = [trueAfterCombinedAll trueAfterCombined];
    end
    
    
    
    %% Group-Level Average Gaze Plot (Distance to each fixation point) -- Button Insertion
    %%% Around the time of switch from red to blue
    median_red_distB(9,:) = []; %subject 11 (order of the subject is 9) is excluded from visualizations because the data is much worse compared to other subjects.
    median_blue_distB(9,:) = [];

    figure;
    pr = plot(time_range,median(median_red_distB,1),'r','LineWidth',4);
    hold on
    pb = plot(time_range,median(median_blue_distB,1),'b','LineWidth',4);
    hold on
    for i=1:subj-1
        plot(time_range,median_red_distB(i,:),'r');
        hold on
        plot(time_range,median_blue_distB(i,:),'b');
        hold on
    end
    
    legend([pr pb],'Distance to Red FP','Distance to Blue FP');
    xlabel('Time wrt perceptual switch report (Button Press)');
    ylabel('Distance to the fixation spot (°)');
    title(['Group Level: Switches from red to blue'])
    ylim([0 4.5]);
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    
    filename=[fig_dir '/GazeDistances_R2B_1707_groupLevel' num2str(taskA_number) '.tiff'];
    saveas(gcf,filename);
    filename=[fig_dir '/GazeDistances_R2B_1707_groupLevel' num2str(taskA_number) '.fig'];
    saveas(gcf,filename);
    close;
    
    %%% Around the time of switch from blue to red
    median_red_distR(9,:) = []; %subject 11 is (order of the subject is 9) excluded from visualizations because the data is much worse compared to other subjects.
    median_blue_distR(9,:) = [];
    figure;
    pr = plot(time_range,median(median_red_distR,1),'r','LineWidth',4);
    hold on
    pb = plot(time_range,median(median_blue_distR,1),'b','LineWidth',4);
    hold on
    for i=1:subj-1
        plot(time_range,median_red_distR(i,:),'r');
        hold on
        plot(time_range,median_blue_distR(i,:),'b');
        hold on
    end
    
    legend([pr pb],'Distance to Red FP','Distance to Blue FP');
    xlabel('Time wrt perceptual switch report (Button Press)');
    ylabel('Distance to the fixation spot (°)');
    title(['Group Level: Switches from blue to red'])
    ylim([0 4.5]);
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    
    filename=[fig_dir '/GazeDistances_B2R_1707_groupLevel' num2str(taskA_number) '.tiff'];
    saveas(gcf,filename);
    filename=[fig_dir '/GazeDistances_B2R_1707_groupLevel' num2str(taskA_number) '.fig'];
    saveas(gcf,filename);
    close;
    

    %%% Combined Switch to Target
    median_target(9,:) = []; %subject 11 (order of the subject is 9) is excluded from visualizations because the data is much worse compared to other subjects.
    median_non_target(9,:) = [];
    figure;
    pr = plot(time_range,median(median_target,1),'color',[0.8500 0.3250 0.0980],'LineWidth',4);
    hold on    
    x2 = [time_range, fliplr(time_range)];
    curve1 = [median(median_target,1) + std(median_target,1)/sqrt(size(median_target,1))];
    curve2 = [median(median_target,1) - std(median_target,1)/sqrt(size(median_target,1))];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween,[0.8500 0.3250 0.0980],'FaceAlpha',0.3);
    hold on
    pb = plot(time_range,median(median_non_target,1),'color',[0.5 0.5 0.5],'LineWidth',4);
    hold on
    x2 = [time_range, fliplr(time_range)];
    curve1 = [median(median_non_target,1) + std(median_non_target,1)/sqrt(size(median_non_target,1))];
    curve2 = [median(median_non_target,1) - std(median_non_target,1)/sqrt(size(median_non_target,1))];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween, [0.5 0.5 0.5],'FaceAlpha',0.3);
    hold on
    for i=1:subj-1
        plot(time_range,median_target(i,:),'color',[0.8500 0.3250 0.0980]);
        hold on
        plot(time_range,median_non_target(i,:),'color',[0.5 0.5 0.5]);
        hold on
    end

    legend([pr pb],'Distance to Target FP','Distance to Previous FP');
    xlabel('Time wrt perceptual switch report (Button Press)');
    ylabel('Distance to the fixation spot (°)');
    title(['Group Level: Switches to Target'])
    ylim([0 4.5]);
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    
    filename=[fig_dir '/GazeDistances_2target_1707_groupLevel' num2str(taskA_number) '.tiff'];
    saveas(gcf,filename);
    filename=[fig_dir '/GazeDistances_2target_1707_groupLevel' num2str(taskA_number) '.fig'];
    saveas(gcf,filename);
    close;
    
    
    %% Group-Level Average Gaze Plot (Distance to each fixation point) -- Button Insertion - Physical Condition
    
    %%% Around the time of switch from red to blue
    median_red_distB_phys(9,:) = []; %subject 11 (order of the subject is 9) is excluded from visualizations because the data is much worse compared to other subjects.
    median_blue_distB_phys(9,:) = [];
    figure;
    pr = plot(time_range,median(median_red_distB_phys,1),'r','LineWidth',4);
    hold on
    pb = plot(time_range,median(median_blue_distB_phys,1),'b','LineWidth',4);
    hold on
    for i=1:subj-1
        plot(time_range,median_red_distB_phys(i,:),'r');
        hold on
        plot(time_range,median_blue_distB_phys(i,:),'b');
        hold on
    end
    
    legend([pr pb],'Distance to Red FP','Distance to Blue FP');
    xlabel('Time wrt perceptual switch report (Button Press)');
    ylabel('Distance to the fixation spot (°)');
    title(['Group Level: Switches from red to blue'])
    ylim([0 4.5]);
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    
    filename=[fig_dir '/GazeDistances_R2B_phys_1707_groupLevel' num2str(taskA_number) '.tiff'];
    saveas(gcf,filename);
    filename=[fig_dir '/GazeDistances_R2B_phys_1707_groupLevel' num2str(taskA_number) '.fig'];
    saveas(gcf,filename);
    close;
    
    %%% Around the time of switch from blue to red
    median_red_distR_phys(9,:) = []; %subject 11 (order of the subject is 9) is excluded from visualizations because the data is much worse compared to other subjects.
    median_blue_distR_phys(9,:) = [];
    figure;
    pr = plot(time_range,median(median_red_distR_phys,1),'r','LineWidth',4);
    hold on
    pb = plot(time_range,median(median_blue_distR_phys,1),'b','LineWidth',4);
    hold on
    for i=1:subj-1
        plot(time_range,median_red_distR_phys(i,:),'r');
        hold on
        plot(time_range,median_blue_distR_phys(i,:),'b');
        hold on
    end
    
    legend([pr pb],'Distance to Red FP','Distance to Blue FP');
    xlabel('Time wrt perceptual switch report (Button Press)');
    ylabel('Distance to the fixation spot (°)');
    title(['Group Level: Switches from blue to red'])
    ylim([0 4.5]);
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    
    filename=[fig_dir '/GazeDistances_B2R_phys_1707_groupLevel' num2str(taskA_number) '.tiff'];
    saveas(gcf,filename);
    filename=[fig_dir '/GazeDistances_B2R_phys_1707_groupLevel' num2str(taskA_number) '.fig'];
    saveas(gcf,filename);
    close;


    %%% Combined Switch to Target
    median_targetPhys(9,:) = []; %subject 11 (order of the subject is 9) is excluded from visualizations because the data is much worse compared to other subjects.
    median_non_targetPhys(9,:) = [];
    figure;
    pr = plot(time_range,median(median_targetPhys,1),'color',[0.8500 0.3250 0.0980],'LineWidth',4);
    hold on
    x2 = [time_range, fliplr(time_range)];
    curve1 = [median(median_targetPhys,1) + std(median_targetPhys,1)/sqrt(size(median_targetPhys,1))];
    curve2 = [median(median_targetPhys,1) - std(median_targetPhys,1)/sqrt(size(median_targetPhys,1))];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween, [0.8500 0.3250 0.0980],'FaceAlpha',0.3);
    hold on
    pb = plot(time_range,median(median_non_targetPhys,1),'color',[0.5 0.5 0.5],'LineWidth',4);
    hold on
    x2 = [time_range, fliplr(time_range)];
    curve1 = [median(median_non_targetPhys,1) + std(median_non_targetPhys,1)/sqrt(size(median_non_targetPhys,1))];
    curve2 = [median(median_non_targetPhys,1) - std(median_non_targetPhys,1)/sqrt(size(median_non_targetPhys,1))];
    inBetween = [curve1, fliplr(curve2)];
    fill(x2, inBetween,[0.5 0.5 0.5],'FaceAlpha',0.3);
    hold on
    for i=1:subj-1
        plot(time_range,median_targetPhys(i,:),'color',[0.8500 0.3250 0.0980]);
        hold on
        plot(time_range,median_non_targetPhys(i,:),'color',[0.5 0.5 0.5]);
        hold on
    end

    legend([pr pb],'Distance to Target FP','Distance to Previous FP');
    xlabel('Time wrt perceptual switch report (Button Press)');
    ylabel('Distance to the fixation spot (°)');
    title(['Group Level: PHYSICAL Switches to Target'])
    ylim([0 4.5]);
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    
    filename=[fig_dir '/GazeDistances_2target_1707_phys_groupLevel' num2str(taskA_number) '.tiff'];
    saveas(gcf,filename);
    filename=[fig_dir '/GazeDistances_2target_1707_phys_groupLevel' num2str(taskA_number) '.fig'];
    saveas(gcf,filename);
    close;
    
    
    %% Group-Level Average Gaze Plot -- Distance to the Center Location (if task number is 2 or 3)

    if taskA_number == 2 || taskA_number == 3
        median_distCenter(9,:) = []; %subject 11 (order of the subject is 9) is excluded from visualizations because the data is much worse compared to other subjects.
        median_distCenterPhys(9,:) = [];
        median_centerTrl(9,:) = [];
        median_centerTrlPhys(9,:) = [];

        figure;        
        dc = plot(time_range,median(median_distCenter,1),'k','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(median_distCenter,1) + std(median_distCenter,1)/sqrt(size(median_distCenter,1))];
        curve2 = [median(median_distCenter,1) - std(median_distCenter,1)/sqrt(size(median_distCenter,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'k','FaceAlpha',0.3);
        hold on
        for i=1:subj-1
            plot(time_range,median_distCenter(i,:),'k');
            hold on
        end
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
        title(['Distance to Center - Group Level']);
        filename=[fig_dir '/GazeDistance2Center_GroupLevel' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[fig_dir '/GazeDistance2Center_GroupLevel' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;
    
        figure;
        dcP = plot(time_range,median(median_distCenterPhys,1),'k','LineWidth',4);
        hold on
        x2 = [time_range, fliplr(time_range)];
        curve1 = [median(median_distCenterPhys,1) + std(median_distCenterPhys,1)/sqrt(size(median_distCenterPhys,1))];
        curve2 = [median(median_distCenterPhys,1) - std(median_distCenterPhys,1)/sqrt(size(median_distCenterPhys,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'k','FaceAlpha',0.3);
        hold on
        for i=1:subj-1
            plot(time_range,median_distCenterPhys(i,:),'k');
            hold on
        end
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
        xlabel('Time wrt perceptual switch report (Button Press)');
        ylabel('Distance to the center (°)');
        title(['Distance to Center - Group Level - PHYS']);
        filename=[fig_dir '/GazeDistance2Center_GroupLevel_phys' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[fig_dir '/GazeDistance2Center_GroupLevel_phys' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;

        figure;
        dc = plot(time_rangeTrial,median(median_centerTrl,1),'k','LineWidth',4);
        hold on
        x2 = [time_rangeTrial, fliplr(time_rangeTrial)];
        curve1 = [median(median_centerTrl,1) + std(median_centerTrl,1)/sqrt(size(median_centerTrl,1))];
        curve2 = [median(median_centerTrl,1) - std(median_centerTrl,1)/sqrt(size(median_centerTrl,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'k','FaceAlpha',0.3);
        hold on
        for i=1:subj-1
            plot(time_rangeTrial,median_centerTrl(i,:),'k');
            hold on
        end
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
        title(['BR: Distance to Center Throughout the Trials- Group Level']);
        filename=[fig_dir '/GazeDistance2CenterWHOLEtrialBR_GroupLevel' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[fig_dir '/GazeDistance2CenterWHOLEtrialBR_GroupLevel' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;

        figure;
        dc = plot(time_rangeTrial,median(median_centerTrlPhys,1),'k','LineWidth',4);
        hold on
        x2 = [time_rangeTrial, fliplr(time_rangeTrial)];
        curve1 = [median(median_centerTrlPhys,1) + std(median_centerTrlPhys,1)/sqrt(size(median_centerTrlPhys,1))];
        curve2 = [median(median_centerTrlPhys,1) - std(median_centerTrlPhys,1)/sqrt(size(median_centerTrlPhys,1))];
        inBetween = [curve1, fliplr(curve2)];
        fill(x2, inBetween, 'k','FaceAlpha',0.3);
        hold on
        for i=1:subj-1
            plot(time_rangeTrial,median_centerTrlPhys(i,:),'k');
            hold on
        end
        ylim([0 4.5]);
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
        title(['PHYS: Distance to Center Throughout the Trials - Group Level']);
        filename=[fig_dir '/GazeDistance2CenterWHOLEtrialPHYS_GroupLevel' num2str(taskA_number) '.tiff'];
        saveas(gcf,filename);
        filename=[fig_dir '/GazeDistance2CenterWHOLEtrialPHYS_GroupLevel' num2str(taskA_number) '.fig'];
        saveas(gcf,filename);
        close;
    end
    
    %% single raincloud plots to compare the median switch timings in this current task
    if taskA_number==2
        taskA_binoriv_rel_medians(3) = nan;
    end
    addpath S:\KNEU\KNEUR-Projects\Projects\Sukanya-Backup\ViolinPlot\raincloudPlots
    % Button Release
    figure
    raincloud_plot(taskA_binoriv_rel_medians,'box_on', 1,'color',taskColor);
    hold on
    l1 = xline(2.5,'color',[0.2 0.2 0.2],'LineWidth',3,'LineStyle','--');
    yticks([]);
    xlabel('s');
    xlim([-2 7])
    xticks([0.5 1 1.5 2 2.5 3 3.5 4 4.5]);
    title(['Median PCT Distribution - Task ' num2str(taskA_number) ' Button Release'])
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    filename = [fig_dir '/PCT_medians_rel' num2str(taskA_number) '_allSubj_trueSwitch.tiff'];
    saveas(gcf,filename)
    filename = [fig_dir '/PCT_medians_rel' num2str(taskA_number) '_allSubj_trueSwitch.fig'];
    saveas(gcf,filename)
    close;

    % Disturbances to Stable Perception (Not Completed into a Perceptual Switch to the other percept)
    if taskA_number==2
        taskA_disturb_medians(3) = nan;
    end
    figure
    raincloud_plot(taskA_disturb_medians,'box_on', 1,'color',taskColor);
    hold on
    l2 = xline(2.5,'color',[0.2 0.2 0.2],'LineWidth',3,'LineStyle','--');
    % l2 = xline(median(hit_avgPrePupil_mm - miss_avgPrePupil_mm),'color',[0.8 0 0],'LineWidth',3,'LineStyle','--');
    yticks([]);
    xlabel('s');
    xlim([-2 7])
    xticks([0.5 1 1.5 2 2.5 3 3.5 4 4.5]);
    title(['Median Disturbance Moments - Task ' num2str(taskA_number) ' Button Release'])
    set(gca,'FontSize',36,'FontWeight','Bold') 
    set(gcf, 'Position', get(0, 'Screensize'));
    filename = [fig_dir '/PCT_medians_disturb' num2str(taskA_number) '_allSubj_trueSwitch.tiff'];
    saveas(gcf,filename)
    filename = [fig_dir '/PCT_medians_disturb' num2str(taskA_number) '_allSubj_trueSwitch.fig'];
    saveas(gcf,filename)
    close;
    
    % Percept switch prob. in binoriv cond. release across all subj
    figure('Position', [100 100 800 600]);
    histogram(binoriv_timing_taskA_rel_allSubj,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
    xline(mean(binoriv_timing_taskA_rel_allSubj),'-',{'Mean'})
    xline(median(binoriv_timing_taskA_rel_allSubj),'--',{'Median'})
    xlim([-0.5 5.5])
    xlabel('Time from trial onset [s]')
    ylabel('Counts');
    ylim([0 0.1])
    title({['Probability Distribution of task ' num2str(taskA_number)...
        ', Binoriv release'...
        ', Num of data: ' num2str(numel(binoriv_timing_taskA_rel_allSubj))]})
    filename = [fig_dir '/Switch_prob_binoriv_rel_' num2str(taskA_number) '_allSubj_trueSwitch.tiff'];
    saveas(gcf,filename)
    filename = [fig_dir '/Switch_prob_binoriv_rel_' num2str(taskA_number) '_allSubj_trueSwitch.fig'];
    saveas(gcf,filename)
    close;
    
    % Percept switch prob. in phys cond. release across all subj
    figure('Position', [100 100 800 600]);
    histogram(phys_timing_taskA_rel_allSubj,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
    xline(mean(phys_timing_taskA_rel_allSubj),'-',{'Mean'})
    xline(median(phys_timing_taskA_rel_allSubj),'--',{'Median'})
    xlim([-0.5 5.5])
    xlabel('Time from trial onset [s]')
    ylabel('Counts');
    ylim([0 0.1])
    title({['Probability Distribution of task ' num2str(taskA_number)...
        ', Phys release'...
        ', Num of data: ' num2str(numel(phys_timing_taskA_rel_allSubj))]})
    filename = [fig_dir '/Switch_prob_phys_rel_' num2str(taskA_number) '_allSubj_trueSwitch.tiff'];
    saveas(gcf,filename)
    filename = [fig_dir '/Switch_prob_phys_rel_' num2str(taskA_number) '_allSubj_trueSwitch.fig'];
    saveas(gcf,filename)
    close;
    
    % Percept switch prob. in disturbed perception (based on button release)
    figure('Position', [100 100 800 600]);
    histogram(disturb_timing_ins_allSubj,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
    xline(mean(disturb_timing_ins_allSubj),'-',{'Mean'})
    xline(median(disturb_timing_ins_allSubj),'--',{'Median'})
    xlim([-0.5 5.5])
    xlabel('Time from trial onset [s]')
    ylabel('Counts');
    ylim([0 0.1])
    title({['Probability Distribution of task ' num2str(taskA_number)...
        ', Disturbed perception'...
        ', Num of data: ' num2str(numel(disturb_timing_ins_allSubj))]})
    filename = [fig_dir '/Switch_prob_disturbed_ins_' num2str(taskA_number) '_allSubj_trueSwitch.tiff'];
    saveas(gcf,filename)
    filename = [fig_dir '/Switch_prob_disturbed_ins_' num2str(taskA_number) '_allSubj_trueSwitch.fig'];
    saveas(gcf,filename)
    close;
    
    figure('Position', [100 100 800 600]);
    histogram(disturb_timing_rel_allSubj,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
    xline(mean(disturb_timing_rel_allSubj),'-',{'Mean'})
    xline(median(disturb_timing_rel_allSubj),'--',{'Median'})
        xlim([-0.5 5.5])
    xlabel('Time from trial onset [s]')
    ylabel('Counts');
    ylim([0 0.1])
    title({['Probability Distribution of task ' num2str(taskA_number)...
        ', Disturbed perception'...
        ', Num of data: ' num2str(numel(disturb_timing_rel_allSubj))]})
    filename = [fig_dir '/Switch_prob_disturbed_rel_' num2str(taskA_number) '_allSubj_trueSwitch.tiff'];
    saveas(gcf,filename)
    filename = [fig_dir '/Switch_prob_disturbed_rel_' num2str(taskA_number) '_allSubj_trueSwitch.fig'];
    saveas(gcf,filename)
    close;
    
    
    %% All subjects PDF estimation for the trials where there was a perceptual switch in the first second (TASK 1)
    
    %%% First plot the entire 5-sec distribution of these trials:
    
    % Estimate the PDFs using ksdensity: Based on keyboard RELEASE times
    [frel_all,xrel_all] = ksdensity(binoriv_timing_taskA_rel_allSubjF1','Bandwidth',0.2);
    
    if taskA_number==1
        figure
        plot(xrel_all,frel_all./4,'r','LineWidth',2);
        hold on
        histogram(binoriv_timing_taskA_rel_allSubjF1,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor);
        xlabel('Data values');
        ylabel('Probability density');
        title('PCT in Trials With a Switch in the First 1-sec (Release)')
        set(gca,'FontSize',36)
        set(gcf, 'Position', get(0, 'Screensize'));
        filename = [fig_dir '/Task1_trials_w_switch_in_first_sec_allSubj_rel.fig'];
        saveas(gcf,filename)
        filename = [fig_dir '/Task1_trials_w_switch_in_first_sec_allSubj_rel.tiff'];
        saveas(gcf,filename)
        close;

    end
    
    %% All subjects PDF estimation for the trials where there was a perceptual switch in the first second (TASK 1):... 
    % ...BUT by just using the perceptual switches after the 1-sec period this time:
    % You look at both the true switches that follow true switches, and also the true switches that follow COMBINED switches (by loading the trials...
    % ...with combined switches in the first second)

    if taskA_number == 1
        rel_f1_after1sec = binoriv_timing_taskA_rel_allSubjF1(binoriv_timing_taskA_rel_allSubjF1>1);
        
        
        % Estimate the PDFs using ksdensity: Based on keyboard RELEASE times
        [frel_all,xrel_all] = ksdensity(rel_f1_after1sec','Bandwidth',0.2);
        [frel_afterComb, xrel_afterComb] = ksdensity(trueAfterCombinedAll','Bandwidth',0.2);
        
        % Make uniform distributions to compare with experimental distributions
        rng(12345);
        for i=1:1000
            rel(i,:) = unifrnd(0,4,1,numel(rel_f1_after1sec));
            relTrues(i,:) = unifrnd(0,4,1,numel(trueAfterCombinedAll));
        end

        rel = sort(rel,2,'ascend');
        rel=rel+1;

        relTrues = sort(relTrues,2,'ascend');
        relTrues = relTrues +1;
        
        unif_rel = mean(rel,1);
        unif_relTrues = mean(relTrues,1);
        
        [frel_rand,xrel_rand] = ksdensity(unif_rel','Bandwidth',0.3);
        [frelTrues_rand,xrelTrues_rand] = ksdensity(unif_relTrues,'Bandwidth',0.3);
        
        [h_rrel, p_rrel, ksstat_rrel] = kstest2(rel_f1_after1sec', unif_rel');
        [h_rrelTrues p_rrelTrues ksstat_rrelTrues] = kstest2(trueAfterCombinedAll',unif_relTrues');

        figure
        plot(xrel_all,frel_all./4,'color',taskColor,'LineWidth',2);
        hold on
        plot(xrel_rand,frel_rand./4,'Color',[0.5 0.5 0.5],'LineWidth',2);
        hold on
        histogram(rel_f1_after1sec,'norm','probability','BinEdges',binEdges,'FaceColor',taskColor,'FaceAlpha',0.6);
        hold on
        histogram(unif_rel,'norm','probability','BinEdges',binEdges,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.6);
        xlabel('Data values');
        xlim([0 4.5]);
        ylabel('Probability density');
        p_rrel = round(p_rrel,5);
        title(['PST in the Subset of Trials After 1-sec, p= ' num2str(p_rrel)]);
        set(gca,'FontSize',36)
        set(gcf, 'Position', get(0, 'Screensize'));
        filename = [fig_dir '/Task1_rel_after1sec.fig'];
        saveas(gcf,filename)
        filename = [fig_dir '/Task1_rel_after1sec.tiff'];
        saveas(gcf,filename)
        close;

        figure
        plot(xrel_afterComb,frel_afterComb./4,'color',taskColor,'LineWidth',2);
        hold on
        plot(xrelTrues_rand,frelTrues_rand./4,'Color',[0.5 0.5 0.5],'LineWidth',2);
        hold on
        histogram(trueAfterCombinedAll,'norm','probability','BinEdges',binEdges,'FaceColor',taskColor,'FaceAlpha',0.6);
        hold on
        histogram(unif_relTrues,'norm','probability','BinEdges',binEdges,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.6);
        xlabel('Data values');
        xlim([0 4.5]);
        ylabel('Probability density');
        p_rrelTrues = round(p_rrelTrues,5);
        title(['PST in the Subset of Trials After 1-sec, p= ' num2str(p_rrelTrues)]);
        set(gca,'FontSize',36)
        set(gcf, 'Position', get(0, 'Screensize'));
        filename = [fig_dir '/Task1_rel_after1sec_trueSwitchAfterCombined.fig'];
        saveas(gcf,filename)
        filename = [fig_dir '/Task1_rel_after1sec_trueSwitchAfterCombined.tiff'];
        saveas(gcf,filename)
        close;
    end
    %% summary statistics for means and medians of PCTs from each subject

    num_red = general_info.num_red_presented;
    num_blue = general_info.num_blue_presented; %physical trial count
    num_phys = num_red+num_blue;
    success_phys = general_info.success_rate;
    num_bino = general_info.num_bino_presented;
    num_disturbedSwitch = general_info.disturbedSwitches;
    num_completedSwitch = general_info.completedSwitches;
    percent_switches_inF1 = general_info.rate_switches_inF1; %true switches
    percent_physSwitch_inF1 = general_info.rate_PhysSwitches_inF1;
    percent_disturb_inF1 = general_info.rate_disturb_inF1;
    percentTrials_w_f1Change = general_info.ratio_trials_w_f1Change;
    percentTrials_w_f1TrueSwitch = general_info.ratio_trials_w_f1TrueSwitch;
    
    taskAsummary = table(num_phys,success_phys,taskA_phys_rel_means,taskA_phys_rel_medians,taskA_phys_rel_std,taskA_phys_rel_iqr,percent_physSwitch_inF1,num_bino,num_completedSwitch,num_disturbedSwitch,percent_switches_inF1,percent_disturb_inF1,percentTrials_w_f1Change,percentTrials_w_f1TrueSwitch,taskA_binoriv_rel_means,taskA_binoriv_rel_medians,taskA_binoriv_rel_std,taskA_binoriv_rel_iqr,taskA_disturb_means,taskA_disturb_medians,taskA_disturb_std,taskA_disturb_iqr);
    
    if taskA_number == 2 %subject 3 exclusion from task 2
        taskAsummary(3,:) = array2table(nan([1 size(taskAsummary,2)]));
    end
    saveDir = ['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task' num2str(taskA_number) '\meanMedians'];
    mkdir(saveDir);
    cd(saveDir);
    save('meanMedians_trueSwitch',"taskAsummary");
    save('binoriv_timings_trueSwitch',"binoriv_timing_taskA_rel_allSubj","binoriv_timing_taskA_ins_allSubj");

    %%% compare the binoriv condition means and medians with respect to 2.5 seconds, which should be the mean switch timing under no external effect: %%%
    
    diff_rel_mean_p = signrank(taskAsummary.taskA_binoriv_rel_means, 2.5, 'tail', 'left');
    
    diff_rel_median_p = signrank(taskAsummary.taskA_binoriv_rel_medians, 2.5, 'tail', 'left');

    diff_rel_disturb_mean_p = signrank(taskAsummary.taskA_disturb_means,2.5,'tail', 'left');
    
    diff_rel_disturb_median_p = signrank(taskAsummary.taskA_disturb_medians,2.5,'tail', 'left');
    
    taskAstats = table(diff_rel_mean_p,diff_rel_median_p,diff_rel_disturb_mean_p,diff_rel_disturb_median_p);
    save('signedRankSingleTask_trueSwitch',"taskAstats");
    
    all_PST_dataPoints.binoriv = binoriv_timings_bySubj;
    all_PST_dataPoints.phys = phys_timings_bySubj;
    save('all_timingDataPoints',"all_PST_dataPoints");
    
    %% find which perceptual switch events happened as a second event within each 5 seconds (so guaranteed to not be caused by fixation point jumps)
    
    if taskA_number==1
        secondary_switches_rel_allSubj = find(which_switch_rel_allSubj>1);
        percent_secondaries_rel_allSubj = (length(secondary_switches_rel_allSubj) / length(which_switch_rel_allSubj))*100;
    
        percent_secondaries_rel = percent_secondaries_rel' .* 100;
        percent_secondaries_rel = round(percent_secondaries_rel,2);
    end

    clear all
    close all
    clc
end
