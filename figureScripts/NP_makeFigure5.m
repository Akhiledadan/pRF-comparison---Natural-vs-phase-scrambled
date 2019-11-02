function NP_makeFigure5(params_comp,opt,dirPth)
% Plot the difference in area under the curve for all ROIs

fontSize = 15;

%---------Plot the Area under curve-----------%
for roi_idx = 1:length(params_comp)
    auc_all_rois(:,roi_idx) = params_comp{roi_idx}.auc.aucDiff;
    BsAucDiff_all_rois(:,roi_idx) = params_comp{roi_idx}.auc.bootstrapAucDiff;
end
roi_colors = [0.5 0.5 0.5; 1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1; 0.75 0.75 0; 0 0.75 0.75; 0.75 0 0.75];

figName = sprintf('%s Area under the curve difference: Nat - Phase scrambled',opt.subjID);
fH5 = figure(5);
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);
h = bar(auc_all_rois,'FaceColor',roi_colors(1,:));hold on;
xlim([0 length(opt.rois)+1]);
ylim(opt.ylimAuc);
xlabel('Rois');
ylabel('AUC difference: Nat - PhScram');
set(gca, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
hold off;
set(h.Parent,'XTickLabel',opt.rois);

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure5');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH5, fullfile(saveDir,strcat(filename,'_auc_diff')), '-dpng');
end

if opt.aucBsPlot
    for roi_idx = 1:size(BsAucDiff_all_rois,2)
        
        roi_comp = opt.rois{roi_idx};
        figName = sprintf('Area under the curve difference: Nat - Phase scrambled');
        fH51 = figure(51); clf;
        set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);
        histogram(BsAucDiff_all_rois(:,roi_idx)); hold on;
        plot(repmat(auc_all_rois(:,roi_idx),[100,1]),0:100-1,'LineWidth',2);
        xlabel('AUC difference: Nat - PhScram');
        ylabel('frequency');
        set(gca, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
        
        p_val = sum(BsAucDiff_all_rois(:,roi_idx)>auc_all_rois(:,roi_idx))/1000;
        p_val_text = sprintf('P value: %f',p_val);
        text(0.6,1,p_val_text,'Color',roi_colors(1,:),'FontSize',20,'Units','normalized');
        
        if opt.saveFig
            saveDir = fullfile(dirPth.saveDirMSFig,'figure51');
            if ~exist(saveDir,'dir')
                mkdir(saveDir);
            end
            
            figName(regexp(figName,' ')) = '_';
            filename = figName;
            print(fH51, fullfile(saveDir,strcat(filename,sprintf('_auc_diff_%s',roi_comp))), '-dpng');
        end
        
    end
end
end