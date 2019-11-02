function NP_makeFigure1(data,Cond_model,opt,dirPth)

TR               = 1.5; % sampling rate of the scanner
numTRs           = size(data.timeSeries_rois_thr{1}.tSeries,1); % total number of sampling points
numTimePoints    = numTRs * TR;
time             = linspace(1,numTimePoints,numTRs);

numRoi      = length(opt.rois);
for roi_idx = 1:numRoi
    cur_roi = opt.rois{roi_idx};
    % Plot the fit line
    figName = sprintf('Original and predicted timeSeries for roi %s',cur_roi);
    
    % find the voxels with maximum variance explained in both conditions
    % and plot those       
    thr_ve_cond1          = prctile(Cond_model{1,cur_roi}{1}.varexp,99.6);
    thr_ve_cond2          = prctile(Cond_model{2,cur_roi}{1}.varexp,99.6);
    thr_ve                = min(thr_ve_cond1,thr_ve_cond2);
    
    vox_idx_toPlot        = find(Cond_model{1,cur_roi}{1}.varexp >  thr_ve & ...
                           Cond_model{2,cur_roi}{1}.varexp > thr_ve);        

    numVox                = length(vox_idx_toPlot);
    fprintf('Plotting %d figures',numVox);
    for vox_idx = 1:numVox
        cur_vox = vox_idx_toPlot(vox_idx);
        
        fH1 = figure(1);clf;
        set(gcf,'position',[66,1,1855,1001],'Name',figName,'PaperPositionMode', 'auto');
        plot(time, data.timeSeries_rois_thr{1,roi_idx}.tSeries(:,cur_vox),'o--','color',[0.2 0.2 0.2],'LineWidth',4,'markerSize',7);
        hold on;
        plot(time, data.timeSeries_rois_thr{2,roi_idx}.tSeries(:,cur_vox),'o--','color',[0.7 0.7 0.7],'LineWidth',4,'markerSize',7);
        hold on;

        plot(time, data.predictions_rois{1,roi_idx}(cur_vox,:),'color',[0.5 0.5 1],'LineWidth',4);
        hold on;
        plot(time, data.predictions_rois{2,roi_idx}(cur_vox,:),'color',[0.5 1 0.5],'LineWidth',4);
        
        xlim(opt.xlimTS);
        ylim(opt.ylimTS);
        legend({'Natural Measured','Phase scrambled Measured','natural Predicted','Phase scrambled Predicted'},'location','southeast');
        
        %--- texts in the plot
        x_cond                = Cond_model{1,cur_roi}{1}.x(cur_vox);
        y_cond                = Cond_model{2,cur_roi}{1}.y(cur_vox);
        ve_cond1              = Cond_model{1,cur_roi}{1}.varexp(cur_vox);
        ve_cond2              = Cond_model{2,cur_roi}{1}.varexp(cur_vox);
        s_cond1               = Cond_model{1,cur_roi}{1}.sigma(cur_vox);
        s_cond2               = Cond_model{2,cur_roi}{1}.sigma(cur_vox);
        %---------------------
        
        %txt_inPlot = sprintf('  x: %f, y: %f \n nat - variance explained: %f, sigma: %f \n scram - variance explained: %f, sigma: %f',x_cond,y_cond,ve_cond1,s_cond1,ve_cond2,s_cond2);
        
        %text(0.2,0.2,txt_inPlot,'Color',[0.2 0.2 0.2],'FontSize',15,'Units','normalized');
        
        xlabel('time (sec)');
        ylabel('% BOLD response');
        set(gca,'FontUnits','centimeters', 'FontName','Helvetica','FontSize', 1.5, 'TickDir','out','LineWidth',3); box off
        
        
        if opt.saveFigTseries
            saveDir = fullfile(dirPth.saveDirMSFig,'figure1');
            if ~exist(saveDir,'dir')
                mkdir(saveDir);
            end
            
            figName(regexp(figName,' ')) = '_';
            filename                     = figName;
            fullFilename                 = sprintf([filename,'_ts_%d'],vox_idx_toPlot(vox_idx));
            print(fH1, fullfile(saveDir,fullFilename), '-depsc2');
        end
    end
end


end