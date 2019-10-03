function NP_makeFigure2A(params_comp,cur_roi,opt,dirPth)
% NP_makeFigure2A subtracts raw prf size values between condition 1 and 2
% and computes the average for each ROI



fontSize = 15;

for roi_idx = 1:length(params_comp)
    y_param_comp_diff_ave(roi_idx) = params_comp{roi_idx}.raw.y_comp_diff_ave;    
end

roi_colors = [0.5 0.5 0.5; 1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1; 0.75 0.75 0; 0 0.75 0.75; 0.75 0 0.75];

figName = sprintf('%s Average difference: Nat - Phase scrambled',opt.subjID);
fH2A = figure(20);
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);
h = bar(y_param_comp_diff_ave,'FaceColor',roi_colors(1,:));hold on;
xlim([0 length(opt.rois)+1]);
ylim([-inf inf]);
xlabel('Rois');
ylabel('average difference: Nat - PhScram');
set(gca, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
hold off;
set(h.Parent,'XTickLabel',opt.rois);

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure2A');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH2A, fullfile(saveDir,strcat(filename,'_ave_diff')), '-dpng');
end



end
