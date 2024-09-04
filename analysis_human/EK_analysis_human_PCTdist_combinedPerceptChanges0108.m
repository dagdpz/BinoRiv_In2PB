% Author: Ryo Segawa (whizznihil.kid@gmail.com)
% Contributor: Ege Kingir (ege.kingir@med.uni-goettingen.de)

% Similar overall logic as the script "analysis_human_PCTdist" but this time directly combined the COMPLETED and INCOMPLETE perceptual switches.

clear all
close all
clc

%%
taskA_number = input('Enter the task that you want to compare against Task 2 (1,3, or 4): ');
taskB_number = 2;
if taskA_number == 2
    taskA_pseudoChopping = true; % Assign pseudo FP positions to task2 with the same random numbers as task1 and task3 to mimic the same reaction time plot scales as task1 and task3
else
    taskA_pseudoChopping = false;
end
if taskB_number == 2
    taskB_pseudoChopping = true;
else
    taskB_pseudoChopping = false;
end

if taskA_number==1
    taskColor = [0.3 0.5 0.9];
elseif taskA_number==3
    taskColor = [0.7 0.4 0.7];
elseif taskA_number==4
    taskColor = [0.5 0.7 0.4];
end

taskColor2 = [0.8 0.4 0.4];

data_dir_taskA = dir(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskA_number)]);
data_dir_taskA = data_dir_taskA(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir_taskA.name})); % avoid '.' and '..'

data_dir_taskB = dir(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskB_number)]);
data_dir_taskB = data_dir_taskB(~cellfun(@(x) any(regexp(x, '^\.+$')), {data_dir_taskB.name})); % avoid '.' and '..'

trial_count = 8;
fig_dir = ['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\figures'];

prob_dist_bino_taskA = [];
prob_dist_phys_taskA = [];
prob_dist_bino_taskB = [];
prob_dist_phys_taskB = [];

all_binoriv_timing_taskA_ins = [];
all_binoriv_timing_taskB_ins = [];
all_binoriv_timing_taskA_rel = [];
all_binoriv_timing_taskB_rel = [];

all_binoriv_firstTiming_taskA_rel = [];
all_binoriv_firstTiming_taskB_rel = [];


