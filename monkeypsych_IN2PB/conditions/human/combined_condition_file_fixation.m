% combined_condition_file_Linus_binoriv_fixation
% Initiate conditions, example file for a single experiment

global SETTINGS VAR
% set SETTINGS.background_image to 'gratings' for Linus to show gratings in the background
SETTINGS.background_image = 'gratings';

if ~exist('dyn','var') || dyn.trialNumber == 1
    
    
    
    experiments        = {'fixation training for binoriv task'};
    
    
    si_counter=0; % only important for several experiments
    for n_exp = 1:numel(experiments)
        experiment=experiments{n_exp};
        shuffle_conditions                  = 2; % 0, 1, 2 ???
        force_conditions                    = 3; % normal task 3, and 1 to repeat if he does mistake
        task.calibration                    = 0;
        SETTINGS.GUI_in_acquisition         = 0;
        SETTINGS.check_motion_jaw           = 0;
        SETTINGS.check_motion_body          = 0;
        SETTINGS.RewardSound                = 1;
        
        
        task.reward.time_neutral            = [0.15 0.15]; % s 
        task.rest_hand                      = [0 0]; % which hands on the sensor to start the trial
        task.check_screen_touching          = 1;
        
        
        %% Order of fields here defines the order of parameters to be sent to TDT as the trial_classifiers
        All = struct('angle_cases',0,'instructed_choice_con',0,'type_con',0,'effector_con',0,'reach_hand_con',0,'excentricities',0,'stim_con',0,'timing_con',0,'size_con',0,...
            'tar_dis_con',0,'mat_dis_con',0,'cue_pos_con',0,'shape_con',0,'offset_con',0,'invert_con',0,'exact_excentricity_con_x',NaN,'exact_excentricity_con_y',NaN,'reward_con',1,'reward_sound_con',1,'rest_hands_con',1,'var_x',0,'var_y',0);
        
        
        
        switch experiment
            
            case 'fixation training for binoriv task'
                SETTINGS.GUI_in_acquisition         = 1;
                
                %% make the task's timeline
                VAR.main_task = 1; % 0 for only binocular rivalry switches;
                VAR.num_trial = 8;
                VAR.num_triad = 12;
                VAR.num_superblock = 5; % the number of super-blocks
                VAR.pre_cue = 1; % sec
                VAR.short_break = 8; % break time (sec) after physical/binocular blocks % 8000 ms
                VAR.long_break = 120; % break time (sec) after one super-block 
                VAR.condition = []; % 1=fixation, 2=red, 3=blue, 4=binoriv, 5=rest, 6=long break
                VAR.current_trial = 0;
                % For the physical switches 
                VAR.phys_colour = [];
                for i=1:VAR.num_trial/2;VAR.phys_colour=horzcat(VAR.phys_colour,0);end
                for i=1:VAR.num_trial/2;VAR.phys_colour=horzcat(VAR.phys_colour,1);end
                
                if VAR.main_task == 1
                    for spb = 1:VAR.num_superblock
                        for trd = 1:VAR.num_triad
                            % Fixation cue
                            VAR.condition = vertcat(VAR.condition, 1);
                            
                            % Main switches
                            switch_seed = randi([0 1],1,1); % 0: phys -> binoriv, 1: binoriv -> phys
                            VAR.phys_colour = VAR.phys_colour(randperm(VAR.num_trial)); % shuffle the order of the phys stimuli
                            if switch_seed == 0 % phys -> binoriv
                                for trl = 1:VAR.num_trial
                                    if VAR.phys_colour(trl) == 0
                                        VAR.condition = vertcat(VAR.condition, 2);
                                    elseif VAR.phys_colour(trl) == 1
                                        VAR.condition = vertcat(VAR.condition, 3);
                                    end
                                end 
                                for trl = 1:VAR.num_trial
                                    VAR.condition = vertcat(VAR.condition, 4);
                                end 
                            else % binoriv -> phys
                                for trl = 1:VAR.num_trial
                                    VAR.condition = vertcat(VAR.condition, 4);
                                end
                                for trl = 1:VAR.num_trial
                                    if VAR.phys_colour(trl) == 0
                                        VAR.condition = vertcat(VAR.condition, 2);
                                    elseif VAR.phys_colour(trl) == 1
                                        VAR.condition = vertcat(VAR.condition, 3);
                                    end
                                end 
                            end
                            
                            % Rest
                            VAR.condition = vertcat(VAR.condition, 5);
                        end % trd = 1:VAR.num_triad
                        % Long break
                        VAR.condition = vertcat(VAR.condition, 6);
                    end % spb = 1:VAR.num_superblock
                else
                    VAR.condition = zeros(VAR.num_superblock*VAR.num_triad*(1+VAR.num_trial*2+1),1);
                    VAR.condition(:,1) = 4;
                end
                
                
                N_repetitions                       = 1000;%10; % repetitions of unique! combination
                
                %% Set stimulus values
                
                photos = 0; % 0: no photos overlayed; 1: photos overlaye

                % grating-related
                dist_scr = 47; % distance from screen (cm)
                diameter_gra = 7.5; % diameter of grating circle (deg)
                sf = 0.6;%1.2%1.5; % spatial frequency (cycle/degree)
                max_intensity_red = 115;%0.3396*max_blue_intensity; % max contrast intensity [0 255]; 255 is the strongest
                max_intensity_blue = 250;
                phase_red = (3/2)*pi;
                phase_blue = (3/2)*pi;

                % make stimulus image
                % if visual angle is less than 10°, tanV(deg) = S(size of stimulus)/D(distance from screen), i.e. S = D * tanV
                D = dist_scr;   % viewing distance (cm)
                V = diameter_gra; % diameter of grating circle (deg)
                diameter = 2*D * tand(V/2);%tand(V)*D % cm
                % from cm to px:
                VAR.width_pxpercm = SETTINGS.screenSize(3)/task.screen_width;
                xysize = diameter * VAR.width_pxpercm; % px
