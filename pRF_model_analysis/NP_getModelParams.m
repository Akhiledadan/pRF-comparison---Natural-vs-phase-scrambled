function [Cond_model,ROI_params] = NP_getModelParams(opt,dirPth)
% NP_getModelParams - To load the model parameters into a table called
% Cond_model and ROI_params from every ROI 
% 
% inputs:  opt          - Options for the analysis parameters
%          dirPth       - Path to all the directories  
% outputs: Cond_model   - Table containing pRF parameters (eg: x,y,sigma,...)  
%          ROI_params   - Table containing pRF parameters split acc. to ROIs 
%

% Define the different conditions to be compared
conditions = opt.conditions;
num_cond = length(conditions);

rois = opt.rois;

% Load types of model to compare
model_file = cell(num_cond,1);
for cond_idx = 1:length(conditions)
    dirPth.model_path_ind = fullfile(dirPth.modelPth,conditions{cond_idx});
    model_fname =  dir(fullfile(dirPth.model_path_ind,'*_refined_*-fFit.mat'));
    
    if length(model_fname)>1
        warning('more than one model fit, selecting the latest one. Select a different model otherwise')
        % Update this with a code to determine the date of model and
        % selecting the latest
        tmp = model_fname;
        model_fname = [];
        model_fname = getlatestmodel(tmp);
        
    end
    
    model_file{cond_idx,1} = fullfile(dirPth.model_path_ind,model_fname.name);
    
end

% Create a table with different conditions and their corresponding model
% files
Cond_model = table(conditions,model_file);

% Select ROIs
num_roi = length(rois);
roi_fname = cell(num_roi,1);
for roi_idx = 1:num_roi
    roi_fname{roi_idx,1} = fullfile(dirPth.roiPth,strcat(rois{roi_idx},'.mat'));
end

% Table with different ROIs and their corresponding file dirPth
ROI_params = table(rois,roi_fname);

%% calculating pRF parameters to compare

% % Parameters of the all condition
% dirPth.all_model_path = strcat(dirPth.orig_path,'/Gray/pRF_all/');
% all_model = load(dir(fullfile(dirPth.all_model_path,'*-fFit-fFit-fFit.mat')));

% Load coordinate file
coordsFile = fullfile(dirPth.coordsPth,'coords.mat');
load(coordsFile);

% Mean map
meanFile = fullfile(dirPth.model_path_ind,'meanMap.mat');
Mmap = load(meanFile);

% Determine the voxels for different ROIs and the corresponding prf
% parameters
for roi_idx = 1:num_roi
    %Load the current roi
    load(ROI_params.roi_fname{roi_idx});
    
    % find the indices of the voxels from the ROI intersecting with all the voxels
    [~, indices_mean] = intersect(coords', ROI.coords', 'rows' );
    mean_map = Mmap.map{1}(1,indices_mean);
    
    % preallocate variables
    model_data = cell(num_cond,1);
    index_thr_tmp = cell(num_cond,1);
    for cond_idx = 1:num_cond
        
        % Current model parameters- contains x,y, sigma,
        model_data(cond_idx,1) = GetInfoModel(Cond_model.model_file{cond_idx},coordsFile,ROI_params.roi_fname{roi_idx});
        
        rm = load(Cond_model.model_file{cond_idx});
        if strcmp(rm.model{1}.description,'Difference 2D pRF fit (x,y,sigma,sigma2, center=positive)')
            [fwhmax,surroundSize,fwhmin_first, fwhmin_second, diffwhmin] = rmGetDoGFWHM(rm.model{1},[]);
            model_data{cond_idx,1}.DoGs_fwhmax = fwhmax;
            model_data{cond_idx,1}.DoGs_surroundSize = surroundSize;
            model_data{cond_idx,1}.DoGs_fwhmin_first = fwhmin_first;
            model_data{cond_idx,1}.DoGs_fwhmin_second = fwhmin_second;
            model_data{cond_idx,1}.DoGs_diffwhmin = diffwhmin;
        end
        % For every condition and roi, save the index_thr and add them to
        % the Cond_model table so that they can be loaded later
        index_thr_tmp{cond_idx,1} = model_data{cond_idx}.varexp > opt.varExpThr & model_data{cond_idx}.ecc < opt.eccThr(2) & model_data{cond_idx}.ecc > opt.eccThr(1) & mean_map > opt.meanMapThr;
        
    end
    
    % Determine the thresholded indices for each of the ROIs
    roi_index{roi_idx,1} = index_thr_tmp{1,1} & index_thr_tmp{2,1};
    
    % Apply these thresholds on the pRF parameters for both the conditions
    model_data_thr = cell(num_cond,1);
    for cond_idx = 1:num_cond
        model_data_thr{cond_idx,1} = NP_params_thr(model_data{cond_idx},roi_index{roi_idx,1},opt);
    end
    % Store the thresholded pRF values in a table
    add_t_1 = table(model_data_thr,'VariableNames',ROI_params.rois(roi_idx));
    Cond_model = [Cond_model add_t_1];
    
end
% Update the ROI_params with the thresholded index values
add_t_1_roi = table(roi_index);
ROI_params = [ROI_params add_t_1_roi];


if opt.saveData
    
   dirPth.saveDirPrfParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
   if ~exist('saveDir','dir')
       mkdir(dirPth.saveDirPrfParams);
   end 
           
   filename_res = 'prfParams.mat';
   save(fullfile(dirPth.saveDirPrfParams,filename_res),'Cond_model','ROI_params');
    
end

end