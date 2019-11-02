function [params_comp,opt] = NP_prfParametersToCompare(Cond_model,cur_roi,opt)
% NP_prfParametersToCompare - extract the prf parameters to compare

    roi_comp = cur_roi.roi_comp;
    % Choose the pRF parameters to compare
    switch opt.plotType
        
        case 'Ecc_Sig'
            opt.yAxis = 'Sigma';            
            
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.ecc;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.ecc;
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
            
            varexp_param_comp_1 = Cond_model{1,roi_comp}{1}.varexp;
            varexp_param_comp_2 = Cond_model{2,roi_comp}{1}.varexp;
            
            y_comp_diff = y_param_comp_1 - y_param_comp_2;
            y_comp_diff_ave = mean(y_comp_diff); 
            
            % Axis limits for plotting
            xaxislim = [0 5];
            yaxislim = [0 2.5];
            
            % x range values for fitting
            xfit_range = opt.eccThr;
            
            
        case 'Ecc_SurSize_DoGs'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.ecc;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.ecc;
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.DoGs_surroundSize;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.DoGs_surroundSize;
            
            varexp_param_comp_1 = Cond_model{1,roi_comp}{1}.varexp;
            varexp_param_comp_2 = Cond_model{2,roi_comp}{1}.varexp;
            
            % Axis limits for plotting
            xaxislim = [0 5];
            yaxislim = [0 5];
            
            % x range values for fitting
            xfit_range = [Ecc_Thr_low Ecc_Thr];
            
        case 'Pol_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.pol;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.pol;
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
            
            varexp_param_comp_1 = Cond_model{1,roi_comp}{1}.varexp;
            varexp_param_comp_2 = Cond_model{2,roi_comp}{1}.varexp;
            
            % Axis limits for plotting
            xaxislim = [0 2*pi];
            yaxislim = [0 5];
            
            % x range values for fitting
            Pol_Thr_low = 0;
            Pol_Thr = 2*pi;
            xfit_range = [Pol_Thr_low Pol_Thr];
            
        case 'X_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.x;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.x;
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
        case 'Y_Sig'
            x_param_comp_1 = Cond_model{1,roi_comp}{1}.y;
            x_param_comp_2 = Cond_model{2,roi_comp}{1}.y;
            
            y_param_comp_1 = Cond_model{1,roi_comp}{1}.sigma;
            y_param_comp_2 = Cond_model{2,roi_comp}{1}.sigma;
    end
    
    params_comp.x_comp_1 = x_param_comp_1;
    params_comp.y_comp_1 = y_param_comp_1;
    params_comp.varexp_comp_1 = varexp_param_comp_1;   

    params_comp.x_comp_2 = x_param_comp_2;
    params_comp.y_comp_2 = y_param_comp_2;
    params_comp.varexp_comp_2 = varexp_param_comp_2;
    
    params_comp.y_comp_diff = y_comp_diff;
    params_comp.y_comp_diff_ave = y_comp_diff_ave;
    
    opt.xaxislim = xaxislim;
    opt.yaxislim = yaxislim;
    opt.xfit_range = xfit_range;
    
    fprintf('\n DONE \n')
end