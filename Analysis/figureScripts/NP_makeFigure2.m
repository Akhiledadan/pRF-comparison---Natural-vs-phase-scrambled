function NP_makeFigure2(params_comp,cur_roi,opt,dirPth)


fontSize = 15;

roi_idx = cur_roi.roi_idx;
roi_comp = cur_roi.roi_comp;

x_param_comp_1 = params_comp.raw.x_comp_1;
y_param_comp_1 = params_comp.raw.y_comp_1;
ve_param_comp_1 = params_comp.raw.varexp_comp_1;

x_param_comp_2 = params_comp.raw.x_comp_2;
y_param_comp_2 = params_comp.raw.y_comp_2;
ve_param_comp_2 = params_comp.raw.varexp_comp_2;

%%

fprintf('\n Plotting raw data for roi %d \n',roi_idx);

% Plot the fit line
figName = sprintf('%s %s vs eccentricity roi %s',opt.subjID,opt.yAxis,roi_comp);

fH2 = figure(2); clf;
titleall = sprintf('%s', roi_comp) ;
title(titleall);
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);

ax1 = subplot(2,2,1);
plot(x_param_comp_1,y_param_comp_1,'.','color',[0.3010, 0.7450, 0.9330],'MarkerSize',10);
xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
ylim(opt.yaxislim);
xlim(opt.xaxislim);
legend('pRF nat');
set(ax1, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off

ax2 = subplot(2,2,3);
plot(x_param_comp_1,ve_param_comp_1,'.','color',[0.3010, 0.7450, 0.9330],'MarkerSize',10);
xlabel('eccentricity (deg)'); ylabel('variance explained (%)');
ylim([0 1]);
xlim(opt.xaxislim);
set(ax2, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off

ax3 = subplot(2,2,2);
plot(x_param_comp_2,y_param_comp_2,'.','color',[0.5 1 0.5],'MarkerSize',10);
xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
ylim(opt.yaxislim);
xlim(opt.xaxislim);
legend('pRF scram');
set(ax3, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off

ax4 = subplot(2,2,4);
plot(x_param_comp_2,ve_param_comp_2,'.','color',[0.5 1 0.5],'MarkerSize',10);
xlabel('eccentricity (deg)'); ylabel('variance explained (%)');
ylim([0 1]);
xlim(opt.xaxislim);
set(ax4, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off


if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure2');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH2, fullfile(saveDir,strcat(filename,'_raw')), '-dpng');
end


%% Create a figure with all rois in the same figure for comparison

fH21 = figure(21); 
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);

roi_colors = [0.5 0.5 0.5; 1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1; 0.75 0.75 0; 0 0.75 0.75; 0.75 0 0.75];

ax1 = subplot(121);
plot(x_param_comp_1,y_param_comp_1,'.','color',roi_colors(roi_idx,:),'MarkerSize',10);
xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
ylim([0 inf]);
xlim(opt.xaxislim);
legend(opt.rois)
set(ax1, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
hold on;

ax1 = subplot(122);
plot(x_param_comp_2,y_param_comp_2,'.','color',roi_colors(roi_idx,:),'MarkerSize',10);
xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
ylim([0 inf]);
xlim(opt.xaxislim);
legend(opt.rois)
set(ax1, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
hold on;



if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure2_1');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH21, fullfile(saveDir,strcat(filename,'_raw_allrois')), '-dpng');
end



end
    
    