% 
                VAR.radius = xysize/2; % px
                cycles = sf * diameter_gra; % in case the unit of spatial frequency is cycles/degree
                xylim = pi*cycles;
% 
% %                 [xc, yc] = deg2pix_xy(0,0); % in the center with vertical offset
% 
%                 % make stimulus image
%                 [x,y] = meshgrid(-xylim:2*xylim/(round(xysize)-1):xylim, ...
%                     -xylim:2*xylim/(round(xysize)-1):xylim);
% 
%                 VAR.image_bino = zeros(round(xysize),round(xysize),3); % spatial freq depends on the size of stimulus
%                 circle = x.^2 + y.^2 <= xylim^2; % circular boundry
% 
% %                 destrect = [-xysize/2+xc, -xysize/2+yc, +xysize/2+xc, +xysize/2+yc];
% 
%                 % create gratings
%                 VAR.image_bino(:,:,1) = ((max_intensity_red-42.5) + (sin(x+phase_red) + 1)/2*42.5) .* circle; % RMS contrast=35%
%                 VAR.image_bino(:,:,3) = ((max_intensity_blue-105) + (sin(y+phase_blue) + 1)/2*105) .* circle; % RMS contrast=35%

%                 HideCursor;
%                 bino = Screen('MakeTexture', SETTINGS.window, VAR.image_bino);
%                 Screen('DrawTexture', SETTINGS.window, bino)

                %% pick up coordinates at max value of gratings 
                VAR.wave_length = (xysize/(cycles));
                VAR.wave_length_half = VAR.wave_length/2;
                VAR.x_cent = SETTINGS.screenSize(3)/2;
                VAR.y_cent = SETTINGS.screenSize(4)/2;
                
                %% fixation point locations
                FP_loc = 1; % 0: fixed distance (theta) from the centre, 1: FP onto non-grating-overlapped place, 2: FP onto grating-overlapped place
                distfromcent = 1; % distance from centre in num of grating lines; integer
                theta = 1.0; % distance of a fixation spot from the centre (deg)
                
                fix_rad = 1.5;
                fix_size = 0.2; % size of fixation spot; diameter (deg)
                V_fp = fix_size; % size of fixation spot (deg)
                diameter_fp = 2*D * tand(V_fp/2); % cm
                xysize_fp = diameter_fp * VAR.width_pxpercm; %diameter/(2.54/(screen_diagonal/screen_inch)); % 2.54 is cm/inch
                VAR.radius_fp = xysize_fp/2; % px
                wave_length_dist = VAR.wave_length*distfromcent;
                if FP_loc == 1 %FP onto non-grating-overlapped place
                    fix_upleft_red = [VAR.x_cent-wave_length_dist-VAR.radius_fp VAR.y_cent-wave_length_dist-VAR.wave_length_half-VAR.radius_fp VAR.x_cent-wave_length_dist+VAR.radius_fp VAR.y_cent-wave_length_dist-VAR.wave_length_half+VAR.radius_fp];
                    fix_upright_red = [VAR.x_cent+wave_length_dist-VAR.radius_fp VAR.y_cent-wave_length_dist-VAR.wave_length_half-VAR.radius_fp VAR.x_cent+wave_length_dist+VAR.radius_fp VAR.y_cent-wave_length_dist-VAR.wave_length_half+VAR.radius_fp];
                    fix_belowleft_red = [VAR.x_cent-wave_length_dist-VAR.radius_fp VAR.y_cent+wave_length_dist+VAR.wave_length_half-VAR.radius_fp VAR.x_cent-wave_length_dist+VAR.radius_fp VAR.y_cent+wave_length_dist+VAR.wave_length_half+VAR.radius_fp];
                    fix_belowright_red = [VAR.x_cent+wave_length_dist-VAR.radius_fp VAR.y_cent+wave_length_dist+VAR.wave_length_half-VAR.radius_fp VAR.x_cent+wave_length_dist+VAR.radius_fp VAR.y_cent+wave_length_dist+VAR.wave_length_half+VAR.radius_fp];
                    VAR.potential_loc_red = [fix_upleft_red; fix_upright_red; fix_belowleft_red; fix_belowright_red];
                    VAR.potential_loc_red_x = [VAR.potential_loc_red(1,3)-(VAR.potential_loc_red(1,3)-VAR.potential_loc_red(1,1))/2  VAR.potential_loc_red(2,3)-(VAR.potential_loc_red(2,3)-VAR.potential_loc_red(2,1))/2     VAR.potential_loc_red(3,3)-(VAR.potential_loc_red(3,3)-VAR.potential_loc_red(3,1))/2   VAR.potential_loc_red(4,3)-(VAR.potential_loc_red(4,3)-VAR.potential_loc_red(4,1))/2];
                    VAR.potential_loc_red_y = [VAR.potential_loc_red(1,4)-(VAR.potential_loc_red(1,4)-VAR.potential_loc_red(1,2))/2    VAR.potential_loc_red(2,4)-(VAR.potential_loc_red(2,4)-VAR.potential_loc_red(2,2))/2  VAR.potential_loc_red(3,4)-(VAR.potential_loc_red(3,4)-VAR.potential_loc_red(3,2))/2   VAR.potential_loc_red(4,4)-(VAR.potential_loc_red(4,4)-VAR.potential_loc_red(4,2))/2];

                    fix_upleft_blue = [VAR.x_cent-wave_length_dist-VAR.wave_length_half-VAR.radius_fp VAR.y_cent-wave_length_dist-VAR.radius_fp VAR.x_cent-wave_length_dist-VAR.wave_length_half+VAR.radius_fp VAR.y_cent-wave_length_dist+VAR.radius_fp];
                    fix_upright_blue = [VAR.x_cent+wave_length_dist+VAR.wave_length_half-VAR.radius_fp VAR.y_cent-wave_length_dist-VAR.radius_fp VAR.x_cent+wave_length_dist+VAR.wave_length_half+VAR.radius_fp VAR.y_cent-wave_length_dist+VAR.radius_fp];
                    fix_belowleft_blue = [VAR.x_cent-wave_length_dist-VAR.wave_length_half-VAR.radius_fp VAR.y_cent+wave_length_dist-VAR.radius_fp VAR.x_cent-wave_length_dist-VAR.wave_length_half+VAR.radius_fp VAR.y_cent+wave_length_dist+VAR.radius_fp];
                    fix_belowright_blue = [VAR.x_cent+wave_length_dist+VAR.wave_length_half-VAR.radius_fp VAR.y_cent+wave_length_dist-VAR.radius_fp VAR.x_cent+wave_length_dist+VAR.wave_length_half+VAR.radius_fp VAR.y_cent+wave_length_dist+VAR.radius_fp];
                    VAR.potential_loc_blue = [fix_upleft_blue; fix_upright_blue; fix_belowleft_blue; fix_belowright_blue];
                    VAR.potential_loc_blue_x = [VAR.potential_loc_blue(1,3)-(VAR.potential_loc_blue(1,3)-VAR.potential_loc_blue(1,1))/2  VAR.potential_loc_blue(2,3)-(VAR.potential_loc_blue(2,3)-VAR.potential_loc_blue(2,1))/2     VAR.potential_loc_blue(3,3)-(VAR.potential_loc_blue(3,3)-VAR.potential_loc_blue(3,1))/2   VAR.potential_loc_blue(4,3)-(VAR.potential_loc_blue(4,3)-VAR.potential_loc_blue(4,1))/2];
                    VAR.potential_loc_blue_y = [VAR.potential_loc_blue(1,4)-(VAR.potential_loc_blue(1,4)-VAR.potential_loc_blue(1,2))/2    VAR.potential_loc_blue(2,4)-(VAR.potential_loc_blue(2,4)-VAR.potential_loc_blue(2,2))/2  VAR.potential_loc_blue(3,4)-(VAR.potential_loc_blue(3,4)-VAR.potential_loc_blue(3,2))/2   VAR.potential_loc_blue(4,4)-(VAR.potential_loc_blue(4,4)-VAR.potential_loc_blue(4,2))/2];

                elseif FP_loc == 2 %FP onto grating-overlapped place
                    fix_left = [VAR.x_cent-wave_length_dist-VAR.radius_fp VAR.y_cent-wave_length_dist-VAR.radius_fp VAR.x_cent-wave_length_dist+VAR.radius_fp VAR.y_cent-wave_length_dist+VAR.radius_fp];
                    fix_up = [VAR.x_cent+wave_length_dist-VAR.radius_fp VAR.y_cent-wave_length_dist-VAR.radius_fp VAR.x_cent+wave_length_dist+VAR.radius_fp VAR.y_cent-wave_length_dist+VAR.radius_fp];
                    fix_below = [VAR.x_cent-wave_length_dist-VAR.radius_fp VAR.y_cent+wave_length_dist-VAR.radius_fp VAR.x_cent-wave_length_dist+VAR.radius_fp VAR.y_cent+wave_length_dist+VAR.radius_fp];
                    fix_right = [VAR.x_cent+wave_length_dist-VAR.radius_fp VAR.y_cent+wave_length_dist-VAR.radius_fp VAR.x_cent+wave_length_dist+VAR.radius_fp VAR.y_cent+wave_length_dist+VAR.radius_fp];
                    VAR.potential_loc_red = [fix_left; fix_right; fix_up; fix_below];
                    VAR.potential_loc_blue = [fix_left; fix_right; fix_up; fix_below];
                else
                    [centre(1), centre(2)] = RectCenter(SETTINGS.screenSize);
                    fix_d = 2 * dist_scr * tand(theta/2) * (180/pi); % distance of a fixation spot from the centre (left)
                    fix_cent = [centre(1:1)-VAR.radius_fp centre(2:2)-VAR.radius_fp centre(1:1)+VAR.radius_fp centre(2:2)+VAR.radius_fp];

                    fix_left = [centre(1:1)-fix_d-VAR.radius_fp centre(2:2)-VAR.radius_fp centre(1:1)-fix_d+VAR.radius_fp centre(2:2)+VAR.radius_fp];
                    fix_right = [centre(1:1)+fix_d-VAR.radius_fp centre(2:2)-VAR.radius_fp centre(1:1)+fix_d+VAR.radius_fp centre(2:2)+VAR.radius_fp];
                    fix_below = [centre(1:1)-VAR.radius_fp centre(2:2)-fix_d-VAR.radius_fp centre(1:1)+VAR.radius_fp centre(2:2)-fix_d+VAR.radius_fp];
                    fix_up = [centre(1:1)-VAR.radius_fp centre(2:2)+fix_d-VAR.radius_fp centre(1:1)+VAR.radius_fp centre(2:2)+fix_d+VAR.radius_fp];
                    VAR.potential_loc_red = [fix_left; fix_right; fix_up; fix_below];

                    fix_d = fix_d/sqrt(2); % distance of a fixation spot from the centre (right)
                    fix_upleft = [centre(1:1)-VAR.radius_fp-fix_d centre(2:2)-VAR.radius_fp+fix_d centre(1:1)+VAR.radius_fp-fix_d centre(2:2)+VAR.radius_fp+fix_d];
                    fix_upright = [centre(1:1)-VAR.radius_fp+fix_d centre(2:2)-VAR.radius_fp+fix_d centre(1:1)+VAR.radius_fp+fix_d centre(2:2)+VAR.radius_fp+fix_d];
                    fix_belowleft = [centre(1:1)-VAR.radius_fp-fix_d centre(2:2)-VAR.radius_fp-fix_d centre(1:1)+VAR.radius_fp-fix_d centre(2:2)+VAR.radius_fp-fix_d];
                    fix_belowright = [centre(1:1)-VAR.radius_fp+fix_d centre(2:2)-VAR.radius_fp-fix_d centre(1:1)+VAR.radius_fp+fix_d centre(2:2)+VAR.radius_fp-fix_d];
                    VAR.potential_loc_blue = [fix_upleft; fix_belowright; fix_upright; fix_belowleft];
                end
                
                %% from px to deg
                % px from centre
                VAR.potential_loc_red_x = VAR.potential_loc_red_x - SETTINGS.screenSize(3)/2; 
                VAR.potential_loc_red_y = VAR.potential_loc_red_y - SETTINGS.screenSize(4)/2;
                VAR.potential_loc_blue_x = VAR.potential_loc_blue_x - SETTINGS.screenSize(3)/2;
                VAR.potential_loc_blue_y = VAR.potential_loc_blue_y - SETTINGS.screenSize(4)/2;
                % cm from centre
                width_cmperpx = task.screen_width/SETTINGS.screenSize(3); % cm/px of the screen
                VAR.potential_loc_red_x = VAR.potential_loc_red_x * width_cmperpx; 
                VAR.potential_loc_red_y = VAR.potential_loc_red_y * width_cmperpx;
                VAR.potential_loc_blue_x = VAR.potential_loc_blue_x * width_cmperpx;
                VAR.potential_loc_blue_y = VAR.potential_loc_blue_y * width_cmperpx;
                % cm to deg
