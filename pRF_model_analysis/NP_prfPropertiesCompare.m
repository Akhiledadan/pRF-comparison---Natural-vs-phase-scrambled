function NP_prfPropertiesCompare(subjects)
% NP_prfPropertiesCompare - Plots Sigma vs eccentricity for the pRF fits of Natural and
% phase scrambled bar stimuli
%
% Input - subject folder names in a cell array
%
% 31/10/2018: [A.E] wrote it

numSub = length(subjects);
params_comp_all_sub = cell(1,numSub);
for sub_idx = 1:numSub
    
    subjID = subjects{sub_idx};
    fprintf('\n Subject selected: %s \n',subjID);
    
    %% Initializing required variables
    warning('off');
    % Go to the root path where a simlink called data is created, containing
    % the data
    dirPth = NP_loadPaths(subjID);
    %
    cd(NP_rootPath);
    %
    % % set options
    opt = NP_getOpts(subjID,'MsPlot',0,'extractPrfParams',0,'plotTimeSeries',0,'getPredictedResponse',0,'verbose',0);
    
    %% Get time series
    if opt.plotTimeSeries
        % Get the time series
        if opt.getTimeSeries
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Takes long time to load - preload and save
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cd(dirPth.mrvDirPth);
            
            hView = initHiddenGray;
            
            numCond = length(opt.conditions);
            numRoi = length(opt.rois);
            
            data.timeSeries_rois = cell(numCond,numRoi);
            for cond_idx = 1:numCond
                cur_cond = opt.conditions{cond_idx};
                hView = viewSet(hView,'curdt',cur_cond);
                dirPth.model_path_ind = fullfile(dirPth.modelPth,cur_cond);
                model_fname =  dir(fullfile(dirPth.model_path_ind,'*_refined_*-fFit.mat'));
                hView = rmSelect(hView,1,fullfile(model_fname.folder,model_fname.name));
                
                params = viewGet(hView, 'rmParams');
                
                for roi_idx =1:numRoi
                    cur_roi = opt.rois{roi_idx};
                    load(fullfile(dirPth.roiPth,[cur_roi '.mat']));
                    
                    ts_fileName = sprintf('TS_%s_%s',cur_cond,cur_roi);
                    ts_fullFileName = fullfile(dirPth.model_path_ind,ts_fileName);
                    
                    % check if there are time series data already saved. If yes, load them
                    % instead of reextracting.
                    
                    if ~exist([ts_fullFileName '.mat'],'file')
                        % get time series and roi-coords
                        [TS.tSeries, TS.coords, TS.params] = rmLoadTSeries(hView, params, ROI, 1);
                        
                        % detrend
                        % get/make trends
                        trends  = rmMakeTrends(params);
                        
                        % recompute
                        b = pinv(trends)*TS.tSeries;
                        TS.tSeries = TS.tSeries - trends*b;
                        
                        data.timeSeries_rois{cond_idx,roi_idx} = TS;
                        
                        save(ts_fullFileName,'TS');
                        fprintf('saving roi: %s for condition: %s',cur_cond,cur_roi);
                        
                    else
                        fprintf('loading roi: %s for condition: %s \n',cur_roi,cur_cond);
                        ts_fileName = sprintf('TS_%s_%s',cur_cond,cur_roi);
                        ts_fullFileName = fullfile(dirPth.model_path_ind,ts_fileName);
                        load(ts_fullFileName);
                        data.timeSeries_rois{cond_idx,roi_idx} = TS;
                        
                    end
                    
                    
                    
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            numCond = length(opt.conditions);
            numRoi  = length(opt.rois);
            for cond_idx = 1:numCond
                cur_cond = opt.conditions{cond_idx};
                dirPth.model_path_ind = fullfile(dirPth.modelPth,cur_cond);
                for roi_idx = 1:numRoi
                    cur_roi = opt.rois{roi_idx};
                    ts_fileName = sprintf('TS_%s_%s',cur_cond,cur_roi);
                    ts_fullFileName = fullfile(dirPth.model_path_ind,[ts_fileName '.mat']);
                    load(ts_fullFileName);
                    data.timeSeries_rois{cond_idx,roi_idx} = TS;
                end
            end
        end
        
    end
    %% Extract pRF parameters
    
    if opt.extractPrfParams
        fprintf('(%s) extracting prf parameters from all roi and saving...',mfilename)
        [Cond_model,ROI_params] = NP_getModelParams(opt,dirPth);
        fprintf('\n DONE \n')
    else
        fprintf('(%s) loading previously saved prf parameters...',mfilename)
        dirPth.saveDirPrfParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
        load(fullfile(dirPth.saveDirPrfParams,'prfParams.mat'));
    end
    
    %% Determine the predicted fMRI response for every roi voxels
    if opt.plotTimeSeries
        if opt.getPredictedResponse
            numCond = length(opt.conditions);
            numRoi = length(opt.rois);
            
            for cond_idx = 1:numCond
                cur_cond = opt.conditions{cond_idx};
                for roi_idx = 1:numRoi
                    cur_roi     = opt.rois{roi_idx};
                    roiThrIdx   = ROI_params{roi_idx,'roi_index'}{1};
                    data.timeSeries_rois_thr{cond_idx,roi_idx}.tSeries = data.timeSeries_rois{cond_idx,roi_idx}.tSeries(:,roiThrIdx);
                    
                    stim    = data.timeSeries_rois{1}.params.stim;
                    model   = Cond_model{cond_idx,cur_roi}{1};
                    pred    = NP_getPredictedResponse(stim,model,data.timeSeries_rois_thr{cond_idx,roi_idx},data.timeSeries_rois{cond_idx,roi_idx}.params); % prediction = (stim*pRFModel)xBeta
                    data.predictions_rois_thr{cond_idx,roi_idx} = pred;
                end
            end
        end
        
        if opt.verbose
            if opt.plotTimeSeries
                % Plot original and predicted timeSeries: Figure 1
                NP_makeFigure1(data,Cond_model,opt,dirPth);
            end
        end
    end
    %% plot prf figure for visualization
    
    if opt.visPRF
        NP_prfVisualize(Cond_model, ROI_params,opt,dirPth);
    end
    
    %% Plot figures for manuscript
    
    % Select ROIs
    num_roi = length(opt.rois);
    cur_roi = struct();
    % Plot raw data and the fits
    close all;
    params_comp_all = cell(1,num_roi);
    for roi_idx = 1:num_roi
        cur_roi.roi_idx = roi_idx;
        
        roi_name = ROI_params{roi_idx,1};
        fprintf('(%s) extracting %s for roi %s \n',mfilename,opt.plotType,roi_name{1})
        
        roi_comp = ROI_params.rois{roi_idx};
        cur_roi.roi_comp = roi_comp;
        
        data_comp_1 = Cond_model{1,1}{1};
        data_comp_2 = Cond_model{2,1}{1};
        data_comp_1(data_comp_1 == '_') = ' ';
        data_comp_2(data_comp_2 == '_') = ' ';
        
        % get the prf parameters to compare
        [params_comp.raw,opt] = NP_prfParametersToCompare(Cond_model,cur_roi,opt);
        
        if opt.detailedPlot
            if opt.verbose
                % Plot raw data: Figure 2 for the manuscript
                NP_makeFigure2(params_comp,cur_roi,opt,dirPth);
            end
        end
        
        % Do a linear regression of the two parameters weighted with the variance explained
        fprintf('\n Calculating slope and intercept for the best fitting line for the conditions for roi %d \n',roi_idx)
        params_comp.fit.xfit = linspace(opt.eccThr(1),opt.eccThr(2),20)';
        [params_comp.fit.yfit_comp_1,params_comp.fit.fitStats_1] = NP_fit(params_comp.raw.x_comp_1,params_comp.raw.y_comp_1,params_comp.raw.varexp_comp_1,params_comp.fit.xfit);
        [params_comp.fit.yfit_comp_2,params_comp.fit.fitStats_2] = NP_fit(params_comp.raw.x_comp_2,params_comp.raw.y_comp_2,params_comp.raw.varexp_comp_2,params_comp.fit.xfit);
        
        if opt.detailedPlot
            if opt.verbose
                % Plot fit: Figure 3
                NP_makeFigure3(params_comp,cur_roi,opt,dirPth);
            end
        end
        
        % Plot binned data according to eccentricity, fitted a line to the mean
        % within the bin, bootstrapped the bins 1000 times without replacement
        % and calculated the 97.5 % CI
        fprintf('Binning and bootstrapping the data for roi %s \n',roi_name{1})
        
        % Bootstrap the data and bin the x parameter
        [params_comp.bin.binVal_comp_1,params_comp.bin.binValUpper_comp_1,params_comp.bin.binValLower_comp_1,params_comp.bin.binXVal_comp_1] = NP_bin_param(params_comp.raw.x_comp_1,params_comp.raw.y_comp_1,params_comp.raw.varexp_comp_1,params_comp.fit.xfit,opt);
        [params_comp.bin.binVal_comp_2,params_comp.bin.binValUpper_comp_2,params_comp.bin.binValLower_comp_2,params_comp.bin.binXVal_comp_2] = NP_bin_param(params_comp.raw.x_comp_2,params_comp.raw.y_comp_2,params_comp.raw.varexp_comp_2,params_comp.fit.xfit,opt);
        % Find the best fitting line to the mean values within the bins. Bootstrap across
        % bins and find the 95 % CI (not weigted with the ve)
        [params_comp.bin.binValFit_comp_1,params_comp.bin.fitStats_1] = NP_fit(params_comp.bin.binVal_comp_1.x,params_comp.bin.binVal_comp_1.y,[],params_comp.bin.binVal_comp_1.x);
        [params_comp.bin.binValFit_comp_2,params_comp.bin.fitStats_2] = NP_fit(params_comp.bin.binVal_comp_2.x,params_comp.bin.binVal_comp_2.y,[],params_comp.bin.binVal_comp_2.x);
        
        % SUPPLEMENTARY FIGURE 1 ****
        if opt.MsPlot
            if opt.verbose
                % Plot binned fit: Figure 4
                NP_makeFigure4(params_comp,cur_roi,opt,dirPth);
            end
        end
        
        % Calculate difference in area under the curve between the two conditions
        params_comp.auc.in.x = [params_comp.bin.binVal_comp_1.x', params_comp.bin.binVal_comp_2.x'];
        params_comp.auc.in.y = [params_comp.bin.binVal_comp_1.y', params_comp.bin.binVal_comp_2.y'];
        
        params_comp.auc.aucDiff = NP_AUC(params_comp.auc.in.x,params_comp.auc.in.y);
        [params_comp.auc.bootstrapAucDiff,params_comp.auc.aucUpper,params_comp.auc.aucLower] = NP_AUC_bootstrap(params_comp.auc.in.x,params_comp.auc.in.y);
        
        % Calculate central values and difference in central values
        % stimulus range is 5 degrees radius. central value is calculated
        % at 2.5 degrees: Y2.5 = m*2.5 + c
        [params_comp.cen.cenVal_1,params_comp.cen.cenVal_2,params_comp.cen.cenDiff,params_comp.cen.cenDiffRel] = NP_CEN(params_comp);
        
        
        % Save the parameters from all ROIs
        params_comp_all{roi_idx}=params_comp;
        
    end
    
    if opt.detailedPlot
        if opt.verbose
            % figure - average of difference in prf size
            NP_makeFigure2A(params_comp_all,cur_roi,opt,dirPth);
        end
    end
    
    % SUPPLEMENTARY FIGURE 2 ****
    if opt.MsPlot
        % Plot central values: Figure 5A
        NP_makeFigure5A(params_comp_all,opt,dirPth);
    end
    
    if opt.detailedPlot
        if opt.verbose
            % Plot auc: Figure 5
            NP_makeFigure5(params_comp_all,opt,dirPth);
        end
    end
    
    params_comp_all_sub{sub_idx} = params_comp_all;
    
    if opt.saveData
        
        dirPth.saveDirCompParams = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
        if ~exist(dirPth.saveDirCompParams,'dir')
            mkdir(dirPth.saveDirCompParams);
        end
        
        filename_res = 'compParams.mat';
        save(fullfile(dirPth.saveDirCompParams,filename_res),'params_comp_all');
        
    end
    
end

params_comp_all_sub{sub_idx+1} = subjects;

opt_all = NP_getOpts_all;
dirPth_all = NP_loadPaths_all;

if opt_all.aveSub
    % Plot average auc across all subjects: Figure 6
    NP_makeFigure6(params_comp_all_sub,opt_all,dirPth_all)
 
    % MAIN FIGURE 3 ******** 
    % SUPPLEMENTARY FIGURE 3 ****
    % Plot average central value across all subjects: Figure 7
    NP_makeFigure7(params_comp_all_sub,opt_all,dirPth_all)
    
    if opt.saveData
        
        dirPth_all.saveDirCompParamsAllSub = fullfile(dirPth_all.saveDirRes,strcat(opt_all.modelType,'_',opt_all.plotType));
        if ~exist(dirPth_all.saveDirCompParamsAllSub,'dir')
            mkdir(dirPth_all.saveDirCompParamsAllSub);
        end
        
        filename_res = 'compParamsAllSub.mat';
        save(fullfile(dirPth_all.saveDirCompParamsAllSub,filename_res),'params_comp_all_sub');
        
    end
end

fprintf('\n (%s)Done! \n',mfilename);

end







