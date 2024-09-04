% Author: Ryo Segawa (whizznihil.kid@gmail.com)
% Contributor: Ege Kingir (ege.kingir@med.uni-goettingen.de)

% Similar overall logic as the script "analysis_human_singleTask" but this time directly combined the COMPLETED and INCOMPLETE perceptual switches.

% Matlab 2021

clear all
close all
clc

taskNum = input('Enter the task number (1,2,3 or 4): ');

for taskA_number=taskNum:taskNum
    
    if taskA_number ==2 
        taskA_pseudoChopping = true; % Assign pseudo FP positions to task2 with the same random numbers as task1 and task3 to mimic the same reaction time plot scales as task1 and task3
    else
        taskA_pseudoChopping = false;
    end

    if taskA_number==1 %for plotting later on
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
    mkdir(fig_dir)
    
    prob_dist_bino_taskA = [];
    prob_dist_phys_taskA = [];
    prob_dist_bino_taskB = [];
    prob_dist_phys_taskB = [];
    
    binoriv_timing_taskA_rel_allSubj = [];
    phys_timing_taskA_rel_allSubj = [];
    binoriv_first_switchTimingsA = [];
    
    binoriv_timing_taskA_rel_allSubjF1 = [];
    
    which_switch_rel_allSubj = [];   
    disturb_timing_rel_allSubj = [];
    disturb_timing_rel_allSubjPhys = [];
    
    bb=0; %these two are for instances to count the switches from red to blue (bb) and blue to red (rr), respectively
    rr=0;
    bb_phys = 0;
    rr_phys = 0;

    red_distR =[];
    blue_distR =[];
    red_distB = [];
    blue_distB = [];

    allDurs = []; %to pool perceptual dominance durations across subjects for a group-level histogram.
    
    for subj = 1:numel(data_dir_taskA)
        close all
        if taskA_number==2 && subj==3 %manual exclusion of the subject due to low trial number in Task 2
            continue
        end

        binoriv_timing_taskA_rel = [];
        phys_timing_taskA_rel = [];
        binoriv_timing_taskA_rel_f1 = [];
        phys_timing_taskA_rel_f1 = [];
        which_switch_rel = [];
        distCenter = [];
        distCenterPhys = [];
        binoriv_first_switchTimingsA=[];
        
        num_red_presented = 0;
        num_blue_presented = 0;
        num_bino_presented = 0;
        num_red_cong = 0; % congruent with the stimulus (in the physical condition)
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
        
        b2pPhys=0; %counter for perceptual switch occurrences
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

        blockTimings = [];

        bb_phys = 0; %counter for perceptual switch occurrences
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

    
        mkdir([fig_dir '/' data_dir_taskA(subj).name])
        subj_fig_dir = ([fig_dir '/' data_dir_taskA(subj).name]);
        
        
        subj_dir = dir(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/*.mat']);
        for file = 1:numel(subj_dir)
            data_taskA = load(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/' subj_dir(file).name]);
            
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

                        if data_taskA.trial(trl-1).stimulus == 4 && data_taskA.trial(trl-2).stimulus ~= 4
                            block_start = data_taskA.trial(trl).tSample_from_time_start(1); %you will use this to calculate the perceptual dominance durations.
                        end

                        for loop = 1:8
                            if data_taskA.trial(trl-loop).stimulus ~= 4
                                
                                for sample = 1:data_taskA.trial(trl).counter-1 %you are searching through all samples to find at which point after the FP jump there is a switch in perception.
                                    
                                    if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                                        switch_count = switch_count+1;
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);

                                        block_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - block_start; %variable to use for perceptual dominance calculation.
                                        blockTimings = [blockTimings block_timing]; %gonna reset for each subject.

                                        if switch_timing <= 5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];

                                            if switch_timing <= 1
                                                trials_f1_Switch = [trials_f1_Switch trl];
                                            end

                                            if switch_timing <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch)) %getting all the switches in trials in which there is a switch within the first second!
                                                binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing];
                                            end

                                            if switch_count==1
                                                binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                            end
                                        end
                                    elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                        switch_count = switch_count+1;
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);

                                        block_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - block_start; %variable to use for perceptual dominance calculation.
                                        blockTimings = [blockTimings block_timing]; %gonna reset for each subject.

                                        if switch_timing <= 5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];

                                            if switch_timing <= 1
                                                trials_f1_Switch = [trials_f1_Switch trl];
                                            end

                                            if switch_timing <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing];
                                            end

                                            if switch_count==1
                                                binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
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
                                        if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                                            switch_count = switch_count+1;
                                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);

                                            block_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - block_start; %variable to use for perceptual dominance calculation.
                                            blockTimings = [blockTimings block_timing]; %gonna reset for each subject.

                                            if switch_timing <= 5
                                                binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];

                                                if switch_timing <= 1
                                                    trials_f1_Switch = [trials_f1_Switch trl];
                                                end
        
                                                if switch_timing <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                    binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing];
                                                end

                                                if switch_count==1
                                                    binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                                end
                                            end
                                        elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                            switch_count = switch_count+1;
                                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);

                                            block_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - block_start; %variable to use for perceptual dominance calculation.
                                            blockTimings = [blockTimings block_timing]; %gonna reset for each subject.

                                            if switch_timing <= 5
                                                binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];

                                                if switch_timing <= 1
                                                    trials_f1_Switch = [trials_f1_Switch trl];
                                                end
    
                                                if switch_timing <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                    binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing];
                                                end

                                                if switch_count==1
                                                    binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                                end
                                            end
                                        end
                                    end        
                                end
                                break
                            else
                                for sample = 1:data_taskA.trial(trl).counter-1
                                    if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                                        switch_count = switch_count+1;
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);

                                        block_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - block_start; %variable to use for perceptual dominance calculation.
                                        blockTimings = [blockTimings block_timing]; %gonna reset for each subject.

                                        if switch_timing <= 5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];

                                            if switch_timing <= 1
                                                trials_f1_Switch = [trials_f1_Switch trl];
                                            end

                                            if switch_timing <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing];
                                            end

                                            if switch_count==1
                                                binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                            end
                                        end
                                    elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                        switch_count = switch_count+1;
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);

                                        block_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - block_start; %variable to use for perceptual dominance calculation.
                                        blockTimings = [blockTimings block_timing]; %gonna reset for each subject.

                                        if switch_timing <= 5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];

                                            if switch_timing <= 1
                                                trials_f1_Switch = [trials_f1_Switch trl];
                                            end

                                            if switch_timing <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                                binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing];
                                            end

                                            if switch_count==1
                                                binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
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
                        
                        percept_change = false;
                        for cont_trl = min_trl:trl
                            for sample = 1:data_taskA.trial(cont_trl).counter-1
                                if data_taskA.trial(cont_trl).repo_blue(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0
                                    switch_timing = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing];
                                    percept_change = true;
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
                        
                        percept_change = false;
                        for cont_trl = min_trl:trl
                            for sample = 1:data_taskA.trial(cont_trl).counter-1
                                if data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_red(sample+1) == 0
                                    switch_timing = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing];
                                    percept_change = true;
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

                        if data_taskA.trial(trl-1).stimulus == 4 && data_taskA.trial(trl-2).stimulus ~= 4
                            block_start = data_taskA.trial(trl).tSample_from_time_start(1); %you will use this to calculate the perceptual dominance durations.
                        end
                        
                        if data_taskA.trial(trl-1).stimulus == 1 || data_taskA.trial(trl-1).stimulus == 2 || data_taskA.trial(trl-1).stimulus == 3 % remove the first trial from each block
                            continue
                        end
                        for sample = 1:data_taskA.trial(trl).counter-1
                            if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                                switch_count = switch_count+1;
                                switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);

                                block_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - block_start; %variable to use for perceptual dominance calculation.
                                blockTimings = [blockTimings block_timing]; %gonna reset for each subject.

                                if switch_timing <= 5
                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];

                                    if switch_timing <= 1
                                        trials_f1_Switch = [trials_f1_Switch trl];
                                    end

                                    if switch_timing <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing];
                                    end

                                    if switch_count==1
                                        binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                    end
                                end
                            elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                switch_count = switch_count+1;
                                switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);

                                block_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - block_start; %variable to use for perceptual dominance calculation.
                                blockTimings = [blockTimings block_timing]; %gonna reset for each subject.

                                if switch_timing <= 5
                                    binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];

                                    if switch_timing <= 1
                                        trials_f1_Switch = [trials_f1_Switch trl];
                                    end

                                    if switch_timing <= 1 || (switch_count>1 && ismember(trl,trials_f1_Switch))
                                        binoriv_timing_taskA_rel_f1 = [binoriv_timing_taskA_rel_f1 switch_timing];
                                    end

                                    if switch_count==1
                                        binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
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
                                if data_taskA.trial(cont_trl).repo_blue(sample) == 1 && data_taskA.trial(cont_trl).repo_blue(sample+1) == 0
                                    switch_timing = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing];
                                    percept_change = true;
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
                               if data_taskA.trial(cont_trl).repo_red(sample) == 1 && data_taskA.trial(cont_trl).repo_red(sample+1) == 0
                                    switch_timing = data_taskA.trial(cont_trl).tSample_from_time_start(sample) - data_taskA.trial(cont_trl).tSample_from_time_start(1);
                                    phys_timing_taskA_rel = [phys_timing_taskA_rel switch_timing];
                                    percept_change = true;
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

        dur =[]; %perceptual dominance durations, resetting for each subject
        for t=1:numel(blockTimings)-1
            if blockTimings(t+1)>blockTimings(t)
                dur(t) = blockTimings(t+1) - blockTimings(t);
            else
                dur(t) = blockTimings(t+1);
            end
        end
        perceptDur_BR(subj,1) = mean(dur);
        allDursSubj{subj,1} = dur;
        allDurs = [allDurs dur];
        
        trials_f1_Switch = unique(trials_f1_Switch); %don't count the same trial twice while determining which trials include a switch in the first second
        
        resolution=0.25; %resolution of bin edges
        binEdges = 0:resolution:5;
        binEdgesDuration = 0:resolution:25;

        %% SUBJECT-LEVEL perceptual dominance duration histograms
        histogram(dur,'norm','probability','BinEdges',binEdgesDuration,'FaceColor',taskColor); hold on
        xline(mean(dur),'-',{'Mean'})
        xline(median(dur),'--',{'Median'})
        xlim([0 25]);
        title(['Perceptual Dominance Durations' num2str(taskA_number)]);
        xlabel('Time (s)');
        ylabel('Probability');

        filename = [subj_fig_dir '/combinedSwitch_perceptDur' num2str(taskA_number) '.png'];
        saveas(gcf,filename)
        filename = [subj_fig_dir '/combinedSwitch_perceptDur' num2str(taskA_number) '.fig'];
        saveas(gcf,filename)
        close;

        %% SUBJECT-LEVEL latency histogram fit estimation
        [frel_subj,xrel_subj] = ksdensity(binoriv_timing_taskA_rel','Bandwidth',0.2);
        allSubj_f(subj,:) = frel_subj;
        allSubj_x(subj,:) = xrel_subj;

        
        

        %% SUBJECT LEVEL: Percept switch prob. in BinoRiv cond. release
        figure('Position', [100 100 800 600]);
        h = histogram(binoriv_timing_taskA_rel,'norm','probability','BinEdges',binEdges, 'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
        plot(xrel_subj,frel_subj./round(1/resolution),'color',taskColor,'LineWidth',3);
        xline(mean(binoriv_timing_taskA_rel),'-',{'Mean'})
        xline(median(binoriv_timing_taskA_rel),'--',{'Median'})
        xlim([-0.5 5.5])   
        xlabel('Time from trial onset [s]')
        ylabel('Probability');
        title(['Probability Distribution of task ' num2str(taskA_number)...
            ', Binoriv release'...
            ', Num of data: ' num2str(numel(binoriv_timing_taskA_rel))]);

        maxValue = max(h.Values); %calculating the peak latency point in each individual histogram.
        maxBins = find(h.Values==maxValue);
        maxRawTimes = binEdges(maxBins);
        maxTimes = maxRawTimes + (resolution/2);
        maxTime = mean(maxTimes); %this is the value for the "maximum point on the individual-level probability distribution histogram
        numberOfMaxes = numel(maxBins); %and this is reporting how many bins have the maximum value.

        filename = [subj_fig_dir '/combinedSwitch_prob_bino_rel' num2str(taskA_number) 'resolution_' num2str(resolution) '.png'];
        saveas(gcf,filename)
        filename = [subj_fig_dir '/combinedSwitch_prob_bino_rel' num2str(taskA_number) 'resolution_' num2str(resolution) '.fig'];
        saveas(gcf,filename)
        close;
        binoriv_timing_taskA_rel_allSubj = [binoriv_timing_taskA_rel_allSubj binoriv_timing_taskA_rel];
        binoriv_timing_taskA_rel_allSubjF1 = [binoriv_timing_taskA_rel_allSubjF1 binoriv_timing_taskA_rel_f1];
    
        if taskA_number==1
            which_switch_rel_allSubj = [which_switch_rel_allSubj which_switch_rel];
        end
        secondary_switches_rel = find(which_switch_rel>1);
        percent_secondaries_rel(subj) = length(secondary_switches_rel)/length(which_switch_rel);
        
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
%         if resolution==0.25
        filename = [subj_fig_dir '/combinedSwitch_prob_phys_rel' num2str(taskA_number) 'resolution_' num2str(resolution) '.png'];
        saveas(gcf,filename)
        filename = [subj_fig_dir '/combinedSwitch_prob_phys_rel' num2str(taskA_number) 'resolution_' num2str(resolution) '.fig'];
        saveas(gcf,filename)
%         end
        close;
        phys_timing_taskA_rel_allSubj = [phys_timing_taskA_rel_allSubj phys_timing_taskA_rel];
        
    
    
        %% EK: 28.03.24 -- Create a table and save the mean/median for the switch timings in this current task
        
        %%% Binoriv condition        
        taskA_binoriv_rel_means(subj,1) = mean(binoriv_timing_taskA_rel);
        taskA_binoriv_rel_medians(subj,1) = median(binoriv_timing_taskA_rel);
        taskA_binoriv_rel_std(subj,1) = std(binoriv_timing_taskA_rel);
        taskA_binoriv_rel_iqr(subj,1) = iqr(binoriv_timing_taskA_rel);
        
        % Peak times on individual histograms
        taskA_peakTime(subj,1) = maxTime;
        taskA_numberOfPeaks(subj,1) = numberOfMaxes;

        % Timings of first switch events only
        taskA_binoriv_first_means(subj,1) = mean(binoriv_first_switchTimingsA);
        taskA_binoriv_first_medians(subj,1) = median(binoriv_first_switchTimingsA);
        taskA_binoriv_first_std(subj,1) = std(binoriv_first_switchTimingsA);
        taskA_binoriv_first_iqr(subj,1) = iqr(binoriv_first_switchTimingsA);

        %%% Phys condition
        taskA_phys_rel_means(subj,1) = mean(phys_timing_taskA_rel);
        taskA_phys_rel_medians(subj,1) = median(phys_timing_taskA_rel);
        taskA_phys_rel_std(subj,1) = std(phys_timing_taskA_rel);
        taskA_phys_rel_iqr(subj,1) = iqr(phys_timing_taskA_rel);
        trials_w_PC_inF1{subj,1} = trials_f1_Switch;
    
    end

    %% group-level histogram for perceptual dominance durations (pooled across subjects)
    figure
    histogram(allDurs,'norm','probability','BinEdges',binEdgesDuration,'FaceColor', taskColor); hold on
    xline(mean(allDurs),'--',{'Mean'},'LineWidth',4)
%     xline(median(allDurs),'--',{'Median'})
    xlabel('Time (s)');
    ylabel('Probability');
    title(['Perceptual Dominance Durations - Subjects Pooled' num2str(taskA_number)]);
    set(gca,'FontSize',48)
    set(gcf, 'Position', get(0, 'Screensize'));
    filename = [fig_dir '/combinedDominanceDurations' num2str(taskA_number) '_allSubj.png'];
    saveas(gcf,filename)
    filename = [fig_dir '/combinedDominanceDurations' num2str(taskA_number) '_allSubj.fig'];
    saveas(gcf,filename)
    close;
    
    %% single raincloud plots to compare the median switch timings in this current task
    addpath S:\KNEU\KNEUR-Projects\Projects\Sukanya-Backup\ViolinPlot\raincloudPlots
    % Button Release
    figure
    
    raincloud_plot(taskA_binoriv_rel_medians(taskA_binoriv_rel_medians>0),'box_on', 1,'color',taskColor);
    hold on
    l1 = xline(2.5,'color',[0.2 0.2 0.2],'LineWidth',3,'LineStyle','--');
    % l2 = xline(median(hit_avgPrePupil_mm - miss_avgPrePupil_mm),'color',[0.8 0 0],'LineWidth',3,'LineStyle','--');
    yticks([]);
    xlabel('s');
    xlim([-2 7])
    xticks([0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]);
    title(['Median PCT Distribution - Task ' num2str(taskA_number) ' Button Release'])
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    filename = [fig_dir '/combinedPCT_medians_rel' num2str(taskA_number) '_allSubj.png'];
    saveas(gcf,filename)
    filename = [fig_dir '/combinedPCT_medians_rel' num2str(taskA_number) '_allSubj.fig'];
    saveas(gcf,filename)
    close;

    %% single raincloud plots to compare the peak times (instead of overall medians)
    figure
    
    raincloud_plot(taskA_peakTime(taskA_peakTime>0),'box_on', 1,'color',taskColor);
    hold on
    l1 = xline(2.5,'color',[0.2 0.2 0.2],'LineWidth',3,'LineStyle','--');
    % l2 = xline(median(hit_avgPrePupil_mm - miss_avgPrePupil_mm),'color',[0.8 0 0],'LineWidth',3,'LineStyle','--');
    yticks([]);
    xlabel('s');
    xlim([-2 7])
    xticks([0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5]);
    title(['Peak PSL Distribution - Task ' num2str(taskA_number) ' Resolution: ' num2str(resolution) ' s']);
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    filename = [fig_dir '/combinedPCT_peaks_rel' num2str(taskA_number) '_allSubj.png'];
    saveas(gcf,filename)
    filename = [fig_dir '/combinedPCT_peaks_rel' num2str(taskA_number) '_allSubj.fig'];
    saveas(gcf,filename)
    close;


    %% Percept switch prob. in binoriv cond. release across all subj
    figure('Position', [100 100 800 600]);
    histogram(binoriv_timing_taskA_rel_allSubj,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
    xline(mean(binoriv_timing_taskA_rel_allSubj),'-',{'Mean'})
    xline(median(binoriv_timing_taskA_rel_allSubj),'--',{'Median'})
    xlim([-0.5 5.5])
    xlabel('Time from trial onset [s]')
    %     ylabel('Probability');
    ylabel('Counts');
    ylim([0 0.12])
    title({['Probability Distribution of task ' num2str(taskA_number)...
        ', Binoriv release'...
        ', Num of data: ' num2str(numel(binoriv_timing_taskA_rel_allSubj))]})
    filename = [fig_dir '/combinedSwitch_prob_binoriv_rel_' num2str(taskA_number) 'resolution_' num2str(resolution) '_allSubj.png'];
    saveas(gcf,filename)
    filename = [fig_dir '/combinedSwitch_prob_binoriv_rel_' num2str(taskA_number) 'resolution_' num2str(resolution) '_allSubj.fig'];
    saveas(gcf,filename)
    close;
    
    % Percept switch prob. in phys cond. release across all subj
    figure('Position', [100 100 800 600]);
    histogram(phys_timing_taskA_rel_allSubj,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor); hold on
    xline(mean(phys_timing_taskA_rel_allSubj),'-',{'Mean'})
    xline(median(phys_timing_taskA_rel_allSubj),'--',{'Median'})
    xlim([-0.5 5.5])
    xlabel('Time from trial onset [s]')
    %     ylabel('Probability');
    ylabel('Counts');
    ylim([0 0.12])
    title({['Probability Distribution of task ' num2str(taskA_number)...
        ', Phys release'...
        ', Num of data: ' num2str(numel(phys_timing_taskA_rel_allSubj))]})
    filename = [fig_dir '/combinedSwitch_prob_phys_rel_' num2str(taskA_number) 'resolution_' num2str(resolution) '_allSubj.png'];
    saveas(gcf,filename)
    filename = [fig_dir '/combinedSwitch_prob_phys_rel_' num2str(taskA_number) 'resolution_' num2str(resolution) '_allSubj.fig'];
    saveas(gcf,filename)
    close;

    %% Plotting the latency fits for each subject together (Igor's suggestion for showing individual level data)
    figure;
    for i=1:size(allSubj_f,1)
        plot(allSubj_x(i,:),allSubj_f(i,:)./round(1/resolution),'color',taskColor);
        hold on
    end

    xlabel('(s)');
    ylabel('Probability');
    title(['Individual-Level Fits for Latency Histograms: Task ' num2str(taskA_number)]);
    xticks([0 1 2 3 4 5])
    set(gca,'FontSize',36)
    set(gcf, 'Position', get(0, 'Screensize'));
    
    filename = [fig_dir '/combinedSwitch_individualsHistogramFits' num2str(taskA_number) '.fig'];
    saveas(gcf,filename)
    filename = [fig_dir '/combinedSwitch_individualsHistogramFits' num2str(taskA_number) '.png'];
    saveas(gcf,filename)
    close;
    
    %% All subjects PDF estimation for the trials where there was a perceptual switch in the first second (TASK 1)
    [frel_all,xrel_all] = ksdensity(binoriv_timing_taskA_rel_allSubjF1','Bandwidth',0.2);
    
    %% All subjects PDF estimation for the trials where there was a perceptual switch in the first second (TASK 1): BUT by just using the perceptual switches after the 1-sec period this time:

    if taskA_number == 1

        figure
        plot(xrel_all,frel_all./round(1/resolution),'color',taskColor,'LineWidth',3);
        hold on
        histogram(binoriv_timing_taskA_rel_allSubjF1,20,'norm','probability','BinEdges',binEdges,'FaceAlpha', 0.5, 'FaceColor', taskColor);
        xlabel('Data values');
        ylabel('Probability density');
        title('PCT in Trials With a Switch in the First 1-sec (Release)')
        set(gca,'FontSize',36)
        set(gcf, 'Position', get(0, 'Screensize'));
        filename = [fig_dir '/Combined_Task1_trials_w_switch_in_first_sec_allSubj_rel' 'resolution_' num2str(resolution) '.fig'];
        saveas(gcf,filename)
        filename = [fig_dir '/Combined_Task1_trials_w_switch_in_first_sec_allSubj_rel' 'resolution_' num2str(resolution) '.png'];
        saveas(gcf,filename)
        close;

        rel_f1_after1sec = binoriv_timing_taskA_rel_allSubjF1(binoriv_timing_taskA_rel_allSubjF1>1);
        
        
        % Estimate the PDFs using ksdensity: Based on keyboard RELEASE times
        [frel_all,xrel_all] = ksdensity(rel_f1_after1sec','Bandwidth',0.2);
        
        % Make uniform distributions to compare with experimental distributions
        for i=1:1000
    %         ins(i,:) = unifrnd(0,4,1,numel(ins_f1_after1sec));
            rel(i,:) = unifrnd(0,4,1,numel(rel_f1_after1sec));
        end

        rel = sort(rel,2,'ascend');
        rel=rel+1;
        
        unif_rel = mean(rel,1);
        
        [frel_rand,xrel_rand] = ksdensity(unif_rel','Bandwidth',0.3);      
        [h_rrel, p_rrel, ksstat_rrel] = kstest2(rel_f1_after1sec', unif_rel');
        
        figure
        plot(xrel_all,frel_all./round(1/resolution),'color',taskColor,'LineWidth',3);
        hold on
        plot(xrel_rand,frel_rand./round(1/resolution),'Color',[0.5 0.5 0.5],'LineWidth',2);
        hold on
        histogram(rel_f1_after1sec,'norm','probability','BinEdges',binEdges,'FaceColor',taskColor,'FaceAlpha',0.6);
        hold on
        histogram(unif_rel,'norm','probability','BinEdges',binEdges,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.6);
        xlabel('Data values');
        xlim([0 6]);
        ylabel('Probability density');
        p_rrel = round(p_rrel,5);
        title(['PCT in the Subset of Trials After 1-sec (Release), p= ' num2str(p_rrel)]);
        set(gca,'FontSize',36)
        set(gcf, 'Position', get(0, 'Screensize'));
%         if resolution==0.25
        filename = [fig_dir '/Task1_combinedRel_after1sec' 'resolution_' num2str(resolution) '.fig'];
        saveas(gcf,filename)
        filename = [fig_dir '/Task1_combinedRel_after1sec' 'resolution_' num2str(resolution) '.png'];
        saveas(gcf,filename)
%         end
        close;

            
    end
    %% summary statistics for means and medians of PCTs from each subject
     
    taskAsummary = table(taskA_binoriv_rel_means,taskA_binoriv_rel_medians,taskA_binoriv_rel_std,taskA_binoriv_rel_iqr,taskA_binoriv_first_means,taskA_binoriv_first_medians,taskA_binoriv_first_std,taskA_binoriv_first_iqr);
    taskApeaks = table(taskA_peakTime,taskA_numberOfPeaks);
    if taskA_number == 2
        taskAsummary(3,:) = array2table(nan([1 size(taskAsummary,2)]));
        taskApeaks(3,:) = array2table(nan([1 size(taskApeaks,2)]));
    end
    saveDir = ['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\statsSummary\task' num2str(taskA_number) '\meanMedians'];
    mkdir(saveDir);
    cd(saveDir);
    save('meanMedians_allChanges',"taskAsummary");
    save('binoriv_timings_combinedSwitch',"binoriv_timing_taskA_rel_allSubj");
    %%% compare the binoriv condition means and medians with respect to 2.5 seconds, which should be the mean switch timing under no switch effect: %%%
    
    diff_rel_mean_p = signrank(taskAsummary.taskA_binoriv_rel_means, 2.5, 'tail', 'left');
    diff_rel_median_p = signrank(taskAsummary.taskA_binoriv_rel_medians, 2.5, 'tail', 'left');
    diff_relPeak_p = signrank(taskApeaks.taskA_peakTime, 2.5, 'tail', 'left');
    
    taskAstats = table(diff_rel_mean_p,diff_rel_median_p,diff_relPeak_p); %we do not have the first switch timings here because there is no theoretical expectation from that type of distribution, we KNOW that it is skewed anyways.
    save('signedRankSingleTask_allChanges',"taskAstats");

    
    filenamePeak = ['individualHistogramPeaks_allChanges_resolution' num2str(resolution) '.mat'];
    save(filenamePeak,"taskApeaks","resolution","allSubj_x","allSubj_f"); %save peak bin value of individual perceptual switch latency histogram, and the fitted distribution values for each individual.

    %% save the trials with perceptual changes (combined) in the first second
    save('trialsWithCombinedPS_inF1',"trials_w_PC_inF1");
    

    %% power analysis for periodicity in the "block timings" of all subjects: DATA NOT INCLUDED IN THE MANUSCRIPT
    % resample block timings at 60 hz!

    timeBins = 0:(1/60):5; %in this case these are the possible values of perceptual dominance durations at 60 Hz sampling.
    rand_iter = 5000; % number of iterations for non-parametric testing

    for s=1:18
        subjDurs = allDursSubj{s,1};
        subjWind = subjDurs(subjDurs>=timeBins(1) & subjDurs<=timeBins(end));

        for i=1:numel(timeBins)
            if i>1
                subjWind(subjWind>=(timeBins(i) - (timeBins(i)-timeBins(i-1))/2) & subjWind<(timeBins(i) + (timeBins(i)-timeBins(i-1))/2)) = timeBins(i); %resampling to match with 60 hz sampling in Davidson et al. (2018)
                propEl(s,i) = numel(subjWind(subjWind==timeBins(i)))/numel(subjWind); %first switch probability in each re-sampled point
            elseif i==1
                subjWind(subjWind>=(timeBins(i) - (1/60)/2) & subjWind<(timeBins(i) + (1/60)/2)) = timeBins(i);
                propEl(s,i) = numel(subjWind(subjWind==timeBins(i)))/numel(subjWind);
            end
        end

        for ran = 1:rand_iter
            randSwitch = randsample(timeBins,length(subjWind));
            randWind{s,1}(ran,:) = randSwitch; % you assign switch timings according to the 60-hz re-sampled version, but with 5000 iterations of random samples from the possible values.
        end
    end
    
    if taskA_number==2
        propEl(3,:) = [];
        randWind(3)=[];
    end

    propAvgA = mean(propEl,1,'omitnan'); %experimental mean switch probabilities at each sampling point (averaged across subjects)
    propAvgA = propAvgA ./ sum(propAvgA); %normalize

    for iter = 1:rand_iter
        rands = [];
        propRand = [];
        for sub=1:size(propEl,1)
            rands = randWind{sub,1}(iter,:);
            for i=1:numel(timeBins)
                propRand(sub,i) = numel(rands(rands==timeBins(i)))/numel(rands); %switch probs obtained from the current iteration for this subject
            end
        end
        randMean = mean(propRand,1); %mean switch probabilities at each sampling point across subjects: corresponding to the current iteration! (you should get 5000 different versions of the randMean: see next row
        randMean = randMean ./ sum(randMean);
        randAllMeansA(iter,:) = randMean;
    
    end
    
    %% plot the probability of dominance durations at each sampled point.
    figure;
    plot(timeBins,propAvgA,'color',taskColor);
    hold on
    plot(timeBins,smoothdata(propAvgA,'movmean',4),'color',taskColor,'LineWidth',4);
    xlabel('Time (s)');
    ylabel('Probability');
    xlim([0.5 2.5])
    xticks([0.5 1 1.5 2 2.5])
    ylim([0 0.035])
    yticks([0 0.005 0.010 0.015 0.020 0.025 0.030])
    title('Dominance Duration Probability: Resampled (60 Hz)')
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));

    filename = [fig_dir '/combinedPerceptDurResampled4Spectra_' 'Task_' num2str(taskA_number) '_release' '.fig'];
    saveas(gcf,filename)
    filename = [fig_dir '/combinedPerceptDurResampled4Spectra_' 'Task_' num2str(taskA_number) '_release' '.png'];
    saveas(gcf,filename)
    close;

    %% Fourier Transform

    % define params -- valid for Task B as well
    fs = 60;
    T = 1/fs;
    n = length(propAvgA);    % number of samples
    tA = (0:n-1)*T;
    
    f = (0:n-1)*(fs/n);     % frequency range
    window = hanning(n);
    
    y = fft(propAvgA .*window');
    powerA = abs(y).^2/n;    % power of the DFT
    
    %%%%%% FOR THE RANDOMIZED PROBABILITY TIME COURSES
    for ran=1:rand_iter
        yR = fft(randAllMeansA(ran,:) .* window');
        powerRand = abs(yR).^2/n;
        powerAllRandA(ran,:) = powerRand;
    end
    
    limit = rand_iter * (995/1000);
    for times=1:numel(timeBins)
        powerRankA(:,times) = sort(powerAllRandA(:,times),'ascend');
    end
    powerLimitsA = powerRankA(limit,:);
   
    
    ftemp = f;
    ftemp(ftemp<1 | ftemp>15)=0;
    k = find(ftemp);

    %% Second stage neighbouring cluster based stats tests -- Task A
    a_ind = find(powerA>powerLimitsA);
    a_ind2 = [];
    
    for a=k(1):k(end) %find the indices of the significant pair (for this dataset, there is only 1 consecutive index-pair that passes the first stage criteria, so I simply just look at that pair)
        if (powerA(a)>powerLimitsA(a) && powerA(a+1)>powerLimitsA(a+1))
            a_ind2 = [a a+1]; %get the index pair that passed the first stage criteria
        end
    end
    
    if ~isempty(a_ind2)
        expSumPowerA = powerA(a_ind2(1)) + powerA(a_ind2(2)); %sum the experimental power values at the significant neighbouring index pair.
        
        for surr=1:rand_iter
            for a=k(1):k(end)
                sumRand(a) = powerAllRandA(surr,a) + powerAllRandA(surr,a+1);
            end
            maxSum = max(sumRand);
            maxRandsA(surr,1) = maxSum;
        end
        
        rand_expA = [maxRandsA' expSumPowerA];
        sorted_allA = sort(rand_expA,'ascend');
        loc_expA = find(sorted_allA==expSumPowerA);
        p_valA = 1 - loc_expA/(rand_iter+1);
        histogram(maxRandsA,50,'FaceColor','k');
        hold on
        xline(expSumPowerA,'r--','LineWidth',2);
        legend([''],['p: ' num2str(p_valA)])
        set(gca,'FontSize',36,'FontWeight','Bold')
        set(gcf, 'Position', get(0, 'Screensize'));
    end

    figure;
    plot(f(k),powerA(k),'color',taskColor,'LineWidth',2);
    if ~isempty(a_ind2) && p_valA<0.05
        hold on
        plot([f(a_ind2(1)),f(a_ind2(1)+1)], [powerA(a_ind2(1))+powerA(a_ind2(1))/5,powerA(a_ind2(1))+powerA(a_ind2(1))/5],'color',taskColor,'LineWidth',3);
    end
    hold on
    plot(f(k),powerLimitsA(k),'color',taskColor,'LineStyle','--','LineWidth',2);
    
    xlabel('Frequency')
    ylabel('Power')
    legend(['Exp. task ' num2str(taskA_number)], ['Perm. Limits' num2str(taskA_number)])
    title(['Dominance Duration Spectra: Task ' num2str(taskA_number) ' vs Random Dist (n=5000).'])
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
    
    filename = [fig_dir '/dominanceDurationPowerSpectra_' 'Task_' num2str(taskA_number) 'randDist_release' '.fig'];
    saveas(gcf,filename)
    filename = [fig_dir '/dominanceDurationPowerSpectra_' 'Task_' num2str(taskA_number) 'randDist_release' '.png'];
    saveas(gcf,filename)
    close;
    
    %%
    clear all
    close all
    clc
end