%                 VAR.potential_loc_red_x = atand(VAR.potential_loc_red_x/(task.vd)); % deg
%                 VAR.potential_loc_red_y = atand(VAR.potential_loc_red_y/(task.vd));
%                 VAR.potential_loc_blue_x = atand(VAR.potential_loc_blue_x/(task.vd));
%                 VAR.potential_loc_blue_y = atand(VAR.potential_loc_blue_y/(task.vd));
                VAR.potential_loc_red_x = 2*atand(VAR.potential_loc_red_x/(2*task.vd)); % deg
                VAR.potential_loc_red_y = 2*atand(VAR.potential_loc_red_y/(2*task.vd));
                VAR.potential_loc_blue_x = 2*atand(VAR.potential_loc_blue_x/(2*task.vd));
                VAR.potential_loc_blue_y = 2*atand(VAR.potential_loc_blue_y/(2*task.vd));
                
                %% All fields are used to construct unique combinations
                if FP_loc == 1 || FP_loc == 2
                    All.fixation_locations              = 1:4;
                    pool_of_x_red = [VAR.potential_loc_red_x]; 
                    pool_of_y_red = [VAR.potential_loc_red_y];
                    pool_of_x_blue = [VAR.potential_loc_blue_x];
                    pool_of_y_blue = [VAR.potential_loc_blue_y];
                else
                    All.fixation_locations              = 1:4;
                    pool_of_x = VAR.potential_loc_x;
                    pool_of_y = VAR.potential_loc_y;
                end
                All.fixation_color                  = 1:2;

