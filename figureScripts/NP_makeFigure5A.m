function NP_makeFigure5A(params_comp,opt,dirPth)
% Plot the difference in central value for all ROIs

fontSize = 15;

%---------Plot the Area under curve-----------%
for roi_idx = 1:length(params_comp)
    cen_all_rois(:,roi_idx) = params_comp{roi_idx}.cen.cenDiffRel;
%     BsCenDiff_all_rois(:,roi_idx) = params_comp{roi_idx}.cen.bootstrapCenDiff;
end
roi_colors = [0.5 0.5 0.5; 1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1; 0.75 0.75 0; 0 0.75 0.75; 0.75 0 0.75];

figName = sprintf('%s Central value difference: Nat - Phase scrambled',opt.subjID);
fH5A = figure(50);
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);
h = bar(cen_all_rois,'FaceColor',roi_colors(1,:));hold on;
h(1).FaceColor = [0.5 0.5 0.5];
h(1).LineWidth = 2;

xlim([0 length(opt.rois)+1]);
ylim(opt.ylimCen);
xlabel('Visual field maps');
ylabel('Normalized pRF size difference (%)');
set(gca,'FontUnits','centimeters', 'FontSize', 1.1, 'TickDir','out','LineWidth',3); box off
hold off;
set(h.Parent,'XTickLabel',opt.rois);

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure5');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH5A, fullfile(saveDir,strcat(filename,'_cen_diff')), '-depsc');
    print(fH5A, fullfile(dirPth.saveDirSup2,strcat(filename,'_cen_diff')), '-depsc');
    
end


% for roi_idx = 1:size(BsCenDiff_all_rois,2)
%     
%     roi_comp = opt.rois{roi_idx};
%     figName = sprintf('Area under the curve difference: Nat - Phase scrambled');
%     fH51A = figure(51); clf;
%     set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);
%     histogram(BsCenDiff_all_rois(:,roi_idx)); hold on;
%     plot(repmat(cen_all_rois(:,roi_idx),[100,1]),0:100-1,'LineWidth',2);
%     xlabel('cen difference: Nat - PhScram');
%     ylabel('frequency');
%     set(gca, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
%     
%     p_val = sum(BsCenDiff_all_rois(:,roi_idx)>cen_all_rois(:,roi_idx))/1000;
%     p_val_text = sprintf('P value: %f',p_val);
%     text(0.6,1,p_val_text,'Color',roi_colors(1,:),'FontSize',20,'Units','normalized');
%     
%     if opt.saveFig
%         saveDir = fullfile(dirPth.saveDirMSFig,'figure51');
%         if ~exist(saveDir,'dir')
%             mkdir(saveDir);
%         end
%         
%         figName(regexp(figName,' ')) = '_';
%         filename = figName;
%         print(fH51A, fullfile(saveDir,strcat(filename,sprintf('_cen_diff_%s',roi_comp))), '-dpng');
%     end
%     
% end

end