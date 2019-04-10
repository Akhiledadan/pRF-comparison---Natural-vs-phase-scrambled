

% Folders for defining mrSESSION
NP_init_directory_structure;

mrInit;
mrVista;
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

% VOLUME{1} = rmMain(VOLUME{1},[],5);
% hrf = cell(1,2);
% hrf{1} = VOLUME{1}.rm.retinotopyParams.stim.hrfType;
% hrf{2} = VOLUME{1}.rm.retinotopyParams.stim.hrfParams(2); 
% VOLUME{1} = rmMain(VOLUME{1},[],7,'matFileName','nat_refined_','hrf',hrf,'refine','sigma');
% 
% % Run the model fit for only sigma alone
% VOLUME{1} = rmMain(VOLUME{1},[],7,'matFileName','scram_refined_','hrf',hrf,'refine','sigma');

%% Refined sigma fit for natural condition

% Run pRF model fit for sigma alone for natural and phase scrambled separately 
% Set the current dataset to natural 


if ~exist('hvol','var')
    hvol = initHiddenGray;
    
    % for Natural
    hvol = viewSet(hvol,'curdt','pRF_nat');
    
    % Load the stimulus parameters
    figpoint = rmEditStimParams(hvol);
    uiwait(figpoint);
    
else
    % for Natural
    hvol = viewSet(hvol,'curdt','pRF_nat');
end

% Select the original model
[model_fname, model_fpath] = uigetfile('*.mat','Select model');
model_all = (fullfile(model_fpath, model_fname));


% Load the pRF model 
hvol = rmSelect(hvol,1,model_all);
hrf = cell(1,2);
hrf{1} = hvol.rm.retinotopyParams.stim.hrfType;
hrf{2} = hvol.rm.retinotopyParams.stim.hrfParams(2); 


% Run the model fit for only sigma alone
hvol = rmMain(hvol,[],7,'matFileName','nat_refined_','hrf',hrf,'refine','sigma');
%hvol = rmMain(hvol,[],7,'matFileName','nat_refined_','refine','sigma');

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


%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Difference of gaussians fit - for both conditions combined
% Refined sigma fit for difference of gaussians for naturala and phase
% scrambled separately
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Run Difference of gaussians model with hrf fit for both conditions put together

% open mrVista
hvol = initHiddenGray;
hvol = viewSet(hvol,'curdt','pRF_all');
%hvol = viewSet(hvol,'roi','V1.mat');

% Load the stimulus parameters
%figpoint = rmEditStimParams(hvol);
%uiwait(figpoint);

hvol = rmLoadParameters(hvol);hvol=refreshScreen(hvol);

fprintf('\n Starting the pRF fitting with hrf for One Gaussian and Difference of gaussians \n');

% Run the pRF model for both the conditions together (also run the hrf fit)
prfModels = {'difference of gaussians'};

outFileName = strcat('NP_',prfModels);
hvol = rmMain(hvol,[],5,'model',prfModels,'matFileName', outFileName);


%%  Refined sigma fit for difference of gaussians fit for natural condition

% Run pRF model fit for sigma alone for natural and phase scrambled separately 
% Set the current dataset to natural 

% Run the pRF model for both the conditions together (also run the hrf fit)
prfModels = {'difference of gaussians'};

if ~exist('hvol','var')
    hvol = initHiddenGray;
    
    % for Natural
    hvol = viewSet(hvol,'curdt','pRF_nat');
    %hvol = viewSet(hvol,'roi','V1.mat');
    % Load the stimulus parameters
    figpoint = rmEditStimParams(hvol);
    uiwait(figpoint);

else
    % for Natural
    hvol = viewSet(hvol,'curdt','pRF_nat');

end

% Select the original model
[model_fname, model_fpath] = uigetfile('*.mat','Select model');
model_all = (fullfile(model_fpath, model_fname));

% Load the pRF model 
hvol = rmSelect(hvol,1,model_all);

% Load hrf 
hrf = cell(1,2);
hrf{1} = hvol.rm.retinotopyParams.stim.hrfType;
hrf{2} = hvol.rm.retinotopyParams.stim.hrfParams(2); 


% Run the model fit for only sigma alone
hvol = rmMain(hvol,[],7,'matFileName','nat_refined_DoGs','hrf',hrf,'model',prfModels,'refine','sigma');


%%  Refined sigma fit for difference of gaussians fit for scrambled condition

if ~exist('hvol','var')
    hvol = initHiddenGray;
    
    % Load the stimulus parameters
    figpoint = rmEditStimParams(hvol);
    uiwait(figpoint);
    
    % for phase scrambled
    hvol = viewSet(hvol,'curdt','pRF_scram');

    %hvol = viewSet(hvol,'roi','V1.mat');
end

% for phase scrambled 
hvol = viewSet(hvol,'curdt','pRF_scram');


% Load the pRF model 
hvol = rmSelect(hvol,1,model_all);
hrf = cell(1,2);
hrf{1} = hvol.rm.retinotopyParams.stim.hrfType;
hrf{2} = hvol.rm.retinotopyParams.stim.hrfParams(2); 

% Run the model fit for only sigma alone
hvol = rmMain(hvol,[],7,'matFileName','scram_refined_DoGs','model',prfModels,'hrf',hrf,'refine','sigma');



%% Analysis for all subject
sub = {'1_LS','2_LR','3_DR','4_EV','5_JG','6_LA','S099'};
num_sub = length(sub);
main_dir = '/home/akhi/Documents/Project/Nat_PhScr/';

for idx_sub = 1:num_sub
   
    fprintf('Running analysis for sub %s',sub{idx_sub});
    
   sub_dir = strcat(main_dir,sub{idx_sub});
   cd(sub_dir);
   NP_Sigma_ecc(sub_dir,1,1);
   
   fprintf('\n DONE \n')
   
end