%                 pool_of_x = [-1.2517 -1.2517 1.2517 1.2517];
%                 pool_of_y = [-1.8775 1.8775 1.8775 1.8775];
                
                % fixation point color
                %pool_of_color = [128 0 0; 0 0 128]; 
%                 pool_of_color = [32 0 0; 0 0 54]; % red;blue
%                 tmp = zeros(29, 3);
%                 tmp(:, 1) = 10:5:150; %[100 0 0; 100 0 0]; %only red
%                 pool_of_color = tmp;
%                 pool_of_color = [255 0 0; 0 0 255];
                pool_of_color = [50 0 0; 0 0 100]; % [red; blue] % 69% of minimum intensity
%                 pool_of_color = [40 0 0; 0 0 10];
                
                
        end
        
        % don't change, for randomization, make it a script
        all_fieldnames=fieldnames(All);
        N_total_conditions       =1;
        sequence_cell            ={};
        for FN=1:numel(all_fieldnames)
            N_total_conditions=N_total_conditions*numel(All.(all_fieldnames{FN}));
            sequence_cell=[sequence_cell, {All.(all_fieldnames{FN})}];
        end
        
        sequence_matrix_exp_temp          = repmat(CombVec(sequence_cell{:}),1,N_repetitions);
        
        sequence_matrix_exp{n_exp}          = sequence_matrix_exp_temp;
        ordered_sequence_indexes_exp{n_exp} = (1:N_total_conditions*N_repetitions) + si_counter;
        si_counter                          = numel(ordered_sequence_indexes_exp{n_exp}) +si_counter;
        
    end % for each experiment
    
    
    sequence_matrix          = [sequence_matrix_exp{:}];
    
    
    ordered_sequence_indexes = 1:(numel([ordered_sequence_indexes_exp{:}]));
