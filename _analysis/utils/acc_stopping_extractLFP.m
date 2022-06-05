function acc_stopping_extractLFP(dirs,dataFiles_beh,dataFiles_neural,behavior,varargin)


%% Decode varargin
varStrInd = find(cellfun(@ischar,varargin));

for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'filter'}; filter = varargin{varStrInd(iv)+1};
    end
end

%% Main script
for dataFileIdx = 1:length(dataFiles_neural)
    % We first report loop status:
    fprintf('Extracting: %s ... [%i of %i]  \n',dataFiles_neural{dataFileIdx},dataFileIdx,length(dataFiles_neural))
    
    % We then get the (neural) filename of the record of interest
    neuralFilename = dataFiles_neural{dataFileIdx};
    
    %... and find the corresponding behavior file index
    behFilename = data_findBehFile(neuralFilename);
    behaviorIdx = find(strcmp(dataFiles_beh,behFilename(1:end-4)));
    
    % Load in data-file
    import_data = struct(); import_data = load_lfpFile(dirs,neuralFilename);
    
    % Filter data as necessary
    LFP = []; LFP = lfp_filterSignals(import_data,filter);

    % Convolve spike times to get continous trace
    lfp_aligned = [];
    lfp_aligned = lfp_alignTrials(behavior(behaviorIdx).trialEventTimes(:,[2,3,5,6,7,9]),...
        LFP, [-1000 2000]);


    
end