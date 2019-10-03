function NP_makeFigure3(params_comp,cur_roi,opt,dirPth)


fontSize = 15;
lineWidth = 3;

roi_idx = cur_roi.roi_idx;
roi_comp = cur_roi.roi_comp;

x_param_comp_1 = params_comp.fit.xfit;
y_param_comp_1 = params_comp.fit.yfit_comp_1;

x_param_comp_2 = params_comp.fit.xfit;
y_param_comp_2 = params_comp.fit.yfit_comp_2;

%%

fprintf('\n Plotting fitted line for roi %d \n',roi_idx);

% Plot the fit line
figName = sprintf('%s %s vs eccentricity roi %s',opt.subjID,opt.yAxis,roi_comp);

fH3 = figure(3); clf;
titleall = sprintf('%s', roi_comp) ;
title(titleall);
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);
plot(x_param_comp_1,y_param_comp_1,'color',[0.3010, 0.7450, 0.9330],'LineWidth',lineWidth);
hold on;
plot(x_param_comp_2,y_param_comp_2,'color',[0.5 1 0.5],'LineWidth',lineWidth);
xlabel('eccentricity'); ylabel('variance explained');
for c_idx=1:length(opt.conditions)
    cur_cond = opt.conditions{c_idx};
    cur_cond(regexp(cur_cond,'_'))=' ';
    lg_cond{1,c_idx} = cur_cond;
end
legend(lg_cond);
ylim(opt.yaxislim);
xlim(opt.xaxislim);
set(gca,'FontSize',fontSize,'TickDir','out','LineWidth',3); box off

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure3');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH3, fullfile(saveDir,strcat(filename,'_fit')), '-dpng');
end


%% Create a figure with all rois in the same figure for comparison

fH31 = figure(31); 
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);

roi_colors = [0.5 0.5 0.5; 1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1; 0.75 0.75 0; 0 0.75 0.75; 0.75 0 0.75];

ax1 = subplot(121);
plot(x_param_comp_1,y_param_comp_1,'color',roi_colors(roi_idx,:),'LineWidth',lineWidth);
xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
ylim([0 inf]);
xlim(opt.xaxislim);
legend(opt.rois,'Location','bestoutside')
set(ax1, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
hold on;

ax2 = subplot(122);
plot(x_param_comp_2,y_param_comp_2,'color',roi_colors(roi_idx,:),'LineWidth',lineWidth);
xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
ylim([0 inf]);
xlim(opt.xaxislim);
legend(opt.rois,'Location','bestoutside')
set(ax2, 'FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
hold on;



if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure3_1');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH31, fullfile(saveDir,strcat(filename,'_fit_allrois')), '-dpng');
end



end
    
    