end


%% Shuffling conditions, don't change, make it a script
if ~exist('dyn','var') || (dyn.trialNumber == 1 && shuffle_conditions==0)
    sequence_indexes = ordered_sequence_indexes;
    shuffled_sequence_indexes_exp=ordered_sequence_indexes_exp;
elseif dyn.trialNumber == 1 && (shuffle_conditions==1)
    sequence_indexes = Shuffle(ordered_sequence_indexes);
    shuffled_sequence_indexes_exp=ordered_sequence_indexes_exp;
elseif dyn.trialNumber == 1 && (shuffle_conditions==2) %% shuffling within experiment (for blocked designs!)
    
    shuffled_sequence_indexes_exp = cellfun(@Shuffle,ordered_sequence_indexes_exp,'UniformOutput',false);
    sequence_indexes = [shuffled_sequence_indexes_exp{:}];
end

% don't change, for randomization, make it a script
if exist('dyn','var') && dyn.trialNumber > 1,
    if force_conditions==1
        if sum([trial.success])==length(sequence_indexes),
            dyn.state = STATE.CLOSE; return
        else
            custom_trial_condition = sequence_indexes(sum([trial.success])+1);
        end
        
    elseif force_conditions==2 % semi-forced: if trial is unsuccessful, the condition is put back into the pool
        if trial(end-1).success==1
            sequence_indexes=sequence_indexes(2:end);
        else
            sequence_indexes=Shuffle(sequence_indexes);
        end
        if numel(sequence_indexes)==0
            dyn.state = STATE.CLOSE; return
        else
            custom_trial_condition = sequence_indexes(1);
        end
    elseif force_conditions==3  %% semi-forced, but keeping blocks
        if trial(end-1).success==1
            if isempty(shuffled_sequence_indexes_exp{1}) && numel(shuffled_sequence_indexes_exp)>1
                shuffled_sequence_indexes_exp=shuffled_sequence_indexes_exp(2:end);
            end
            shuffled_sequence_indexes_exp{1}(1)=[];
        else
            shuffled_sequence_indexes_exp = cellfun(@Shuffle,shuffled_sequence_indexes_exp,'UniformOutput',false);
        end
        sequence_indexes = [shuffled_sequence_indexes_exp{:}];
        if numel(sequence_indexes)==0
            dyn.state = STATE.CLOSE; return
        else
            custom_trial_condition = sequence_indexes(1);
        end
    else
        if numel(trial)-1==length(sequence_indexes),
            dyn.state = STATE.CLOSE; return
        else
            custom_trial_condition = sequence_indexes(numel(trial));
        end
    end
