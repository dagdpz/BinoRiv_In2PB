function ma1_page_thru_trials_binoriv_task(runpath, list_successful_only, plot_trials, plot_2D, plot_summary, detect_saccades, detect_saccades_custom_settings)

% examples:
% ma1_page_thru_trials_simple('Y:\Data\Linus\20220322\Lin2022-03-22_05.mat',0,0,0,1); % plot fixation hold summary only
% ma1_page_thru_trials_simple('Y:\Data\Linus\20220322\Lin2022-03-22_05.mat',-1,0,1,0); % plot 2D failed trials

close all

if nargin < 2,
	list_successful_only = 0; % if -1, list failed only
end

if nargin < 3,
	plot_trials = 0;
end

if nargin < 4,
	plot_2D = 0;
end

if nargin < 5,
	plot_summary = 0;
end

if nargin < 6,
	detect_saccades = 0;
end

if nargin < 7,
	detect_saccades_custom_settings = '';
end

load(runpath);
disp(runpath);


if plot_trials,
	hf = figure('Name','Plot trial','CurrentChar',' ','Position',[600 500 600 500]);
end

if plot_summary || plot_2D,
    axes = [-10 10];
end

if plot_2D
    hf2D = figure('Name','Plot 2D','CurrentChar',' ','Position',[1200 500 500 500]);
end

for k = 1:length(trial),
    
    
    if 1 % align time axis to trial start
        trial(k).states_onset = trial(k).states_onset - trial(k).tSample_from_time_start(1);
        trial(k).tSample_from_time_start = trial(k).tSample_from_time_start - trial(k).tSample_from_time_start(1);
    end
    
	
    if plot_summary || plot_2D,
        
%         idx_before_fix_hold = find(trial(k).state < 3);
%         idx_during_fix_hold = find(trial(k).state == 3);
%         idx_after_fix_hold = find(trial(k).state > 3);
        idx_before_fix_hold = find(trial(k).state < 33);
        idx_during_fix_hold = find(trial(k).state == 34);
        idx_after_fix_hold = find(trial(k).state > 50);
        
        
       if ~isempty(idx_during_fix_hold),
            last_fix_hold(k).x = trial(k).x_eye(idx_during_fix_hold(end));
            last_fix_hold(k).y = trial(k).y_eye(idx_during_fix_hold(end));
            fix_hold_dur(k) = trial(k).tSample_from_time_start(idx_during_fix_hold(end)) - trial(k).tSample_from_time_start(idx_during_fix_hold(1)-1);
       else
           last_fix_hold(k).x = NaN;
           last_fix_hold(k).y = NaN;
           fix_hold_dur(k) = 0;
           
       end
        
        
