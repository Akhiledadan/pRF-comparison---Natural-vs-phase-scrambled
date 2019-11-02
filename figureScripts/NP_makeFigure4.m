function NP_makeFigure4(params_comp,cur_roi,opt,dirPth)


fontSize = 1.1; % in centimeters
lineWidth = 3;
MarkerSize = 5;

roi_idx = cur_roi.roi_idx;
roi_comp = cur_roi.roi_comp;

% fitted line to the mean of bins
x_param_comp_1 = params_comp.fit.xfit;
y_param_comp_1 = params_comp.bin.binValFit_comp_1;

% binned values 
x_bin_param_comp_1 = params_comp.bin.binXVal_comp_1;
upper_bin_param_comp_1 = params_comp.bin.binValUpper_comp_1;
lower_bin_param_comp_1 = params_comp.bin.binValLower_comp_1;

% fitted line to the mean of bins
x_param_comp_2 = params_comp.fit.xfit;
y_param_comp_2 = params_comp.bin.binValFit_comp_2;

% binned values 
x_bin_param_comp_2 = params_comp.bin.binXVal_comp_1;
upper_bin_param_comp_2 = params_comp.bin.binValUpper_comp_2;
lower_bin_param_comp_2 = params_comp.bin.binValLower_comp_2;

% Mean of each bin and their standard error
mean_bin_x_param_comp_1 = params_comp.bin.binVal_comp_1.x;
mean_bin_y_param_comp_1 = params_comp.bin.binVal_comp_1.y;
sterr_bin_y_param_comp_1 = params_comp.bin.binVal_comp_1.ysterr;

mean_bin_x_param_comp_2 = params_comp.bin.binXVal_comp_2;
mean_bin_y_param_comp_2 = params_comp.bin.binValFit_comp_2;
sterr_bin_y_param_comp_2 = params_comp.bin.binVal_comp_2.ysterr;

%%
fprintf('\n Plotting fitted line for roi %d \n',roi_idx);

% Plot the fit line
figName = sprintf('%s %s vs eccentricity roi %s',opt.subjID,opt.yAxis,roi_comp);

fH4 = figure(4); clf;
%titleall = sprintf('%s', roi_comp) ;
%title(titleall);
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);
plot(x_bin_param_comp_1,y_param_comp_1,'color',[0.3010, 0.7450, 0.9330],'LineWidth',lineWidth);hold on;
plot(x_bin_param_comp_2,y_param_comp_2,'color',[0.4 1 0.4],'LineWidth',lineWidth);
hold on;
patch([x_bin_param_comp_1, fliplr(x_bin_param_comp_1)], [lower_bin_param_comp_1', flipud(upper_bin_param_comp_1)'], [0.3010, 0.7450, 0.9330], 'FaceAlpha', 0.5, 'LineStyle','none','HandleVisibility','off');
patch([x_bin_param_comp_2, fliplr(x_bin_param_comp_2)], [lower_bin_param_comp_2', flipud(upper_bin_param_comp_2)'], [0.4 1 0.4], 'FaceAlpha', 0.5, 'LineStyle','none','HandleVisibility','off');
hold on;
errorbar(mean_bin_x_param_comp_1,mean_bin_y_param_comp_1,sterr_bin_y_param_comp_1,'bo','MarkerFaceColor','b','MarkerSize',MarkerSize,'HandleVisibility','off');
errorbar(mean_bin_x_param_comp_2,mean_bin_y_param_comp_2,sterr_bin_y_param_comp_2,'go','MarkerFaceColor','g','MarkerSize',MarkerSize,'HandleVisibility','off');
xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
for c_idx=1:length(opt.conditions)
    cur_cond = opt.conditions{c_idx};
    cur_cond(regexp(cur_cond,'_'))=' ';
    lg_cond{1,c_idx} = cur_cond;
end

txt_inPlot = sprintf('nat: y = %.2fx + %.2f \n scram: y = %.2fx + %.2f',params_comp.bin.fitStats_1.p(1),params_comp.bin.fitStats_1.p(2),params_comp.bin.fitStats_2.p(1),params_comp.bin.fitStats_2.p(2));
text(0.3,0.9,txt_inPlot,'Color',[0.2 0.2 0.2],'FontSize',15,'Units','normalized');

legend(lg_cond);
ylim(opt.yaxislim);
xlim(opt.xaxislim);
set(gca,'FontUnits','centimeters', 'FontSize', 1.1, 'TickDir','out','LineWidth',3); box off

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure4');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH4, fullfile(saveDir,strcat(filename,'_fit')), '-depsc');
end


%% Create a figure with all rois in the same figure for comparison

fH41 = figure(41); 
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);

roi_colors = [0.5 0.5 0.5; 1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1; 0.75 0.75 0; 0 0.75 0.75; 0.75 0 0.75];
%titleall = sprintf('%s', roi_comp) ;
%title(titleall);

ax1 = subplot(121);
patch([x_bin_param_comp_1, fliplr(x_bin_param_comp_1)], [lower_bin_param_comp_1', flipud(upper_bin_param_comp_1)'], roi_colors(roi_idx,:), 'FaceAlpha', 0.5, 'LineStyle','none','HandleVisibility','off');
hold on;
plot(x_bin_param_comp_1,y_param_comp_1,'color',roi_colors(roi_idx,:),'LineWidth',lineWidth);
xlabel('eccentricity (deg)'); ylabel('pRF size (deg)');
ylim(opt.yaxislim);
xlim(opt.xaxislim);
legend(opt.rois,'Location','bestoutside');
set(ax1, 'FontUnits','centimeters', 'FontSize', fontSize, 'TickDir','out','LineWidth',3,...
             'XTick',[0 5],'XTickLabel',{'0','5'}); box off
hold on;

ax2 = subplot(122);
%set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName);
patch([x_bin_param_comp_2, fliplr(x_bin_param_comp_2)], [lower_bin_param_comp_2', flipud(upper_bin_param_comp_2)'],roi_colors(roi_idx,:), 'FaceAlpha', 0.5, 'LineStyle','none','HandleVisibility','off'); hold on;
hold on;
plot(x_bin_param_comp_2,y_param_comp_2,'color',roi_colors(roi_idx,:),'LineWidth',lineWidth); 
legend(opt.rois,'Location','bestoutside');
xlabel('eccentricity (deg)'); ylabel('');
ylim(opt.yaxislim);
xlim(opt.xaxislim);
set(ax2, 'FontUnits','centimeters', 'FontSize', fontSize, 'TickDir','out','LineWidth',3,...
             'XTick',[0 5],'XTickLabel',{'0','5'}); box off
hold on;

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure4_1');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH41, fullfile(saveDir,strcat(filename,'_fit_allrois')), '-depsc');
    
    if strcmpi(roi_comp,'LO2')
        print(fH41, fullfile(dirPth.saveDirSup1,strcat(filename,'_fit_allrois')), '-depsc');
    end
    
end



end
    
    