else
    custom_trial_condition = sequence_indexes(1);
end

% This is for sending it to TDT
for field_index=1:numel(all_fieldnames)
    Current_con.(all_fieldnames{field_index})=sequence_matrix(field_index,custom_trial_condition);
    dyn.trial_classifier(field_index) = abs(round(Current_con.(all_fieldnames{field_index})));
end



%% CHOICE\INSTRUCTED
task.choice                 = 0;

%% TYPE
task.type                   = 1; % c.f. function new_state = state_transition(task,success,current_state) in monkeypsych

%% EFFECTOR
task.effector               = 0;

%% REACH hand
task.reach_hand             = 1;


%% TIMING

task.rest_sensors_ini_time              = 0.5; % s, time to hold sensor(s) in initialize_trial before trial starts

task.timing.wait_for_reward             = 0; %0.2;
task.timing.ITI_success                 = 1;
task.timing.ITI_success_var             = 0;
task.timing.ITI_fail                    = 1;
task.timing.ITI_fail_var                = 0;
task.timing.grace_time_eye              = 0;
task.timing.grace_time_hand             = 0;
task.timing.fix_time_to_acquire_hnd     = 0; %1
task.timing.tar_time_to_acquire_hnd     = 0; % 1.5
task.timing.tar_inv_time_to_acquire_hnd = 0;
task.timing.fix_time_to_acquire_eye     = 1.5; % from acquiring the eye to the hold state
task.timing.tar_time_to_acquire_eye     = 0;%1.5;
task.timing.tar_inv_time_to_acquire_eye = 0;
task.timing.fix_time_hold               = 1.5; % Duration the subject has to fixate
task.timing.fix_time_hold_var           = 0; % Variance of duration the subject has to fixate
task.timing.cue_time_hold               = 0;%0.5;
task.timing.cue_time_hold_var           = 0;
task.timing.mem_time_hold               = 0;
task.timing.mem_time_hold_var           = 0;
task.timing.del_time_hold               = 0;
task.timing.del_time_hold_var           = 0;
task.timing.tar_inv_time_hold           = 0;
task.timing.tar_inv_time_hold_var       = 0;
task.timing.tar_time_hold               = 0;%0.5;
task.timing.tar_time_hold_var           = 0;



