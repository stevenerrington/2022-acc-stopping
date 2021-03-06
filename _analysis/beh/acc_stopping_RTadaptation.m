% Analysis: post-stopping slowing
% 2022-06-05 | S P Errington

% - For each behavioral session
for session_i = 1:length(dataFiles_beh)
   
% Setup workspace and data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% - clear loop variables
clear RTarray trialHistory deltaRT

% - get session information
beh_idx = find(strcmp(dajo_datamap_curated.sessionBeh,dataFiles_beh(session_i)),1);
sessionBeh = dajo_datamap_curated.sessionBeh(beh_idx);
monkey = dajo_datamap_curated.monkey(beh_idx);

% - get session response latencies
RTarray = behavior(session_i).trialEventTimes.saccade - ...
    behavior(session_i).trialEventTimes.target;

% - find trials around the canceled trial with a response time
%    - note here, I've removed the first 10 trials, to allow the monkey to
%    settle and reduce variability
trialHistory.trl_after_c = behavior(session_i).ttx_history.NS_after_C...
    (behavior(session_i).ttx_history.NS_after_C > 10);
trialHistory.trl_before_c = findprevRTtrl(behavior(session_i));

% Analysis approaches %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Approach 1: get delta RT around the canceled trial
% - look at the change in RT in the last valid trial before the canceled
% trial, and the next valid trial with and RT. 
deltaRT = RTarray(trialHistory.trl_before_c) - RTarray(trialHistory.trl_after_c);
% - get the median change in RT. Negative values represent an RT slowing.
median_deltaRT = median(deltaRT);
% - determine whether this change is significant (Wilcoxon Sign)
[p_deltaRT, h_deltaRT] = signrank(deltaRT);

% Approach 2: compare differences between no-stop RT after canceled & no-stop trials
% Find the median RT on no-stop trials directly after canceled trials
median_postC = median(RTarray(behavior(session_i).ttx_history.NS_after_C));
% Find the median RT on no-stop trials directly after no-stop trials
median_postNS = median(RTarray(behavior(session_i).ttx_history.NS_after_NS));

% Output data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stopRTslowing(session_i,:) = ... % Make a new row for this session
    table(sessionBeh, monkey,... % Include the key admin
    median_deltaRT, p_deltaRT, h_deltaRT,... % Info from approach 1
    median_postC, median_postNS); % Info from approach 2

end


