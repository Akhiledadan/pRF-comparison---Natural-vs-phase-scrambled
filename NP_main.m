
%%
% Folders for defining mrSESSION
% NP_init_directory_structure;

% mrInit;
% mrVista;
% Check spinozacentre.nl/dlwiki >> pRF Modelling steps for making a mrVista
% session. Once mrVista session is created, following steps can be run.

%% Run the model with hrf fit for both the conditions together

% open mrVista
hvol = initHiddenGray;
hvol = viewSet(hvol,'curdt','pRF_all');
% Load the stimulus parameters
figpoint = rmEditStimParams(hvol);
%params = rmDefineParameters(hvol);
%makeStimFromScan(params);
uiwait(figpoint);

fprintf('Starting the pRF fitting with hrf');

% Run the pRF model for both the conditions together (also run the hrf fit)
hvol = rmMain(hvol,[],5);


%% Refined sigma fit for natural condition

% Run pRF model fit for sigma alone for natural and phase scrambled separately 
% Set the current dataset to natural 

% Select the original model
[model_fname, model_fpath] = uigetfile('*.mat','Select model');
model_all = (fullfile(model_fpath, model_fname));

if ~exist('hvol','var')
    hvol = initHiddenGray;
end
% for Natural 
hvol = viewSet(hvol,'curdt','pRF_nat');
% Load the pRF model 
hvol = rmSelect(hvol,1,model_all);
hrf = cell(1,2);
hrf{1} = hvol.rm.retinotopyParams.stim.hrfType;
hrf{2} = hvol.rm.retinotopyParams.stim.hrfParams(2); 


% Run the model fit for only sigma alone
hvol = rmMain(hvol,[],7,'matFileName','nat_refined_','hrf',hrf,'refine','sigma');


%%  Refined sigma fit for scrambled condition

if ~exist('hvol','var')
    hvol = initHiddenGray;
end
% for phase scrambled 
hvol = viewSet(hvol,'curdt','pRF_scram');

% Load the pRF model 
hvol = rmSelect(hvol,1,model_all);
hrf = cell(1,2);
hrf{1} = hvol.rm.retinotopyParams.stim.hrfType;
hrf{2} = hvol.rm.retinotopyParams.stim.hrfParams(2); 

% Run the model fit for only sigma alone
hvol = rmMain(hvol,[],7,'matFileName','scram_refined_','hrf',hrf,'refine','sigma');


%% Analysis for all subject

NP_runAll;

% use combineMultipleRois to combine different rois

%% Stats -  repeated measures ANOVA
% parameters
paramsToCompare      = 'central';
paramsToCompare_type = 'absolute';
rois = 'V123';
        
fprintf('parameter: %s \t type: %s \t rois: %s',paramsToCompare,paramsToCompare_type,rois);

NP_stats(paramsToCompare,paramsToCompare_type,rois); 

%%