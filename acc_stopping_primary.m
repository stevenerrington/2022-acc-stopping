
%% Setup workspace
clear all; clc; % Clear workspace
addpath('C:\Users\Steven\Desktop\Projects\2022-dajo-toolbox'); % DaJo-toolbox
addpath('C:\Users\Steven\Desktop\Projects\2022-acc-stopping\_toolbox\clustering_schall') % Clustering toolbox
dirs = data_setDir();
params.filter.band = [3 8]; params.filter.label = 'theta';

%% Curate data
dajo_datamap = load_datamap(dirs);

dajo_datamap_curated = data_sessionCurate...
    (dajo_datamap,...
    'area', {'ACC'}, 'monkey', {'dar','jou'}, 'signal', {'SPK'}, 'spacing', [50, 100, 150]);

dataFiles_beh = unique(dajo_datamap_curated.sessionBeh);
dataFiles_neural = unique(dajo_datamap_curated.dataFilename);


%% Extract data
% Behavior -------------------------------------------
behavior = acc_stopping_extractBeh(dirs,dataFiles_beh);
% Neural - spikes  -----------------------------------
signal_average_spk = acc_stopping_extractSDF(dirs,dataFiles_beh,dataFiles_neural,behavior);
% Neural - lfp     -----------------------------------
signal_average_lfp = acc_stopping_extractLFP(dirs,dataFiles_beh,dataFiles_neural,behavior,'filter',params.filter);
        % 2022-05-20: This code takes a while and needs to be restructured.

%% Post-process neural signals
signal_collapse = neural_collapseSignalSession(signal_average_spk,...
    'events',{'target','stopSignal_artifical','tone'},...
    'conditions',{'C','GO'},...
    'conditions_map',[1 2]);

%% Clustering
acc_stopping_ssrtClustering
