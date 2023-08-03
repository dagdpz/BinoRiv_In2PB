% Author: Ryo Segawa (whizznihil.kid@gmail.com)
function binoriv_monkeyTraining_analysis(file_location)

file_location = 'Y:\Data\Bacchus\20230706\Bac2023-07-06_01.mat';
data = load(file_location);


for trl = 1:numel(data.trial)
    if data.trial(trl).stimulus==2 || data.trial(trl).stimulus==3
        if any(find(data.trial(trl).states==34))
            num_trial = num_trial + 1;
            for state_label = 1:numel(data.trial(trl).states)
                if data.trial(trl).states(state_label) == 34
                    if exist('data.trial(trl).states_onset(state_label+1)','var')
                        if (data.trial(trl).states_onset(state_label+1) - data.trial(trl).states_onset(state_label)) > 2
                            num_success_trial = num_success_trial + 1;
                            break
                        end
                    else
                        if (data.trial(trl+1).states_onset(1) - data.trial(trl).states_onset(state_label)) > 2 && data.trial(trl).stimulus~=5
                            num_success_trial = num_success_trial + 1;
                            break
                        end
                    end
                end
            end
        end
    end
end