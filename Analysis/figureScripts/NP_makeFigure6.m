function NP_makeFigure6(params_comp_all_sub,opt,dirPth)
% NP_makeFigure6 - figure to make the average area under curve across all
% subjects

fontSize = 15;

numSub = length(params_comp_all_sub)-1;

for sub_idx = 1:numSub
    numRoi = length(params_comp_all_sub{sub_idx});
    for roi_idx = 1:numRoi
        auc(sub_idx,roi_idx) = params_comp_all_sub{sub_idx}{roi_idx}.auc.aucDiff;
    end
end


auc_ave   = mean(auc,1);
auc_std   = std(auc,[],1);
auc_sterr = auc_std./sqrt(numSub);

roi_colors = [0.5 0.5 0.5; 1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1; 0.75 0.75 0; 0 0.75 0.75; 0.75 0 0.75];

figName = sprintf('Area under the curve difference (across subjects): Nat - Phase scrambled');
fH6 = figure(6);
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);
h = bar(auc_ave,'FaceColor',roi_colors(1,:));hold on;
errorbar(auc_ave,auc_sterr,'LineStyle','none','LineWidth',2);
xlim([0 length(opt.rois)+1]);
ylim(opt.ylimAuc);
xlabel('Rois');
ylabel('AUC difference: Nat - PhScram');
set(gca, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
hold off;
set(h.Parent,'XTickLabel',opt.rois);

p_val_text = sprintf('N = %d',numSub);
text(0.6,0.8,p_val_text,'Color',roi_colors(1,:),'FontSize',20,'Units','normalized');

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure6');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH6, fullfile(saveDir,strcat(filename,'_auc_diff_allsub')), '-dpng');
end


if opt.saveAucDiff
    dirPth.saveDirCompParamsAllSub = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
    if ~exist(dirPth.saveDirCompParamsAllSub,'dir')
        mkdir(dirPth.saveDirCompParamsAllSub);
    end
    
    filename_res = 'AUC.mat';
    save(fullfile(dirPth.saveDirCompParamsAllSub,filename_res),'auc');
end


end