%% RADIUS & SIZES

task.eye.fix.size       = fix_size/2; % radius
task.eye.fix.radius     = fix_rad;
task.eye.tar(1).size    = 0.2;
task.eye.tar(1).radius  = 0.2;

task.hnd.fix.radius     = 8;
task.hnd.fix.size       = 6;
task.hnd.tar(1).size    = 4;
task.hnd.tar(1).radius  = 7;

task.eye.tar(2).size    = task.eye.tar(1).size;
task.hnd.tar(2).size    = task.hnd.tar(1).size ; % deg
task.eye.tar(2).radius  = task.eye.tar(1).radius;
task.hnd.tar(2).radius  = task.hnd.tar(1).radius; % deg


%% POSITIONS

% if SETTINGS.take_angles_con
%     current_angle=pool_of_angles(Current_con.angle_cases); %
%     tar_dis_x   = Current_con.excentricities*cos(current_angle*2*pi/360);
%     tar_dis_y   = Current_con.excentricities*sin(current_angle*2*pi/360);
% else
%     tar_dis_x   = Current_con.exact_excentricity_con_x;
%     tar_dis_y   = Current_con.exact_excentricity_con_y;
% end

% define binocular fixation spots so that they cannot overlap at one location
fix_loc_label = Current_con.fixation_locations;
fix_loc_label(2,:) = randi([1 4],1,1);
VAR.num_trial = 1;
for i=1:VAR.num_trial
    if fix_loc_label(1,i) == 1; while fix_loc_label(2,i) == 1 || fix_loc_label(2,i) == 4; fix_loc_label(2,i) = randi([1 4],1,1); end; end
    if fix_loc_label(1,i) == 2; while fix_loc_label(2,i) == 2 || fix_loc_label(2,i) == 3; fix_loc_label(2,i) = randi([1 4],1,1); end; end
    if fix_loc_label(1,i) == 3; while fix_loc_label(2,i) == 3 || fix_loc_label(2,i) == 1; fix_loc_label(2,i) = randi([1 4],1,1); end; end
    if fix_loc_label(1,i) == 4; while fix_loc_label(2,i) == 4 || fix_loc_label(2,i) == 2; fix_loc_label(2,i) = randi([1 4],1,1); end; end