%         trial_fix_window(k, :) = [trial(k).eye.fix.pos];
                
        trial_fix_window(k, :) = [trial(k).eye.fix.pos_red];
        trial_fix_window(k+1, :) = [trial(k).eye.fix.pos_blue];
        
    end
        
   
        
 	if (list_successful_only == 1 && trial(k).success) || (list_successful_only == -1 && ~trial(k).success) || list_successful_only==0 
 		
		
		if plot_trials,
			figure(hf);
			subplot(2,1,1); hold on;
			title(sprintf('Trial %d [%d]',k,trial(k).success));
			
			plot(trial(k).tSample_from_time_start,trial(k).state,'k');
			plot(trial(k).tSample_from_time_start,trial(k).x_eye,'g');
			plot(trial(k).tSample_from_time_start,trial(k).y_eye,'m');
			ig_add_multiple_vertical_lines(trial(k).states_onset,'Color','k');
			ylabel('Eye position, states');
			
			
			if detect_saccades,
				if ~isempty(detect_saccades_custom_settings),
					em_saccade_blink_detection(trial(k).tSample_from_time_start,trial(k).x_eye,trial(k).y_eye,...
					detect_saccades_custom_settings);				
				else
					em_saccade_blink_detection(trial(k).tSample_from_time_start,trial(k).x_eye,trial(k).y_eye,...
					'Downsample2Real',0,'Plot',true,'OpenFigure',true);
				end
			end
			
			
			
			figure(hf);
			subplot(2,1,2)
			plot(trial(k).tSample_from_time_start,[NaN; diff(trial(k).tSample_from_time_start)],'k.');
			ylabel('Sampling interval');
			
		end
		
		
		if plot_trials,
			figure(hf);
			ig_set_all_axes('Xlim',[trial(k).tSample_from_time_start(1) trial(k).tSample_from_time_start(end)]);

			
            
            if ~plot_2D
                drawnow; pause;
                if get(gcf,'CurrentChar')=='q',
                    % close;
                    break;
                end
                clf(hf);
            end
        end
        
        if plot_2D,
            figure(hf2D);
            
            w = nsidedpoly(100, 'Center', [trial(k).eye.fix.x trial(k).eye.fix.y], 'Radius', trial(k).eye.fix.radius); plot(w, 'FaceColor', 'r'); hold on;

            plot(trial(k).x_eye,trial(k).y_eye,'k-','LineWidth',0.1);
            plot(trial(k).x_eye(idx_before_fix_hold),trial(k).y_eye(idx_before_fix_hold),'b-','LineWidth',0.2);
            plot(trial(k).x_eye(idx_during_fix_hold),trial(k).y_eye(idx_during_fix_hold),'g-','LineWidth',0.2);
            plot(trial(k).x_eye(idx_after_fix_hold),trial(k).y_eye(idx_after_fix_hold),'r-','LineWidth',0.2);
            plot(trial(k).x_eye(idx_before_fix_hold),trial(k).y_eye(idx_before_fix_hold),'b.','MarkerSize',1);
            plot(trial(k).x_eye(idx_during_fix_hold),trial(k).y_eye(idx_during_fix_hold),'g.','MarkerSize',1);
            if ~isempty(idx_during_fix_hold),
                plot(trial(k).x_eye(idx_during_fix_hold(end)),trial(k).y_eye(idx_during_fix_hold(end)),'k.','MarkerSize',15); % plot last sample of fixation hold
            end
            plot(trial(k).x_eye(idx_after_fix_hold),trial(k).y_eye(idx_after_fix_hold),'r.','MarkerSize',1);
            
            
            axis equal
            set(gca,'Xlim',axes,'Ylim',axes);
            title(sprintf('Trial %d [%d]',k,trial(k).success));
            drawnow; pause;
            
            if get(gcf,'CurrentChar')=='q',
				% close;
				break;
			end
			clf(hf2D);
            
            if plot_trials,
                clf(hf);
            end
        end
        
        
        
        
	end
	
end % for each trial


if plot_summary
    
    idx_succ		= find([trial.success]==1);
    idx_fail		= find([trial.success]==0);
    
    figure('Position',[300 300 600 600]);
    
    uWindows = unique(trial_fix_window, 'rows');
    
    for k=1:size(uWindows,1),     
           w = nsidedpoly(100, 'Center', [uWindows(k,1) uWindows(k,2)], 'Radius', uWindows(k,4)); plot(w, 'FaceColor', [0.9 0.9 0.9]); hold on;
    end
    plot([last_fix_hold(idx_succ).x],[last_fix_hold(idx_succ).y],'g.','MarkerSize',5); % plot last sample of fixation hold
    plot([last_fix_hold(idx_fail).x],[last_fix_hold(idx_fail).y],'r.','MarkerSize',5); % plot last sample of fixation hold
    
    axis equal
    set(gca,'Xlim',axes,'Ylim',axes);
    title(sprintf('%s %d succ. %d failed trials',runpath,length(idx_succ),length(idx_fail)),'Interpreter','none');
    
    
    figure('Position',[300 300 600 600]);
    bins = [0 0.01:0.1:(task.timing.fix_time_hold + task.timing.fix_time_hold_var)];
    histSuccDur = hist(fix_hold_dur(idx_succ),bins);
    histFailDur = hist(fix_hold_dur(idx_fail),bins);
    
    plot(bins,ig_hist2per(histSuccDur),'g','LineWidth',2); hold on;
    plot(bins,ig_hist2per(histFailDur),'r','LineWidth',2);
    xlabel('Fixation duration (s)');
    ylabel('% trials');
    title(sprintf('%s %d succ. %d failed trials',runpath,length(idx_succ),length(idx_fail)),'Interpreter','none');
    legend('correct','failed');
end

function hp = ig_hist2per(hn)
%IG_HIST2PER		- convert histogram count to percentages
%--------------------------------------------------------------------------------
% Input(s): 	hn - histogram values in counts
% Output(s):	hp - histogram values in % (assuming that sum(hn)=100%)
% Usage:	hp = ig_hist2per(hn)
%
% Last modified 18.11.03
% Copyright (c) 2003 Igor Kagan					 
% kigor@tx.technion.ac.il
% http://igoresha.virtualave.net
%--------------------------------------------------------------------------------

hp = hn/sum(hn)*100;

