# monkeypsych_IN2PB  
### Check individual contrast balance
    - human_colour_check  
### Stimuli making  
    - make_binocular_rivalry_define_contrasts  
        - Define parameters before running the files 'make_binocular_rivalry_stimuli*'  
    - make_binocular_rivalry_stimuli (for humans)  
    - make_binocular_rivalry_stimuli_withoutFP (for humans)  
    - make_binocular_rivalry_stimuli_monkey_training
    - make_binocular_rivalry_stimuli_monkey_main  
### Condition file with specifying 'human'  
    - conditions\human\combined_condition_file_human  (calibration)
    - conditions\human\combined_condition_file_continuous_binoriv  (main task)  
        - Choose the task type VAR.binoriv_taskType [1 4]  
### Main  
    - monkeypsych_dev_binoriv  
### Chopping raw data files  
    - chopping_trial_binoriv (for data before 2023-08-07_15)  
    - chopping_trial_binoriv_humanExpIntegrated (for data from 2023-08-07_15)  