end

task.eye.fix.x.red = pool_of_x_red(fix_loc_label(1,1));
task.eye.fix.y.red = pool_of_y_red(fix_loc_label(1,1));
task.hnd.fix.x.red = pool_of_x_red(fix_loc_label(1,1));
task.hnd.fix.y.red = pool_of_y_red(fix_loc_label(1,1));
task.eye.fix.x.blue = pool_of_x_blue(fix_loc_label(2,1));
task.eye.fix.y.blue = pool_of_y_blue(fix_loc_label(2,1))+0.1;
task.hnd.fix.x.blue = pool_of_x_blue(fix_loc_label(2,1));
task.hnd.fix.y.blue = pool_of_y_blue(fix_loc_label(2,1));
    
% if Current_con.fixation_color == 1
%     task.eye.fix.x = pool_of_x_red(Current_con.fixation_locations);
%     task.eye.fix.y = pool_of_y_red(Current_con.fixation_locations);
%     task.hnd.fix.x = pool_of_x_red(Current_con.fixation_locations);
%     task.hnd.fix.y = pool_of_y_red(Current_con.fixation_locations);
% elseif Current_con.fixation_color == 2
%     task.eye.fix.x = pool_of_x_blue(Current_con.fixation_locations);
%     task.eye.fix.y = pool_of_y_blue(Current_con.fixation_locations);
%     task.hnd.fix.x = pool_of_x_blue(Current_con.fixation_locations);
%     task.hnd.fix.y = pool_of_y_blue(Current_con.fixation_locations);
% end



task.eye.tar(1).x = 0;
task.eye.tar(1).y = 0;
task.eye.tar(2).x = 0;
task.eye.tar(2).y = 0;

task.hnd.tar(1).x = 0;
task.hnd.tar(1).y = 0;
task.hnd.tar(2).x = 0;
task.hnd.tar(2).y = 0;

% task.eye.cue                                        = task.eye.tar;
% task.hnd.cue                                        = task.hnd.tar;


%% COLORS

%fixation
% task.eye.fix.color_dim          = [128 0 0]; %
% task.eye.fix.color_bright       = [128 0 0];

% task.eye.fix.color_dim          = pool_of_color(Current_con.fixation_color,:); 
% task.eye.fix.color_bright       = pool_of_color(Current_con.fixation_color,:); 

task.eye.fix.color_dim          = pool_of_color;
task.eye.fix.color_bright       = pool_of_color;
% task.eye.fix.color_dim_red          = pool_of_color(1,:); 
% task.eye.fix.color_dim_blue          = pool_of_color(2,:); 
% task.eye.fix.color_bright_red       = pool_of_color(1,:); 
% task.eye.fix.color_bright_blue       = pool_of_color(2,:);  

% task.hnd_left.color_dim_fix         = [39 109 216];%[39 109 216] %grey 60 60 60
% task.hnd_left.color_bright_fix      = [119 230 253];%[119 230 253] % grey 110 110 110
% task.hnd_right.color_dim_fix        = [0 128 0];
% task.hnd_right.color_bright_fix     = [0 255 0];%[0 255 0]


% task.eye.tar(1).color_dim       = [128 0 0];  % 2.5 or 3
% task.eye.tar(1).color_bright    = [255 0 0];
% task.eye.tar(2).color_dim       = [128 0 0]; %  % 2.5 or 3
% task.eye.tar(2).color_bright    = [255 0 0];
% 
% task.hnd_right.color_dim        = [0 128 0]; %[0 128 0]
% task.hnd_right.color_bright     = [0 255 0]; %[0 255 0]
% task.hnd_right.color_cue_dim    = [0 128 0];
% task.hnd_right.color_cue_bright = [0 255 0];
% task.hnd_left.color_dim         = [39 109 216]; % [39 109 216]
% task.hnd_left.color_bright      = [119 230 253]; % [119 230 253]
% task.hnd_left.color_cue_dim     = [39 109 216];
% task.hnd_left.color_cue_bright  = [119 230 253];
% task.hnd_stay.color_dim         = [39 109 216];
% task.hnd_stay.color_bright      = [119 230 253];




