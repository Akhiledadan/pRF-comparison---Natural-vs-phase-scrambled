function NP_makeFigure7(params_comp_all_sub,opt,dirPth)
% NP_makeFigure6 - figure to make the average area under curve across all
% subjects

fontSize = 15;

numSub = length(params_comp_all_sub)-1;

numRoi_max  = length(opt.rois);
cenDiff     = nan(numSub,numRoi_max);
cen_1       = nan(numSub,numRoi_max);
cen_2       = nan(numSub,numRoi_max);

for sub_idx = 1:numSub
    numRoi  = length(params_comp_all_sub{sub_idx});
    for roi_idx = 1:numRoi
        cenDiff(sub_idx,roi_idx) = params_comp_all_sub{sub_idx}{roi_idx}.cen.cenDiff;
        cenRelDiff(sub_idx,roi_idx) = params_comp_all_sub{sub_idx}{roi_idx}.cen.cenDiffRel;
        cen_1(sub_idx,roi_idx) = params_comp_all_sub{sub_idx}{roi_idx}.cen.cenVal_1;
        cen_2(sub_idx,roi_idx) = params_comp_all_sub{sub_idx}{roi_idx}.cen.cenVal_2;        
    end
end

% Individual central values for running the stats
cen.nat   = cen_1;
cen.scram = cen_2;

cen_1_ave     = mean(cen_1,1);
cen_1_std     = std(cen_1,[],1);
cen_1_sterr   = cen_1_std./sqrt(numSub);

cen_2_ave     = mean(cen_2,1);
cen_2_std     = std(cen_2,[],1);
cen_2_sterr   = cen_2_std./sqrt(numSub);

cen_ave       = [cen_1_ave'  , cen_2_ave'];
cen_sterr     = [cen_1_sterr', cen_2_sterr'];

cenDiff_ave   = mean(cenDiff,1);
cenDIff_std   = std(cenDiff,[],1);
cenDiff_sterr = cenDIff_std./sqrt(numSub);

cenRelDiff_ave   = mean(cenRelDiff,1);
cenRelDiff_std   = std(cenRelDiff,[],1);
cenRelDiff_sterr = cenRelDiff_std./sqrt(numSub);

roi_colors = [0.5 0.5 0.5; 1 0.5 0.5; 0.5 1 0.5; 0.5 0.5 1; 0.75 0.75 0; 0 0.75 0.75; 0.75 0 0.75];

%% Figure 3A *****
%-----------------

% plot the central values from the two conditions side by side for all rois
figName = sprintf('Central value (across subjects): Nat , Phase scrambled');
fH7 = figure(7);clf;
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName,'PaperPositionMode', 'auto');
h = errorbar_group(cen_ave,cen_sterr);
h(1).FaceColor = [0.5 1 0.5];
h(2).FaceColor = [0.5 0.5 1];
h(1).LineWidth = 2;
h(2).LineWidth = 2;

xlim(opt.xlimCen);
ylim(opt.ylimCen);
xlabel('Visual field maps');
ylabel('pRF size (deg)');

legend({'natural image','phase scrambled natural image'});
set(gca,'FontName','Helvetica','FontUnits','centimeters', 'FontSize', 1.1, 'TickDir','out','LineWidth',3); box off
hold off;
set(gca,'XTickLabel',opt.rois,'YTick',0:2);

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure6');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;    
    print(fH7, fullfile(saveDir,strcat(filename,'_cen_allsub')), '-depsc2');
end


%%
% plotting central value difference between natural and phase scrambled
% condition

figName = sprintf('Central value difference (across subjects): Nat - Phase scrambled');
fH71 = figure(71);
set(gcf, 'Color', 'w', 'Position',[407,103,1374,804], 'Name', figName,'PaperPositionMode', 'auto');
h = bar(cenDiff_ave,'FaceColor',roi_colors(1,:));hold on;
errorbar(cenDiff_ave,cenDiff_sterr,'LineStyle','none','LineWidth',2);
xlim(opt.xlimCen);
ylim(opt.ylimCenDiff);
xlabel('Visual areas');
ylabel('pRF size difference (deg)');
set(gca, 'FontName','Helvetica','FontSize', fontSize, 'TickDir','out','LineWidth',3); box off
hold off;
set(h.Parent,'XTickLabel',opt.rois);

p_val_text = sprintf('N = %d',numSub);
text(0.6,0.8,p_val_text,'Color',roi_colors(1,:),'FontSize',20,'Units','normalized');

%% Figure 3B
% 
% plotting relative central value difference between natural and phase scrambled
% condition ( Nat - Scram )./mean(Nat,Scram)

figName = sprintf('Central value difference (across subjects): Nat - Phase scrambled');
fH72 = figure(72);
set(gcf, 'Color', 'w', 'Position',[66,1,1855,1001], 'Name', figName);
h = bar(cenRelDiff_ave,'FaceColor',roi_colors(1,:));hold on;
errorbar(cenRelDiff_ave,cenRelDiff_sterr,'LineStyle','none','LineWidth',5,'CapSize',10);
xlim(opt.xlimCen);
ylim(opt.ylimCenRelDiff);
xlabel('Visual field maps');
ylabel('Normalized pRF size difference (%)');
set(gca,'FontUnits','centimeters', 'FontSize', 1.1, 'TickDir','out','LineWidth',3); box off
hold off;
set(h.Parent,'XTickLabel',opt.rois);

p_val_text = sprintf('N = %d',numSub);
text(0.8,0.9,p_val_text,'Color',roi_colors(1,:),'FontSize',40,'Units','normalized');


%% save figures and results

if opt.saveFig
    saveDir = fullfile(dirPth.saveDirMSFig,'figure6');
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
        
    figName(regexp(figName,' ')) = '_';
    filename = figName;
    print(fH71, fullfile(saveDir,strcat(filename,'_cen_diff_allsub')), '-depsc');
    print(fH72, fullfile(saveDir,strcat(filename,'_rel_cen_diff_allsub')), '-depsc');
    
    print(fH72, fullfile(dirPth.saveDirSup3,strcat(filename,'_rel_cen_diff_allsub')), '-depsc');
end


if opt.saveCenDiff
    dirPth.saveDirCompParamsAllSub = fullfile(dirPth.saveDirRes,strcat(opt.modelType,'_',opt.plotType));
    if ~exist(dirPth.saveDirCompParamsAllSub,'dir')
        mkdir(dirPth.saveDirCompParamsAllSub);
    end
    
    filename_res = 'central.mat';
    save(fullfile(dirPth.saveDirCompParamsAllSub,filename_res),'cen','cenRelDiff');
end


end