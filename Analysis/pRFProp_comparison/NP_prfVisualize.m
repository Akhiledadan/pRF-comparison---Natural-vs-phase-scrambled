function NP_prfVisualize(Cond_model,ROI_params,opt,diPth)
% Function to visualize the pRF image

plot_sigma = 0;
if plot_sigma == 1
    %To plot the pRF size values difference overlapping
    [~,sort_ve_ind_1] = sort(Cond_model.V1{1}.varexp);
    [~,sort_ve_ind_2] = sort(Cond_model.V1{2}.varexp);
    
    ind_ve_tp10_1 = sort_ve_ind_1(end-40:end);
    ind_ve_tp10_2 = sort_ve_ind_2(end-40:end);
    
    ov_ve = intersect(ind_ve_tp10_1,ind_ve_tp10_2);
    
    vox_sel =  ov_ve;
    
    [X,Y] = meshgrid(-5:0.1:5);
    figPoint_sig_1 = figure(1000);
    idx_ct = 1;
    for idx_vox = vox_sel
        
        sigma_sel_1 = Cond_model.V1{1}.sigma(idx_vox);
        x_sel_1 = Cond_model.V1{1}.x(idx_vox);
        y_sel_1 = Cond_model.V1{1}.y(idx_vox);
        prf_sel = rfGaussian2d(X,Y,sigma_sel_1,sigma_sel_1,[],x_sel_1,y_sel_1);
        subplot(ceil(sqrt(length(vox_sel))),ceil(sqrt(length(vox_sel))),idx_ct);
        imagesc(prf_sel);
        titleall = sprintf('Nat size : %d', sigma_sel_1) ;
        title(titleall);
        idx_ct = idx_ct+1;
    end
    
    figPoint_sig_1 = figure(1001);
    idx_ct = 1;
    for idx_vox = vox_sel
        
        sigma_sel_2 = Cond_model.V1{2}.sigma(idx_vox);
        x_sel_2 = Cond_model.V1{2}.x(idx_vox);
        y_sel_2 = Cond_model.V1{2}.y(idx_vox);
        prf_sel = rfGaussian2d(X,Y,sigma_sel_2,sigma_sel_2,[],x_sel_2,y_sel_2);
        subplot(ceil(sqrt(length(vox_sel))),ceil(sqrt(length(vox_sel))),idx_ct);
        imagesc(prf_sel);
        titleall = sprintf('Scram size : %d', sigma_sel_2) ;
        title(titleall);
        idx_ct = idx_ct+1;
    end
    
    % Convert it to Binary and plot in the same figure to show the difference
    % in the pRF size
end
end