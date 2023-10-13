% Ckeck the balance of colours
% Alt: red
% Ctrl: blue
function human_colour_check()

clear all

RedImageContrast = 0.9; %[0 1]
CyanImageContrast = 1; % [0 1]

% image_binoriv = imread(['Y:/Projects/BinoRiv/JanisHesse/Binocular_Rivalry_Code_Ryo/In2PB_stimuli/without_fp/Face_' num2str(RedImageContrast) '_Object_' num2str(CyanImageContrast) '.tif']);
image_binoriv = imread(['BinoRiv_stimuli/without_fp/Face_' num2str(RedImageContrast) '_Object_' num2str(CyanImageContrast) '.tif']);

% Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 1);
AssertOpenGL;
% screenNumber = max(Screen('Screens'));
screenNumber = max(Screen('Screens')-1);
[w, rect] = Screen('OpenWindow', screenNumber, [186 186 186]);
HideCursor;

% Present stimulus
stimulus = Screen('MakeTexture', w, image_binoriv);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, [1 1 1 1]);
Screen('DrawTexture', w, stimulus)
Screen('FillOval', w, [0 0 0], [rect(3)/2-5 rect(4)/2-5 rect(3)/2+5 rect(4)/2+5]);
Screen('Flip', w);

% Record button pressing
repo_red = 0;
repo_blue = 0;
while true
    
    [~, ~, keyCode] = KbCheck;
    if any(find(keyCode)==18) % Alt
        repo_red = repo_red + 1;
    end
    if any(find(keyCode)==17) % Ctrl
        repo_blue = repo_blue + 1;
    end 
    
    if any(find(keyCode)==27) % Esc
        break;
    end
end

ShowCursor;
Screen('Close',w);

% Calculate the ratio
parameter = repo_red + repo_blue;
ratio_red = repo_red*100/parameter;
ratio_blue = repo_blue*100/parameter;
fprintf(' Red: %.1f %%, Blue: %.1f %% \n', ratio_red, ratio_blue);