for subj = 1:numel(data_dir_taskA)
% for subj = subject:subject
    close all
    if taskA_number==2 && subj==3
        continue
    end
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
    binoriv_first_switchTimingsA = [];

    trials_f1_Switch = [];
    
    
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
    
    

    mkdir([fig_dir '/' data_dir_taskA(subj).name])
    subj_fig_dir = ([fig_dir '/' data_dir_taskA(subj).name]);
    
    
    subj_dir = dir(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/*.mat']);
%     subj_dir = dir(['Y:\Projects\Binocular_rivalry\JanisHesse\Binocular_Rivalry_Code_Ryo\Analysis\data_monkeypsychTest/task1/' data_dir_taskA(subj).name]);
    for file = 1:numel(subj_dir)
        data_taskA = load(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskA_number) '/' data_dir_taskA(subj).name '/' subj_dir(file).name]);
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
            %% Button release
    %         for trl = 1:numel(data_taskA.trial)-1
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
                    for loop = 1:8
                        if data_taskA.trial(trl-loop).stimulus ~= 4
                            for sample = 1:data_taskA.trial(trl).counter-1
                                if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                                    switch_count = switch_count+1;
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                    if switch_timing <= 5
                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
                                        if switch_count==1
                                            binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                        end
                                    end
                                elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                    switch_count = switch_count+1;
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                    if switch_timing <= 5
                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
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
                                        if switch_timing <= 5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
                                            if switch_count==1
                                                binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                            end
                                        end
                                    elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                        switch_count = switch_count+1;
                                        switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                        if switch_timing <= 5
                                            binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
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
                                    if switch_timing <= 5
                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
                                        if switch_count==1
                                            binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                        end
                                    end
                                elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                                    switch_count = switch_count+1;
                                    switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                                    if switch_timing <= 5
                                        binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
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
                            end
                        end
                        if percept_change; break; end
                    end
                    
                end        
            end

        elseif taskA_number == 2 || taskA_number == 4
            if taskA_number == 2 && taskA_pseudoChopping
                continue
            end
            %% Button insertion
            for trl = 18:numel(data_taskA.trial)-1
                
                % Binoriv 
                if data_taskA.trial(trl).stimulus == 4
                    switch_count=0; %count the number of switches that happen within a trial! -- we are interested in binoriv condition only.
                    rb=0; %counter for red to blue switches
                    br=0; %counter for blue to red switches
                    f1=0;
                    if data_taskA.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                        continue
                    end
                    
                    if data_taskA.trial(trl-1).stimulus == 1 || data_taskA.trial(trl-1).stimulus == 2 || data_taskA.trial(trl-1).stimulus == 3 % remove the first trial from each block
                        continue
                    end
                    for sample = 1:data_taskA.trial(trl).counter-1
                        if data_taskA.trial(trl).repo_red(sample) == 1 && data_taskA.trial(trl).repo_red(sample+1) == 0
                            switch_count = switch_count+1;
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                            if switch_timing <= 5
                                binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
                                if switch_count==1
                                    binoriv_first_switchTimingsA = [binoriv_first_switchTimingsA switch_timing];
                                end
                            end
                        elseif data_taskA.trial(trl).repo_blue(sample) == 1 && data_taskA.trial(trl).repo_blue(sample+1) == 0
                            switch_count = switch_count+1;
                            switch_timing = data_taskA.trial(trl).tSample_from_time_start(sample) - data_taskA.trial(trl).tSample_from_time_start(1);
                            if switch_timing <= 5
                                binoriv_timing_taskA_rel = [binoriv_timing_taskA_rel switch_timing];
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
                            end
                        end
                        if percept_change; break; end
                    end
                    
                end  
            end
            
            
        end
    all_binoriv_timing_taskA_rel = [all_binoriv_timing_taskA_rel binoriv_timing_taskA_rel];
    all_binoriv_firstTiming_taskA_rel = [all_binoriv_firstTiming_taskA_rel binoriv_first_switchTimingsA];
    end
    all_binoriv_first_switchTimingsA{subj,1} = binoriv_first_switchTimingsA;
    %%% Binoriv condition        
    taskA_binoriv_rel_means(subj,1) = mean(binoriv_timing_taskA_rel);
    taskA_binoriv_rel_medians(subj,1) = median(binoriv_timing_taskA_rel);
    taskA_binoriv_rel_std(subj,1) = std(binoriv_timing_taskA_rel);
    taskA_binoriv_rel_iqr(subj,1) = iqr(binoriv_timing_taskA_rel);

    taskA_binoriv_first_means(subj,1) = mean(binoriv_first_switchTimingsA);
    taskA_binoriv_first_medians(subj,1) = median(binoriv_first_switchTimingsA);
    taskA_binoriv_first_std(subj,1) = std(binoriv_first_switchTimingsA);
    taskA_binoriv_first_iqr(subj,1) = iqr(binoriv_first_switchTimingsA);

    taskA_binoriv_rel_means(taskA_binoriv_rel_means==0) = nan;
    taskA_binoriv_rel_medians(taskA_binoriv_rel_medians==0) = nan;
    taskA_binoriv_rel_std(taskA_binoriv_rel_std==0) = nan;
    taskA_binoriv_rel_iqr(taskA_binoriv_rel_iqr==0) = nan;

    taskA_binoriv_first_means(taskA_binoriv_first_means==0) = nan;
    taskA_binoriv_first_medians(taskA_binoriv_first_medians==0) = nan;
    taskA_binoriv_first_std(taskA_binoriv_first_std==0) = nan;
    taskA_binoriv_first_iqr(taskA_binoriv_first_iqr==0) = nan;
end

for subj = 1:numel(data_dir_taskB)
% for subj = subject:subject
    close all
    if taskB_number==2 && subj==3
        continue
    end
    binoriv_timing_taskB_ins = [];
    phys_timing_taskB_ins = [];
    binoriv_timing_taskB_rel = [];
    phys_timing_taskB_rel = [];
    binoriv_timing_taskB_ins_f1 = [];
    binoriv_timing_taskB_rel_f1 = [];
    phys_timing_taskB_ins_f1 = [];
    phys_timing_taskB_rel_f1 = [];
    which_switch_ins = [];
    which_switch_rel = [];
    distCenter = [];
    distCenterPhys = [];
    binoriv_first_switchTimingsB = [];

    trials_f1_Switch = [];
    
    
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

    
    

    mkdir([fig_dir '/' data_dir_taskB(subj).name])
    subj_fig_dir = ([fig_dir '/' data_dir_taskB(subj).name]);
    
    
    subj_dir = dir(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskB_number) '/' data_dir_taskB(subj).name '/*.mat']);
    for file = 1:numel(subj_dir)
        data_taskB = load(['S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\open_resource\data_task' num2str(taskB_number) '/' data_dir_taskB(subj).name '/' subj_dir(file).name]);

        
        % Calc num of phys stim presented & num of congruence
        for trl = 18:numel(data_taskB.trial)-1            
            if data_taskB.trial(trl).stimulus == 2 && data_taskB.trial(trl+1).stimulus ~= 2
                num_red_presented = num_red_presented + 1;
                if any(find(data_taskB.trial(trl).repo_red == 1))
                    num_red_cong = num_red_cong + 1;
                end
            elseif data_taskB.trial(trl).stimulus == 3 && data_taskB.trial(trl+1).stimulus ~= 3
                num_blue_presented = num_blue_presented + 1;
                if any(find(data_taskB.trial(trl).repo_blue == 1))
                    num_blue_cong = num_blue_cong + 1;
                end
            end
        end
        %% Task 1 or 3 (or 2)
        if taskB_number == 2 && taskB_pseudoChopping
            rng(12345); %set the seed so that you create the same sequence of random numbers each time
            fix_loc_label = randi([1 4],1,numel(data_taskB.trial));
            for trl = 1:numel(data_taskB.trial)                
                if fix_loc_label(trl) == 1
                    data_taskB.trial(trl).eye.fix.x.red = -1;
                    data_taskB.trial(trl).eye.fix.y.red = -1;
                elseif fix_loc_label(trl) == 2
                    data_taskB.trial(trl).eye.fix.x.red = -2;
                    data_taskB.trial(trl).eye.fix.y.red = -2;
                elseif fix_loc_label(trl) == 3
                    data_taskB.trial(trl).eye.fix.x.red = -3;
                    data_taskB.trial(trl).eye.fix.y.red = -3;
                elseif fix_loc_label(trl) == 4
                    data_taskB.trial(trl).eye.fix.x.red = -4;
                    data_taskB.trial(trl).eye.fix.y.red = -4;
                end
            end
        end
        
        if taskB_number == 1 || taskB_number == 3 || taskB_pseudoChopping
            %% Button insertion
            for trl = 18:numel(data_taskB.trial)-1
                % Binoriv 
                if data_taskB.trial(trl).stimulus == 4
                    switch_count=0; %count the number of switches that happen within a trial! -- we are interested in binoriv condition only.
                    rb=0; %counter for red to blue switches
                    br=0; %counter for blue to red switches
                    f1=0; %whether a perceptual switch happened within the first second of a trial or not!
                    if data_taskB.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                        continue
                    end
                    for loop = 1:8
                        if data_taskB.trial(trl-loop).stimulus ~= 4
                            for sample = 1:data_taskB.trial(trl).counter-1
                                if data_taskB.trial(trl).repo_red(sample) == 1 && data_taskB.trial(trl).repo_red(sample+1) == 0
                                    switch_count = switch_count+1;
                                    switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                                    if switch_timing <= 5
                                        binoriv_timing_taskB_rel = [binoriv_timing_taskB_rel switch_timing];
                                        if switch_count==1
                                            binoriv_first_switchTimingsB = [binoriv_first_switchTimingsB switch_timing];
                                        end
                                    end
                                elseif data_taskB.trial(trl).repo_blue(sample) == 1 && data_taskB.trial(trl).repo_blue(sample+1) == 0
                                    switch_count = switch_count+1;
                                    switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                                    if switch_timing <= 5
                                        binoriv_timing_taskB_rel = [binoriv_timing_taskB_rel switch_timing];
                                        if switch_count==1
                                            binoriv_first_switchTimingsB = [binoriv_first_switchTimingsB switch_timing];
                                        end
                                    end
                                end
                            end      
                            break
                        end

                        if data_taskB.trial(trl-loop).eye.fix.x.red == data_taskB.trial(trl).eye.fix.x.red &&...
                            data_taskB.trial(trl-loop).eye.fix.y.red == data_taskB.trial(trl).eye.fix.y.red

                            if any(find(data_taskB.trial(trl-loop).repo_red)) == 1 && any(find(data_taskB.trial(trl-loop).repo_blue)) == 1
                                break
                            elseif any(find(data_taskB.trial(trl-loop).repo_red)) == 0 && any(find(data_taskB.trial(trl-loop).repo_red)) == 1 ||...
                                    any(find(data_taskB.trial(trl-loop).repo_blue)) == 0 && any(find(data_taskB.trial(trl-loop).repo_blue)) == 1 
                                break
                            else
                                for sample = 1:data_taskB.trial(trl).counter-1
                                    if data_taskB.trial(trl).repo_red(sample) == 1 && data_taskB.trial(trl).repo_red(sample+1) == 0
                                        switch_count = switch_count+1;
                                        switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                                        if switch_timing <= 5
                                            binoriv_timing_taskB_rel = [binoriv_timing_taskB_rel switch_timing];
                                            if switch_count==1
                                                binoriv_first_switchTimingsB = [binoriv_first_switchTimingsB switch_timing];
                                            end
                                        end
                                    elseif data_taskB.trial(trl).repo_blue(sample) == 1 && data_taskB.trial(trl).repo_blue(sample+1) == 0
                                        switch_count = switch_count+1;
                                        switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                                        if switch_timing <= 5
                                            binoriv_timing_taskB_rel = [binoriv_timing_taskB_rel switch_timing];
                                            if switch_count==1
                                                binoriv_first_switchTimingsB = [binoriv_first_switchTimingsB switch_timing];
                                            end
                                        end
                                    end
                                end        
                            end
                            break
                        else
                            for sample = 1:data_taskB.trial(trl).counter-1
                                if data_taskB.trial(trl).repo_red(sample) == 1 && data_taskB.trial(trl).repo_red(sample+1) == 0
                                    switch_count = switch_count+1;
                                    switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                                    if switch_timing <= 5
                                        binoriv_timing_taskB_rel = [binoriv_timing_taskB_rel switch_timing];
                                    end
                                elseif data_taskB.trial(trl).repo_blue(sample) == 1 && data_taskB.trial(trl).repo_blue(sample+1) == 0
                                    switch_count = switch_count+1;
                                    switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl).tSample_from_time_start(1);
                                    if switch_timing <= 5
                                        binoriv_timing_taskB_rel = [binoriv_timing_taskB_rel switch_timing];
                                        if switch_count==1
                                            binoriv_first_switchTimingsB = [binoriv_first_switchTimingsB switch_timing];
                                        end
                                    end
                                end
                            end
                            break
                        end
                    end

                % Phys 
                elseif data_taskB.trial(trl).stimulus == 2 && data_taskB.trial(trl+1).stimulus ~= 2
                    for loop = 1:4
                        if data_taskB.trial(trl-loop).stimulus ~= 2
                            min_trl = trl-loop + 1;
                        end
                    end
                    
                    percept_change = false;
                    for cont_trl = min_trl:trl
                        for sample = 1:data_taskB.trial(cont_trl).counter-1
                            if data_taskB.trial(cont_trl).repo_blue(sample) == 1 && data_taskB.trial(cont_trl).repo_blue(sample+1) == 0
                                switch_timing = data_taskB.trial(cont_trl).tSample_from_time_start(sample) - data_taskB.trial(cont_trl).tSample_from_time_start(1);
                                phys_timing_taskB_rel = [phys_timing_taskB_rel switch_timing];
                                percept_change = true;
                            end
                        end
                        if percept_change; break; end
                    end                     

                elseif data_taskB.trial(trl).stimulus == 3 && data_taskB.trial(trl+1).stimulus ~= 3
                    for loop = 1:4
                        if data_taskB.trial(trl-loop).stimulus ~= 3
                            min_trl = trl-loop + 1;
                        end
                    end
                    
                    percept_change = false;
                    for cont_trl = min_trl:trl
                        for sample = 1:data_taskB.trial(cont_trl).counter-1
                            if data_taskB.trial(cont_trl).repo_red(sample) == 1 && data_taskB.trial(cont_trl).repo_red(sample+1) == 0
                                switch_timing = data_taskB.trial(cont_trl).tSample_from_time_start(sample) - data_taskB.trial(cont_trl).tSample_from_time_start(1);
                                phys_timing_taskB_rel = [phys_timing_taskB_rel switch_timing];
                                percept_change = true;
                            end
                        end
                        if percept_change; break; end
                    end
                    
                end        
            end

        elseif taskB_number == 2 || taskB_number == 4
            if taskB_number == 2 && taskB_pseudoChopping
                continue
            end
            %% Button insertion
            for trl = 18:numel(data_taskB.trial)-1
                
                % Binoriv 
                if data_taskB.trial(trl).stimulus == 4
                    switch_count=0; %count the number of switches that happen within a trial! -- we are interested in binoriv condition only.
                    rb=0; %counter for red to blue switches
                    br=0; %counter for blue to red switches
                    f1=0;
                    if data_taskB.trial(trl-1).stimulus ~= 4 % First trial in blocks in binoriv should be removed
                        continue
                    end
                    
                    if data_taskB.trial(trl-1).stimulus == 1 || data_taskB.trial(trl-1).stimulus == 2 || data_taskB.trial(trl-1).stimulus == 3% remove the first trial from each block
                        continue
                    end
                    for sample = 1:data_taskB.trial(trl).counter-1
                        if data_taskB.trial(trl).repo_red(sample) == 1 && data_taskB.trial(trl).repo_red(sample+1) == 0
                            switch_count = switch_count+1;
                            switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl-loop).tSample_from_time_start(1);
                            if switch_timing <= 5
                                binoriv_timing_taskB_rel = [binoriv_timing_taskB_rel switch_timing];
                                if switch_count==1
                                    binoriv_first_switchTimingsB = [binoriv_first_switchTimingsB switch_timing];
                                end
                            end
                        elseif data_taskB.trial(trl).repo_blue(sample) == 1 && data_taskB.trial(trl).repo_blue(sample+1) == 0
                            switch_count = switch_count+1;
                            switch_timing = data_taskB.trial(trl).tSample_from_time_start(sample) - data_taskB.trial(trl-loop).tSample_from_time_start(1);
                            if switch_timing <= 5
                                binoriv_timing_taskB_rel = [binoriv_timing_taskB_rel switch_timing];
                                if switch_count==1
                                    binoriv_first_switchTimingsB = [binoriv_first_switchTimingsB switch_timing];
                                end
                            end
                        end
                    end      
                % Phys
                elseif data_taskB.trial(trl).stimulus == 2 && data_taskB.trial(trl+1).stimulus ~= 2
                    for loop = 1:4
                        if data_taskB.trial(trl-loop).stimulus ~= 2
                            min_trl = trl-loop + 1;
                        end
                    end
                    
                    percept_change = false;
                    for cont_trl = min_trl:trl
                        for sample = 1:data_taskB.trial(cont_trl).counter-1
                            if data_taskB.trial(cont_trl).repo_blue(sample) == 1 && data_taskB.trial(cont_trl).repo_blue(sample+1) == 0
                                switch_timing = data_taskB.trial(cont_trl).tSample_from_time_start(sample) - data_taskB.trial(cont_trl).tSample_from_time_start(1);
                                phys_timing_taskB_rel = [phys_timing_taskB_rel switch_timing];
                                percept_change = true;
                            end
                        end
                        if percept_change; break; end
                    end                     

                elseif data_taskB.trial(trl).stimulus == 3 && data_taskB.trial(trl+1).stimulus ~= 3
                    for loop = 1:4
                        if data_taskB.trial(trl-loop).stimulus ~= 3
                            min_trl = trl-loop + 1;
                        end
                    end
                    
                    percept_change = false;
                    for cont_trl = min_trl:trl
                        for sample = 1:data_taskB.trial(cont_trl).counter-1
                            if data_taskB.trial(cont_trl).repo_red(sample) == 1 && data_taskB.trial(cont_trl).repo_red(sample+1) == 0
                                switch_timing = data_taskB.trial(cont_trl).tSample_from_time_start(sample) - data_taskB.trial(cont_trl).tSample_from_time_start(1);
                                phys_timing_taskB_rel = [phys_timing_taskB_rel switch_timing];
                                percept_change = true;
                            end
                        end
                        if percept_change; break; end
                    end
                    
                end  
            end
            
            
        end
    all_binoriv_timing_taskB_rel = [all_binoriv_timing_taskB_rel binoriv_timing_taskB_rel];
    all_binoriv_firstTiming_taskB_rel = [all_binoriv_firstTiming_taskB_rel binoriv_first_switchTimingsB];
    end
    all_binoriv_first_switchTimingsB{subj,1} = binoriv_first_switchTimingsB;
    %%% Binoriv condition        
    taskB_binoriv_rel_means(subj,1) = mean(binoriv_timing_taskB_rel);
    taskB_binoriv_rel_medians(subj,1) = median(binoriv_timing_taskB_rel);
    taskB_binoriv_rel_std(subj,1) = std(binoriv_timing_taskB_rel);
    taskB_binoriv_rel_iqr(subj,1) = iqr(binoriv_timing_taskB_rel);

    taskB_binoriv_first_means(subj,1) = mean(binoriv_first_switchTimingsB);
    taskB_binoriv_first_medians(subj,1) = median(binoriv_first_switchTimingsB);
    taskB_binoriv_first_std(subj,1) = std(binoriv_first_switchTimingsB);
    taskB_binoriv_first_iqr(subj,1) = iqr(binoriv_first_switchTimingsB);

    taskB_binoriv_rel_means(taskB_binoriv_rel_means==0) = nan;
    taskB_binoriv_rel_medians(taskB_binoriv_rel_medians==0) = nan;
    taskB_binoriv_rel_std(taskB_binoriv_rel_std==0) = nan;
    taskB_binoriv_rel_iqr(taskB_binoriv_rel_iqr==0) = nan;

    taskB_binoriv_first_means(taskB_binoriv_first_means==0) = nan;
    taskB_binoriv_first_medians(taskB_binoriv_first_medians==0) = nan;
    taskB_binoriv_first_std(taskB_binoriv_first_std==0) = nan;
    taskB_binoriv_first_iqr(taskB_binoriv_first_iqr==0) = nan;
end


%% All subjects PDF estimation - Comparison between two tasks
%%% Task 1

% Estimate the PDFs using ksdensity: Based on keyboard RELEASE times
[frel_allA,xrel_allA] = ksdensity(all_binoriv_timing_taskA_rel','Bandwidth',0.3);
[frel_firstA,xrel_firstA] = ksdensity(all_binoriv_firstTiming_taskA_rel,'Bandwidth',0.3);

%%% Task 2

% Estimate the PDFs using ksdensity: Based on keyboard RELEASE times
[frel_allB,xrel_allB] = ksdensity(all_binoriv_timing_taskB_rel','Bandwidth',0.3);
[frel_firstB,xrel_firstB] = ksdensity(all_binoriv_firstTiming_taskB_rel,'Bandwidth',0.3);

%Compare the distributions based on RELEASE timings between Task A and Task B:
[h_rel, p_rel, ksstat_rel] = kstest2(all_binoriv_timing_taskA_rel', all_binoriv_timing_taskB_rel');

%Compare the distributions based on RELEASE timings of FIRST switch events between Task A and Task B:
[h_relFirst, p_relFirst, ksstat_relFirst] = kstest2(all_binoriv_firstTiming_taskA_rel', all_binoriv_firstTiming_taskB_rel');

%PLOT the PDF comparison based on RELEASE
figure
% Plot the PDFs on the same axes
histogram(all_binoriv_timing_taskA_rel,20,'norm','probability','FaceColor',taskColor,'FaceAlpha',0.6)
hold on
histogram(all_binoriv_timing_taskB_rel,20,'norm','probability','FaceColor',taskColor2,'FaceAlpha',0.6)
hold on
plot(xrel_allA,frel_allA./4,'Color',taskColor,'LineWidth',3);
hold on;
plot(xrel_allB,frel_allB./4,'Color',taskColor2,'LineWidth',3);
xlim([min(xrel_allA) max(xrel_allA)])
% xlabel('Data values');
% ylabel('Probability density');
legend(['task ' num2str(taskA_number)],['task ' num2str(taskB_number)]);
xlabel('Time (s)');
ylabel('Probability density');
ylim([0 0.12])
title(['Comparison/Button Release: p=' num2str(p_rel)]);
set(gca,'FontSize',36)
set(gcf, 'Position', get(0, 'Screensize'));


filename = [fig_dir '/combinedSwitch_prob_density_' num2str(taskA_number) 'v' num2str(taskB_number) 'release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combinedSwitch_prob_density_' num2str(taskA_number) 'v' num2str(taskB_number) 'release' '.png'];
saveas(gcf,filename)

%PLOT the PDF comparison based on RELEASE -- FIRST switches
figure
% Plot the PDFs on the same axes
histogram(all_binoriv_firstTiming_taskA_rel,20,'norm','probability','FaceColor',taskColor,'FaceAlpha',0.6)
hold on
histogram(all_binoriv_firstTiming_taskB_rel,20,'norm','probability','FaceColor',taskColor2,'FaceAlpha',0.6)
hold on
plot(xrel_firstA,frel_firstA./4,'Color',taskColor,'LineWidth',3);
hold on;
plot(xrel_firstB,frel_firstB./4,'Color',taskColor2,'LineWidth',3);
xlim([min(xrel_firstA) max(xrel_firstA)])

legend(['task ' num2str(taskA_number)],['task ' num2str(taskB_number)]);
xlabel('Time(s)');
ylabel('Probability density');
ylim([0 0.22])
title(['Comparison/Button Release: p=' num2str(p_relFirst)]);
set(gca,'FontSize',36)
set(gcf, 'Position', get(0, 'Screensize'));


filename = [fig_dir '/combinedFirstSwitch_prob_density_' num2str(taskA_number) 'v' num2str(taskB_number) 'release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combinedFirstSwitch_prob_density_' num2str(taskA_number) 'v' num2str(taskB_number) 'release' '.png'];
saveas(gcf,filename)

%% Create a sample from continuous uniform distribution with values between 0 and 5; and compare the uniform distribution to the BinoRiv timings in the chosen tasks

%%% This is the good way to create actual uniform distributions %%%
% 1) 1000 iterations of uniform distributions
% 2) Sort each row in the ascending order
% 3) Take the means across the rows to get the ultimate uniform distribution, pooled from 1000 iterations.
for i=1:1000
    a_rel(i,:) = unifrnd(0,5,1,numel(all_binoriv_timing_taskA_rel));
    b_rel(i,:) = unifrnd(0,5,1,numel(all_binoriv_timing_taskB_rel));
end

a_rel = sort(a_rel,2,'ascend');
b_rel = sort(b_rel,2,'ascend');

unif_sampleArel = mean(a_rel,1);
unif_sampleBrel = mean(b_rel,1);

[frel_randA,xrel_randA] = ksdensity(unif_sampleArel','Bandwidth',0.3);
[frel_randB,xrel_randB] = ksdensity(unif_sampleBrel','Bandwidth',0.3);

%Compare the uniform and experimental distributions: kstest2 compares the data itself, not the kernel distributions etc.
%...are doing the right thing!!!
[h_rrelA, p_rrelA, ksstat_rrelA] = kstest2(all_binoriv_timing_taskA_rel', unif_sampleArel');
[h_rrelB, p_rrelB, ksstat_rrelB] = kstest2(all_binoriv_timing_taskB_rel', unif_sampleBrel');

binEdges = 0:0.25:5;
%PLOT the PDF comparison between uniform and experimental
%Task A
figure
histogram(all_binoriv_timing_taskA_rel,'norm','probability','BinEdges',binEdges,'FaceColor',taskColor,'FaceAlpha',0.6)
hold on
histogram(unif_sampleArel,'norm','probability','BinEdges',binEdges,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.6)
hold on
plot(xrel_randA,frel_randA./4,'LineWidth',2,'Color','k');
hold on;
plot(xrel_allA,frel_allA./4,'LineWidth',2,'Color',taskColor);
xlim([min(xrel_randA) max(xrel_randA)])
xlabel('Data values');
ylabel('Probability density');
ylim([0 0.1])
legend(['Exp. task ' num2str(taskA_number)], ['Uniform Dist.']);
xlabel('Data values');
ylabel('Probability density');
title(['Button Release / Task ' num2str(taskA_number) ' vs. Uniform: p=' num2str(p_rrelA)]);
set(gca,'FontSize',36)
set(gcf, 'Position', get(0, 'Screensize'));

filename = [fig_dir '/combinedSwitch_prob_density_' 'Uniform' 'v' num2str(taskA_number) 'release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combinedSwitch_prob_density_' 'Uniform' 'v' num2str(taskA_number) 'release' '.png'];
saveas(gcf,filename)

%Task B
figure
histogram(all_binoriv_timing_taskB_rel,'norm','probability','BinEdges',binEdges,'FaceColor',taskColor2,'FaceAlpha',0.6)
hold on
histogram(unif_sampleBrel,'norm','probability','BinEdges',binEdges,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.6)
hold on
plot(xrel_randB,frel_randB./4,'LineWidth',2,'Color','k');
hold on;
plot(xrel_allB,frel_allB./4,'LineWidth',2,'Color',taskColor2);
xlim([min(xrel_randB) max(xrel_randB)])
xlabel('Data values');
ylabel('Probability density');
ylim([0 0.1])
legend(['Exp. task ' num2str(taskB_number)], ['Uniform Dist.']);
xlabel('Data values');
ylabel('Probability density');
title(['Button Release / Task ' num2str(taskB_number) ' vs. Uniform: p=' num2str(p_rrelB)]);
set(gca,'FontSize',36)
set(gcf, 'Position', get(0, 'Screensize'));

filename = [fig_dir '/combinedSwitch_prob_density_' 'Uniform' 'v' num2str(taskB_number) 'release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combinedSwitch_prob_density_' 'Uniform' 'v' num2str(taskB_number) 'release' '.png'];
saveas(gcf,filename)

close all


%% perform signed-rank test to compare median PCTs from Task A and Task B -- Button Release
var1=taskA_binoriv_rel_medians(~isnan(taskB_binoriv_rel_medians));
var2=taskB_binoriv_rel_medians(~isnan(taskB_binoriv_rel_medians));

var12 = [{var1}; {var2}];

p = signrank(var1,var2);

figure

h1 = rm_raincloud(var12,taskColor,0,'ks',[],0.5);

h1.p{2,1}.FaceColor=taskColor2; %face color for the second patch
h1.s{2,1}.MarkerFaceColor=taskColor2; %marker taskColor for the second category
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = taskColor2;

yticklabels({['Task ' num2str(taskB_number)],['Task ' num2str(taskA_number)]}) %inverted because of the rm_raincloud function plot orientation!

% Also match individual data points
hold on
for i=1:size(var1,1)
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

% Plot three lines as your significance line
% 1
hold on
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{1,1}.YData) mean(h1.s{2,1}.YData)];
plot(Xv,Yv,"k-");
hold on
% 2
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.3 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{1,1}.YData) mean(h1.s{1,1}.YData)];
plot(Xv,Yv,"k-");
% 3
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.3 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{2,1}.YData) mean(h1.s{2,1}.YData)];
plot(Xv,Yv,"k-");

hold on
pF = round(p,3);
text(max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.7,(mean(h1.s{1,1}.YData)+mean(h1.s{2,1}.YData))/2,['p = ',num2str(pF)],"FontSize",36,"HorizontalAlignment","center",'FontWeight','bold');
xlim([0 4.2])
xticks([0.5 1 1.5 2 2.5 3 3.5])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PSL Medians (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Task ' num2str(taskA_number) ' vs. Task ' num2str(taskB_number) ': Median PSLs'])
hold off

fig_dir = 'S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\figures';
filename = [fig_dir '/combined_PCT_median_compare' 'Task_' num2str(taskA_number) '_vsTask_' num2str(taskB_number) '_release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combined_PCT_median_compare' 'Task_' num2str(taskA_number) '_vsTask_' num2str(taskB_number) '_release' '.png'];
saveas(gcf,filename)

close all

%% perform comparison between median PCTs but derived from only the FIRST perceptual switch events!
var1=taskA_binoriv_first_medians(~isnan(taskB_binoriv_first_medians));
var2=taskB_binoriv_first_medians(~isnan(taskB_binoriv_first_medians));

var12 = [{var1}; {var2}];

p = signrank(var1,var2);
figure

h1 = rm_raincloud(var12,taskColor,0,'ks',[],0.5);

h1.p{2,1}.FaceColor= taskColor2; %face color for the second patch
h1.s{2,1}.MarkerFaceColor= taskColor2; %marker taskColor for the second category
h1.l(1,1).Visible="off";
h1.m(2,1).MarkerFaceColor = taskColor2;

yticklabels({['Task ' num2str(taskB_number)],['Task ' num2str(taskA_number)]}) %inverted because of the rm_raincloud function plot orientation!

% Also match individual data points
hold on
for i=1:size(var1,1)
    X = [h1.s{1,1}.XData(1,i) h1.s{2,1}.XData(1,i)];
    Y = [h1.s{1,1}.YData(1,i) h1.s{2,1}.YData(1,i)];
    plot(X,Y,"k-");
end

% Plot three lines as your significance line
% 1
hold on
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{1,1}.YData) mean(h1.s{2,1}.YData)];
plot(Xv,Yv,"k-");
hold on
% 2
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.3 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{1,1}.YData) mean(h1.s{1,1}.YData)];
plot(Xv,Yv,"k-");
% 3
Xv = [max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.3 max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.5];
Yv = [mean(h1.s{2,1}.YData) mean(h1.s{2,1}.YData)];
plot(Xv,Yv,"k-");

hold on
pF = round(p,3);
text(max(max(h1.s{1,1}.XData,h1.s{2,1}.XData))+0.7,(mean(h1.s{1,1}.YData)+mean(h1.s{2,1}.YData))/2,['p = ',num2str(pF)],"FontSize",36,"HorizontalAlignment","center",'FontWeight','bold');
xlim([-0.5 4.2])
xticks([0 0.5 1 1.5 2 2.5 3 3.5 4])
set(gca,'FontSize',48)
set(gcf, 'Position', get(0, 'Screensize'));
xlabel('PSL Medians (s)') %we need to invert the x and y for all the labels and ticks as well due to rainplots being scripted in a rotated way!
title(['Task ' num2str(taskA_number) ' vs. Task ' num2str(taskB_number) ': Median First PSLs'])
hold off

fig_dir = 'S:\KNEU\KNEUR-Projects\Projects\Ege-Backup\in2PB_human_experiment\analysis_human\figures';
filename = [fig_dir '/combined_PCT_FIRSTmedian_compare' 'Task_' num2str(taskA_number) '_vsTask_' num2str(taskB_number) '_release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combined_PCT_FIRSTmedian_compare' 'Task_' num2str(taskA_number) '_vsTask_' num2str(taskB_number) '_release' '.png'];
saveas(gcf,filename)

close all

%% Analysis attempt for power spectra of the timings of first perceptual switches : DATA NOT INCLUDED IN THE MANUSCRIPT
timeBins = 0.5:(1/60):2.5;
rand_iter = 5000; % number of iterations for non-parametric testing

%%%%%%%%%%%%%%
%%% Task A %%%
%%%%%%%%%%%%%%
for s=1:18
    st_subjA = all_binoriv_first_switchTimingsA{s,1};
    st_windA = st_subjA(st_subjA>=timeBins(1) & st_subjA<=timeBins(end));

    for i=1:numel(timeBins)
        if i>1
            st_windA(st_windA>=(timeBins(i) - (timeBins(i)-timeBins(i-1))/2) & st_windA<(timeBins(i) + (timeBins(i)-timeBins(i-1))/2)) = timeBins(i); %resampling to match with 60 hz sampling in Davidson et al. (2018)
            propEl(s,i) = numel(st_windA(st_windA==single(timeBins(i))))/numel(st_windA); %first switch probability in each re-sampled point
        elseif i==1
            st_windA(st_windA>=(timeBins(i) - (1/60)/2) & st_windA<(timeBins(i) + (1/60)/2)) = timeBins(i);
            propEl(s,i) = numel(st_windA(st_windA==single(timeBins(i))))/numel(st_windA);
        end
    end

    for ran = 1:rand_iter
        randSwitch = randsample(timeBins,length(st_windA));
        random_windA{s,1}(ran,:) = randSwitch; % you assign switch timings according to the 60-hz re-sampled version, but with 5000 iterations of random samples from the possible values.
    end
    
end

propAvgA = mean(propEl,1,'omitnan'); %experimental mean switch probabilities at each sampling point (averaged across subjects)
propAvgA = propAvgA ./ sum(propAvgA); %normalize

for iter = 1:rand_iter
    rands = [];
    propRand = [];
    for sub=1:18
        rands = random_windA{sub,1}(iter,:);
        for i=1:numel(timeBins)
            propRand(sub,i) = numel(rands(rands==timeBins(i)))/numel(rands); %switch probs obtained from the current iteration for this subject
        end
    end
    randMean = mean(propRand,1); %mean switch probabilities at each sampling point across subjects: corresponding to the current iteration! (you should get 5000 different versions of the randMean: see next row
    randMean = randMean ./ sum(randMean);
    randAllMeansA(iter,:) = randMean;

end

%%%%%%%%%%%%%%
%%% Task B %%%
%%%%%%%%%%%%%%
for s=1:18
    if s==3
        continue
    end

    st_subjB = all_binoriv_first_switchTimingsB{s,1};
    st_windB = st_subjB(st_subjB>=timeBins(1) & st_subjB<=timeBins(end));

    for i=1:numel(timeBins)
        if i>1
            st_windB(st_windB>=(timeBins(i) - (timeBins(i)-timeBins(i-1))/2) & st_windB<(timeBins(i) + (timeBins(i)-timeBins(i-1))/2)) = timeBins(i);
            propEl(s,i) = numel(st_windB(st_windB==single(timeBins(i))))/numel(st_windB);
        elseif i==1
            st_windB(st_windB>=(timeBins(i) - (1/60)/2) & st_windB<(timeBins(i) + (1/60)/2)) = timeBins(i);
            propEl(s,i) = numel(st_windB(st_windB==single(timeBins(i))))/numel(st_windB);
        end
    end

    for ran = 1:rand_iter
        randSwitch = randsample(timeBins,length(st_windB));
        random_windB{s,1}(ran,:) = randSwitch; % you assign switch timings according to the 60-hz re-sampled version, but with 5000 iterations of random samples from the possible values.
    end
end
propEl(3,:) = [];
random_windB(3)=[];

propAvgB = mean(propEl,1);
propAvgB = propAvgB ./ sum(propAvgB);

for iter = 1:rand_iter
    rands = [];
    propRand = [];
    for sub=1:size(propEl,1)
        rands = random_windB{sub,1}(iter,:);
        for i=1:numel(timeBins)
            propRand(sub,i) = numel(rands(rands==timeBins(i)))/numel(rands); %switch probs obtained from the current iteration for this subject
        end
    end
    randMean = mean(propRand,1); %mean switch probabilities at each sampling point across subjects: corresponding to the current iteration! (you should get 5000 different versions of the randMean: see next row
    randMean = randMean ./ sum(randMean);
    randAllMeansB(iter,:) = randMean;

end

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
title('First Switch Probability: Resampled (60 Hz)')
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));

filename = [fig_dir '/combinedSwitchProbsResampled4Spectra_' 'Task_' num2str(taskA_number) '_release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combinedSwitchProbsResampled4Spectra_' 'Task_' num2str(taskA_number) '_release' '.png'];
saveas(gcf,filename)
close;

figure;
plot(timeBins,propAvgB,'color',taskColor2);
hold on
plot(timeBins,smoothdata(propAvgB,'movmean',4),'color',taskColor2,'LineWidth',4);
xlabel('Time (s)');
ylabel('Probability');
xlim([0.5 2.5])
xticks([0.5 1 1.5 2 2.5])
ylim([0 0.025])
yticks([0 0.005 0.010 0.015 0.020])
title('First Switch Probability: Resampled (60 Hz)')
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));

filename = [fig_dir '/combinedSwitchProbsResampled4Spectra_' 'Task_' num2str(taskB_number) '_release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combinedSwitchProbsResampled4Spectra_' 'Task_' num2str(taskB_number) '_release' '.png'];
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

%%% Fourier Transform
y = fft(propAvgB .*window');
powerB = abs(y).^2/n;    % power of the DFT

%%%%%% FOR THE RANDOMIZED PROBABILITY TIME COURSES
for ran=1:rand_iter
    yR = fft(randAllMeansB(ran,:) .* window');
    powerRand = abs(yR).^2/n;
    powerAllRandB(ran,:) = powerRand;
end

limit = rand_iter * (995/1000);
for times=1:numel(timeBins)
    powerRankB(:,times) = sort(powerAllRandB(:,times),'ascend');
end
powerLimitsB = powerRankB(limit,:);

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

%% Second stage neighbouring cluster based stats tests -- Task B
b_ind = find(powerB>powerLimitsB);
b_ind2 = [];

for b=k(1):k(end) %find the indices of the significant pair (for this dataset, there is only 1 consecutive index-pair that passes the first stage criteria, so I simply just look at that pair)
    if (powerB(b)>powerLimitsB(b) && powerB(b+1)>powerLimitsB(b+1))
        b_ind2 = [b b+1]; %get the index pair that passed the first stage criteria
    end
end

if ~isempty(b_ind2)
    expSumPowerB = powerB(b_ind2(1)) + powerB(b_ind2(2)); %sum the experimental power values at the significant neighbouring index pair.
    
    for surr=1:rand_iter
        for b=k(1):k(end)
            sumRand(b) = powerAllRandB(surr,b) + powerAllRandB(surr,b+1);
        end
        maxSum = max(sumRand);
        maxRandsB(surr,1) = maxSum;
    end
    
    rand_expB = [maxRandsB' expSumPowerB];
    sorted_allB = sort(rand_expB,'ascend');
    loc_expB = find(sorted_allB==expSumPowerB);
    p_valB = 1 - loc_expB/rand_iter;
    histogram(maxRandsB,50,'FaceColor','k');
    hold on
    xline(expSumPowerB,'r--','LineWidth',2);
    legend([''],['p: ' num2str(p_valB)])
    set(gca,'FontSize',36,'FontWeight','Bold')
    set(gcf, 'Position', get(0, 'Screensize'));
end

%% Plot the compared power spectra -- including the report of significant windows if there are any!
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
title(['Switch Timing Spectra: Task ' num2str(taskA_number) ' vs Random Dist (n=5000).'])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));

filename = [fig_dir '/combinedSwitchPowerSpectra_' 'Task_' num2str(taskA_number) 'randDist_release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combinedSwitchPowerSpectra_' 'Task_' num2str(taskA_number) 'randDist_release' '.png'];
saveas(gcf,filename)
close;

%% Task B
figure;
plot(f(k),powerB(k),'color',taskColor2,'LineWidth',2);
if ~isempty(b_ind2) && p_valB<0.05
    hold on
    plot([f(b_ind2(1)),f(b_ind2(1)+1)], [powerB(b_ind2(1))+powerB(b_ind2(1))/5,powerB(b_ind2(1))+powerB(b_ind2(1))/5],'color',taskColor2,'LineWidth',3);
end
hold on
plot(f(k),powerLimitsB(k),'color',taskColor2,'LineStyle','--','LineWidth',2);
xlabel('Frequency')
ylabel('Power')
legend(['Exp. task ' num2str(taskB_number)], ['Perm. Limits' num2str(taskB_number)])
title(['Switch Timing Spectra: Task ' num2str(taskB_number) ' vs Random Dist (n=5000).'])
set(gca,'FontSize',36,'FontWeight','Bold')
set(gcf, 'Position', get(0, 'Screensize'));

filename = [fig_dir '/combinedSwitchPowerSpectra_' 'Task_' num2str(taskB_number) 'randDist_release' '.fig'];
saveas(gcf,filename)
filename = [fig_dir '/combinedSwitchPowerSpectra_' 'Task_' num2str(taskB_number) 'randDist_release' '.png'];
saveas(gcf,filename)
close;
