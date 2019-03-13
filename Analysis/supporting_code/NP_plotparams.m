ROI_choice_all = [{'V1'},{'V2'},{'V3'}];
subdir = uigetdir(pwd,'Select subject directory');
main_dir = subdir;
cur_time = datestr(now);
cur_time(cur_time == ' ' | cur_time == ':' | cur_time == '-') = '_';
save_dir = fullfile(main_dir, ['/Results' '_' cur_time]);
mkdir(save_dir);

for i = 1:size(ROI_choice_all,2)
ROI_choice = ROI_choice_all{i};
% get the pRF properties
%Select the subject folder to use
%subdir = uigetdir(pwd,'Select subject directory');
sl = find(subdir=='_'); 
sl_final = sl(end);
sub = subdir(sl_final+1:end);

%%select Gray directory
Graydir = fullfile(subdir,'Gray');%uigetdir(pwd,'Select Gray directory');

%%the long way of selection the pRF_folders
files = dir(Graydir);
dirFlags = [files.isdir];
subfolders = files(dirFlags);
names = {subfolders.name};
selection = ~cellfun('isempty',strfind(names,'pRF'));
pRF_folders = names(selection);

clear xlabel ylabel title
xaxislim = [0 5];
yaxislim = [0 3];

MarkerSize = 6;
plot_pv = 0;

ALL_INCL = false; %include or exclude the all condition in the plots
want_plots = false; %always leave it like this! Plots will be generated, but only if all the parameters are loaded (automatic true)
%ROI_choice = 'V3';
%plot_choice = 'ynatVSyscram'; %current options: 'sigmaVSeccentricity'; 'xVSy'; 'xnatVSxscram'; 'ynatVSyscram'
plot_choice = 'sigmaVSeccentricity';

%%%%TO DO: treshold voxels the same for all conditions
for i= 1:length(pRF_folders)
    % ask which model to use to predict the fMRI timeseries
%     title = strcat('Choose retinotopic model :');
%     rmFile = getPathStrDialog(pwd,title,'*.mat')

    pRF_dir = cell2mat(fullfile(Graydir,pRF_folders(i)));
    filesModel = dir(pRF_dir);
    namesModel = {filesModel.name};
    selection_fFit = ~cellfun('isempty',strfind(namesModel,'-fFit'));
    struct_rmFile = filesModel(selection_fFit);
    rmFile = fullfile(pRF_dir,struct_rmFile.name);
     
%     drawnow;
%     modelData = load(rmFile); % pRF model (model for the retinotopy stimulus)

    % coordinate and ROI
    coordsFile = fullfile(Graydir,'coords.mat'); %'Gray/coords.mat';
    load(coordsFile);
    selection_mMap = ~cellfun('isempty',strfind(namesModel,'meanMap'));
    struct_meanfile = filesModel(selection_mMap);
    meanFile = fullfile(pRF_dir,struct_meanfile.name);
    drawnow;
    A = load(meanFile); 

    ROI_name = string(ROI_choice);
    switch ROI_name
        case {'V1'}
            ROIFiles = fullfile(Graydir,'ROIs/V1.mat');%'Gray/ROIs/V1.mat';
        case {'V2'}
            ROIFiles = fullfile(Graydir,'ROIs/V2.mat');%'Gray/ROIs/V2.mat';
        case {'V3'}
            ROIFiles = fullfile(Graydir,'ROIs/V3.mat');%'Gray/ROIs/V3.mat';
    end
    load(ROIFiles);

    %[coords_mean, indices_mean] = intersect(VOLUME{1}.coords', ROI.coords', 'rows' );% find the indices of the voxels from the ROI intersecting with all the voxels
    [coords_mean, indices_mean] = intersect(coords', ROI.coords', 'rows' );% find the indices of the voxels from the ROI intersecting with all the voxels
    mean_Map = A.map{1}(1,indices_mean);

%     parametersData = GetInfoModel(rmFile,coordsFile,ROIFiles);

    Condition = lower(cell2mat(pRF_folders(i)));
    switch Condition
        case {'prf_all'}
            parametersData_all = GetInfoModel(rmFile,coordsFile,ROIFiles);
            modelData_all = load(rmFile); % pRF model (model for the retinotopy stimulus)
            modelData_all.Variance_Explained = parametersData_all{1,1}.varexp;
            modelData_all.Eccentricity = parametersData_all{1,1}.ecc;
            modelData_all.Meanmap = mean_Map;
        case {'prf_nat'}
            parametersData_nat = GetInfoModel(rmFile,coordsFile,ROIFiles);
            modelData_nat = load(rmFile); % pRF model (model for the retinotopy stimulus)
            modelData_nat.Variance_Explained = parametersData_nat{1,1}.varexp;
            modelData_nat.Eccentricity = parametersData_nat{1,1}.ecc;
            modelData_nat.Meanmap = mean_Map;
        case {'prf_scram'}
            parametersData_scram = GetInfoModel(rmFile,coordsFile,ROIFiles);
            modelData_scram = load(rmFile); % pRF model (model for the retinotopy stimulus)
            modelData_scram.Variance_Explained = parametersData_scram{1,1}.varexp;
            modelData_scram.Eccentricity = parametersData_scram{1,1}.ecc;
            modelData_scram.Meanmap = mean_Map;
    end
end

Var_Exp_Thr = 0.40;
Ecc_Thr = 4;
Ecc_Thr_low = 0.5;
Mean_map_Thr = 1000;

%     index_thr = modelData.Variance_Explained > Var_Exp_Thr & modelData.Eccentricity < Ecc_Thr & modelData.Eccentricity > Ecc_Thr_low & modelData.Meanmap > Mean_map_Thr;
if ALL_INCL
    index_thr = modelData_all.Variance_Explained > Var_Exp_Thr & modelData_all.Eccentricity < Ecc_Thr & modelData_all.Eccentricity > Ecc_Thr_low & modelData_all.Meanmap > Mean_map_Thr & ...
        modelData_scram.Variance_Explained > Var_Exp_Thr & modelData_scram.Eccentricity < Ecc_Thr & modelData_scram.Eccentricity > Ecc_Thr_low & modelData_scram.Meanmap > Mean_map_Thr & ...
        modelData_nat.Variance_Explained > Var_Exp_Thr & modelData_nat.Eccentricity < Ecc_Thr & modelData_nat.Eccentricity > Ecc_Thr_low & modelData_nat.Meanmap > Mean_map_Thr;
else
    index_thr = modelData_scram.Variance_Explained > Var_Exp_Thr & modelData_scram.Eccentricity < Ecc_Thr & modelData_scram.Eccentricity > Ecc_Thr_low & modelData_scram.Meanmap > Mean_map_Thr & ...
        modelData_nat.Variance_Explained > Var_Exp_Thr & modelData_nat.Eccentricity < Ecc_Thr & modelData_nat.Eccentricity > Ecc_Thr_low & modelData_nat.Meanmap > Mean_map_Thr;
end


%%create second loop to make use tresholded data for each condition AND
%%store in seperately named variable. This is the lazy solution necessary for the
%%case 'xnatVSxscram'

parametersData_thr_all{1}.x = parametersData_all{1}.x(1,index_thr);
parametersData_thr_all{1}.y = parametersData_all{1}.y(1,index_thr);
parametersData_thr_all{1}.sigma = parametersData_all{1}.sigma(1,index_thr);
parametersData_thr_all{1}.ecc = parametersData_all{1}.ecc(1,index_thr);
parametersData_thr_all{1}.varexp = parametersData_all{1}.varexp(1,index_thr);

parametersData_thr_nat{1}.x = parametersData_nat{1}.x(1,index_thr);
parametersData_thr_nat{1}.y = parametersData_nat{1}.y(1,index_thr);
parametersData_thr_nat{1}.sigma = parametersData_nat{1}.sigma(1,index_thr);
parametersData_thr_nat{1}.ecc = parametersData_nat{1}.ecc(1,index_thr);
parametersData_thr_nat{1}.varexp = parametersData_nat{1}.varexp(1,index_thr);

parametersData_thr_scram{1}.x = parametersData_scram{1}.x(1,index_thr);
parametersData_thr_scram{1}.y = parametersData_scram{1}.y(1,index_thr);
parametersData_thr_scram{1}.sigma = parametersData_scram{1}.sigma(1,index_thr);
parametersData_thr_scram{1}.ecc = parametersData_scram{1}.ecc(1,index_thr);


% plot raw data
figPoint_raw = figure(100);
plot(parametersData_thr_nat{1}.ecc,parametersData_thr_nat{1}.sigma,'b*');
figure(100); hold on; plot(parametersData_thr_scram{1}.ecc,parametersData_thr_scram{1}.sigma,'g*');
filename = strcat(save_dir, '/', sub, 'plot', ROI_choice,'raw', '.png');
saveas(figPoint_raw,filename);


for i= 1:length(pRF_folders)
    % ask which model to use to predict the fMRI timeseries
%     title = strcat('Choose retinotopic model :');
%     rmFile = getPathStrDialog(pwd,title,'*.mat')

    pRF_dir = cell2mat(fullfile(Graydir,pRF_folders(i)))
    filesModel = dir(pRF_dir);
    namesModel = {filesModel.name};
    selection_fFit = ~cellfun('isempty',strfind(namesModel,'-fFit'));
    struct_rmFile = filesModel(selection_fFit);
    rmFile = fullfile(pRF_dir,struct_rmFile.name);
    drawnow;
%     modelData = load(rmFile); % pRF model (model for the retinotopy stimulus)

    % coordinate and ROI
    coordsFile = fullfile(Graydir,'coords.mat'); %'Gray/coords.mat';
    load(coordsFile);
    selection_mMap = ~cellfun('isempty',strfind(namesModel,'meanMap'));
    struct_meanfile = filesModel(selection_mMap);
    meanFile = fullfile(pRF_dir,struct_meanfile.name);
    drawnow;
    A = load(meanFile); 


    ROI_name = string(ROI_choice);
    switch ROI_name
        case {'V1'}
            ROIFiles = fullfile(Graydir,'ROIs/V1.mat');%'Gray/ROIs/V1.mat';
        case {'V2'}
            ROIFiles = fullfile(Graydir,'ROIs/V2.mat');%'Gray/ROIs/V2.mat';
        case {'V3'}
            ROIFiles = fullfile(Graydir,'ROIs/V3.mat');%'Gray/ROIs/V3.mat';
    end
    load(ROIFiles);

    %[coords_mean, indices_mean] = intersect(VOLUME{1}.coords', ROI.coords', 'rows' );% find the indices of the voxels from the ROI intersecting with all the voxels
    [coords_mean, indices_mean] = intersect(coords', ROI.coords', 'rows' );% find the indices of the voxels from the ROI intersecting with all the voxels
    mean_Map = A.map{1}(1,indices_mean);

    Condition = lower(cell2mat(pRF_folders(i)));
    switch Condition
        case {'prf_all'}
            parametersData = parametersData_all;
        case {'prf_nat'}
            parametersData = parametersData_nat;
        case {'prf_scram'}
            parametersData = parametersData_scram
    end;
%     parametersData = GetInfoModel(rmFile,coordsFile,ROIFiles);
    
    Var_Exp_Thr = 0.40; 
    Ecc_Thr = 4;
    Ecc_Thr_low = 0.5;
    Mean_map_Thr = 1000;

%     index_thr = modelData.Variance_Explained > Var_Exp_Thr & modelData.Eccentricity < Ecc_Thr & modelData.Eccentricity > Ecc_Thr_low & modelData.Meanmap > Mean_map_Thr;
    if ALL_INCL
        index_thr = modelData_all.Variance_Explained > Var_Exp_Thr & modelData_all.Eccentricity < Ecc_Thr & modelData_all.Eccentricity > Ecc_Thr_low & modelData_all.Meanmap > Mean_map_Thr & ...
        modelData_scram.Variance_Explained > Var_Exp_Thr & modelData_scram.Eccentricity < Ecc_Thr & modelData_scram.Eccentricity > Ecc_Thr_low & modelData_scram.Meanmap > Mean_map_Thr & ...
        modelData_nat.Variance_Explained > Var_Exp_Thr & modelData_nat.Eccentricity < Ecc_Thr & modelData_nat.Eccentricity > Ecc_Thr_low & modelData_nat.Meanmap > Mean_map_Thr;
    else
       index_thr = modelData_scram.Variance_Explained > Var_Exp_Thr & modelData_scram.Eccentricity < Ecc_Thr & modelData_scram.Eccentricity > Ecc_Thr_low & modelData_scram.Meanmap > Mean_map_Thr & ...
       modelData_nat.Variance_Explained > Var_Exp_Thr & modelData_nat.Eccentricity < Ecc_Thr & modelData_nat.Eccentricity > Ecc_Thr_low & modelData_nat.Meanmap > Mean_map_Thr;
    end;

    
    %%create second loop to make use tresholded data for each condition
    parametersData_thr{1}.x = parametersData{1}.x(1,index_thr);
    parametersData_thr{1}.y = parametersData{1}.y(1,index_thr);
    parametersData_thr{1}.sigma = parametersData{1}.sigma(1,index_thr);
    parametersData_thr{1}.ecc = parametersData{1}.ecc(1,index_thr);
    parametersData_thr{1}.varexp = parametersData{1}.varexp(1,index_thr);
%     disp(length(parametersData_thr{1}.x));

    %%create second loop to make use tresholded data for each condition AND
    %%store in seperately named variable. This is the lazy solution necessary for the
    %%case 'xnatVSxscram'
    switch Condition
        case {'prf_all'}
            parametersData_thr_all{1}.x = parametersData{1}.x(1,index_thr);
            parametersData_thr_all{1}.y = parametersData{1}.y(1,index_thr);
            parametersData_thr_all{1}.sigma = parametersData{1}.sigma(1,index_thr);
            parametersData_thr_all{1}.ecc = parametersData{1}.ecc(1,index_thr);
            parametersData_thr_all{1}.varexp = parametersData{1}.varexp(1,index_thr);
        case {'prf_nat'}
            parametersData_thr_nat{1}.x = parametersData{1}.x(1,index_thr);
            parametersData_thr_nat{1}.y = parametersData{1}.y(1,index_thr);
            parametersData_thr_nat{1}.sigma = parametersData{1}.sigma(1,index_thr);
            parametersData_thr_nat{1}.ecc = parametersData{1}.ecc(1,index_thr);
            parametersData_thr_nat{1}.varexp = parametersData{1}.varexp(1,index_thr);
        case {'prf_scram'}
            parametersData_thr_scram{1}.x = parametersData{1}.x(1,index_thr);
            parametersData_thr_scram{1}.y = parametersData{1}.y(1,index_thr);
            parametersData_thr_scram{1}.sigma = parametersData{1}.sigma(1,index_thr);
            parametersData_thr_scram{1}.ecc = parametersData{1}.ecc(1,index_thr);
            parametersData_thr_scram{1}.varexp = parametersData{1}.varexp(1,index_thr);
    end    

    %%
    %Plot
    
    %Define what you want to plot versus each other to select right
    %parameters by defining 'plot_choice'  in the beginning of the script
    par_name = string(plot_choice);
    switch par_name
        case {'sigmaVSeccentricity'}
            roi.p = linreg(parametersData_thr{1}.ecc,parametersData_thr{1}.sigma,parametersData_thr{1}.varexp);
            B = bootstrp(1000,@(x) localfit(x,parametersData_thr{1}.ecc,parametersData_thr{1}.sigma,parametersData_thr{1}.varexp),(1:numel(parametersData_thr{1}.ecc)));
        case {'xVSy'}
            roi.p = linreg(parametersData_thr{1}.x,parametersData_thr{1}.y,parametersData_thr{1}.varexp);
            B = bootstrp(1000,@(x) localfit(x,parametersData_thr{1}.x,parametersData_thr{1}.y,parametersData_thr{1}.varexp),(1:numel(parametersData_thr{1}.x)));
        case {'xnatVSxscram'}
            if exist('parametersData_thr_scram')
                roi.p = linreg(parametersData_thr_nat{1}.x,parametersData_thr_scram{1}.x,parametersData_thr{1}.varexp);
                B = bootstrp(1000,@(x) localfit(x,parametersData_thr_nat{1}.x,parametersData_thr_scram{1}.x,parametersData_thr{1}.varexp),(1:numel(parametersData_thr_nat{1}.x)));
                worked = 'succes';
            else
                roi.p = linreg(parametersData_thr{1}.x,parametersData_thr{1}.y,parametersData_thr{1}.varexp);
                B = bootstrp(1000,@(x) localfit(x,parametersData_thr{1}.x,parametersData_thr{1}.y,parametersData_thr{1}.varexp),(1:numel(parametersData_thr{1}.x)));
            end;
        case {'ynatVSyscram'}
            if exist('parametersData_thr_scram')
                roi.p = linreg(parametersData_thr_nat{1}.y,parametersData_thr_scram{1}.y,parametersData_thr{1}.varexp);
                B = bootstrp(1000,@(x) localfit(x,parametersData_thr_nat{1}.y,parametersData_thr_scram{1}.y,parametersData_thr{1}.varexp),(1:numel(parametersData_thr_nat{1}.y)));
                worked = 'succes';
            else
                roi.p = linreg(parametersData_thr{1}.x,parametersData_thr{1}.y,parametersData_thr{1}.varexp);
                B = bootstrp(1000,@(x) localfit(x,parametersData_thr{1}.x,parametersData_thr{1}.y,parametersData_thr{1}.varexp),(1:numel(parametersData_thr{1}.x)));
            end;
    end;
    
    
%     roi.p = linreg(parametersData_thr{1}.ecc,parametersData_thr{1}.sigma,parametersData_thr{1}.varexp);
    roi.p = flipud(roi.p(:)); % switch to polyval format
    xfit = [Ecc_Thr_low Ecc_Thr];
    yfit = polyval(roi.p,xfit);

    % bootstrap confidence intervals
    %if exist('bootstrp','file') 
%     B = bootstrp(1000,@(x) localfit(x,parametersData_thr{1}.ecc,parametersData_thr{1}.sigma,parametersData_thr{1}.varexp),(1:numel(parametersData_thr{1}.ecc)));
    B = B';
    pct1 = 100*0.05/2;
    pct2 = 100-pct1;
    b_lower = prctile(B',pct1);
    b_upper = prctile(B',pct2);
    keep1 = B(1,:)>b_lower(1) &  B(1,:)<b_upper(1);
    keep2 = B(2,:)>b_lower(2) &  B(2,:)<b_upper(2);
    keep = keep1 & keep2;
    b_xfit = linspace(min(xfit),max(xfit),100)';
    fits = [ones(100,1) b_xfit]*B(:,keep);
    b_upper = max(fits,[],2);
    b_lower = min(fits,[],2);
    %end



    % Bin the data and fit
    % bin size (eccentricity range) of the data
    binsize = 1;
    data.x    = (Ecc_Thr_low:binsize:Ecc_Thr)';
    
    
    par_name = string(plot_choice);
    switch par_name
        case {'sigmaVSeccentricity'}
            % plot averaged data
            data.fig(2) = figure(2); hold on;
            for b=Ecc_Thr_low:binsize:Ecc_Thr
                bii = parametersData_thr{1}.ecc >  b-binsize./2 & ...
                    parametersData_thr{1}.ecc <= b+binsize./2;
                if any(bii),
                    % weighted mean of sigma
                    s = wstat(parametersData_thr{1}.sigma(bii),parametersData_thr{1}.varexp(bii));
                    % store
                    ii2 = find(data.x==b);
                    data.y(ii2) = s.mean;
                    data.ysterr(ii2) = s.sterr;

                else
                    fprintf(1,'[%s]:Warning:No data in eccentricities %.1f to %.1f.\n',...
                        mfilename,b-binsize./2,b+binsize./2);
                end;
                labels = [ylabel('pRF size (sigma, deg)');xlabel('Eccentricity (deg)')];
                par_axis = [xaxislim(1) xaxislim(2) yaxislim(1) yaxislim(2)];
            end;
            want_plots = true;
            
        case {'xVSy'}
            % plot averaged data
            data.fig(2) = figure('Color', 'w'); hold on;
            for b=Ecc_Thr_low:binsize:Ecc_Thr
                bii = parametersData_thr{1}.x >  b-binsize./2 & ...
                    parametersData_thr{1}.x <= b+binsize./2;
                if any(bii),
                    % weighted mean of y
                    s = wstat(parametersData_thr{1}.y(bii),parametersData_thr{1}.varexp(bii));
                    % store
                    ii2 = find(data.x==b);
                    data.y(ii2) = s.mean;
                    data.ysterr(ii2) = s.sterr;

                else
                    fprintf(1,'[%s]:Warning:No data in x-values %.1f to %.1f.\n',...
                        mfilename,b-binsize./2,b+binsize./2);
                end;
                labels = [ylabel('x values'); xlabel('y values')];
                par_axis = [0 5 -1 1];
            end;
            want_plots = true;
            
        case {'xnatVSxscram'}
            % plot averaged data NOTE: will plot case 'xVSy' untill
            % condition scram is loaded.
            data.fig(2) = figure('Color', 'w'); hold on;
            if exist('parametersData_thr_scram')
                for b=Ecc_Thr_low:binsize:Ecc_Thr
                    bii = parametersData_thr_nat{1}.x >  b-binsize./2 & ...
                        parametersData_thr_nat{1}.x <= b+binsize./2;
                    if any(bii),
                        % weighted mean of x scram
                        s = wstat(parametersData_thr_scram{1}.x(bii),parametersData_thr_scram{1}.varexp(bii));
                        % store
                        ii2 = find(data.x==b);
                        data.y(ii2) = s.mean;
                        data.ysterr(ii2) = s.sterr;

                    else
                        fprintf(1,'[%s]:Warning:No data in x-values %.1f to %.1f.\n',...
                            mfilename,b-binsize./2,b+binsize./2);
                    end;
                    labels = [ylabel('xnat'); xlabel('xscram')];
                    par_axis = [0 5 0 5];
                    want_plots = true;
                end;
            else
                continue
            end;
            
        case{'ynatVSyscram'}
            if exist('parametersData_thr_scram')
                data.fig(2) = figure('Color', 'w'); hold on;
                for b=Ecc_Thr_low:binsize:Ecc_Thr
                    bii = parametersData_thr_nat{1}.y >  b-binsize./2 & ...
                        parametersData_thr_nat{1}.y <= b+binsize./2;
                    if any(bii),
                        % weighted mean of x scram
                        s = wstat(parametersData_thr_scram{1}.y(bii),parametersData_thr_scram{1}.varexp(bii));
                        % store
                        ii2 = find(data.x==b);
                        data.y(ii2) = s.mean;
                        data.ysterr(ii2) = s.sterr;

                    else
                        fprintf(1,'[%s]:Warning:No data in y-values %.1f to %.1f.\n',...
                            mfilename,b-binsize./2,b+binsize./2);
                    end;
                    labels = [ylabel('ynat'); xlabel('yscram')];
                    par_axis = [0 4 0 4];
                    want_plots = true;
                end;
            else
                continue
            end;
    end



    if want_plots == true
        %plot the different conditions all differently (in the same figure)
        if ~isempty(strfind(lower(rmFile),'prf_all')) && ALL_INCL
            titleName = 'all';
            yfit = polyval(roi.p,xfit);
            h1 = plot(xfit,yfit','k');
            set(h1,'LineWidth',2);
            titleall = sprintf('%s: y=%.2fx+%.2f , %s %s', titleName, roi.p(1), roi.p(2), ROI_name, sub), ...
                'FontSize', 24, 'Interpreter', 'none' ;
            title(titleall);
            if exist('bootstrp','file')
                plot(b_xfit,b_upper,'k--');
                plot(b_xfit,b_lower,'k--');
            end
            legend('pRF_all')
    %         ylabel('pRF size (sigma, deg)');xlabel('Eccentricity (deg)');
            ylabel(labels(1).String); xlabel(labels(2).String);
    %         h=axis;
            axis([par_axis(1) par_axis(2) par_axis(3) par_axis(4)]);

            hold on;
            errorbar(data.x,data.y,data.ysterr,'ko',...
                'MarkerFaceColor','k',...
                'MarkerSize',MarkerSize);

        elseif ~isempty(strfind(lower(rmFile),'prf_nat'))
                                
            
            titleName = 'nat';
            yfit = polyval(roi.p,xfit);
            h2 = plot(xfit,yfit','b');
            set(h2,'LineWidth',2);
            titlenat = sprintf('%s: y=%.2fx+%.2f , %s %s', titleName, roi.p(1), roi.p(2), ROI_name, sub),...
                'FontSize', 24, 'Interpreter', 'none' ;
            title(titlenat);
            if exist('bootstrp','file')
                plot(b_xfit,b_upper,'b--');
                plot(b_xfit,b_lower,'b--');
            end
            legend(h2, 'pRF nat')
    %         ylabel('pRF size (sigma, deg)');xlabel('Eccentricity (deg)');
            ylabel(labels(1).String); xlabel(labels(2).String);
    %         h=axis;
            axis([par_axis(1) par_axis(2) par_axis(3) par_axis(4)]);

            hold on;
            errorbar(data.x,data.y,data.ysterr,'bo',...
                'MarkerFaceColor','b',...
                'MarkerSize',MarkerSize);

        elseif ~isempty(strfind(lower(rmFile),'prf_scram'))
            titleName = 'scram';
            yfit = polyval(roi.p,xfit);
            h3 = plot(xfit,yfit','g');
            set(h3,'LineWidth',2);
            if exist('titlenat')
                titlescram = sprintf('%s: y=%.2fx+%.2f ,%s %s', titleName, roi.p(1), roi.p(2), ROI_name, sub), ...
                'FontSize', 24, 'Interpreter', 'none' ;
                if ~ALL_INCL
                    title({titlenat;titlescram});
                    legend([h2 h3], {'pRF nat', 'pRF scram'});
                else
                    title({titleall; titlenat;titlescram});
                    legend([h1 h2 h3], {'pRF all', 'pRF nat', 'pRF scram'});
                end
            else
                title( sprintf('%s: y=%.2fx+%.2f', titleName, roi.p(1), roi.p(2)), ...
                'FontSize', 24, 'Interpreter', 'none' );
                legend('pRF scram');
            end
            if exist('bootstrp','file')
                plot(b_xfit,b_upper,'g--');
                plot(b_xfit,b_lower,'g--');
            end
    %         ylabel('pRF size (sigma, deg)');xlabel('Eccentricity (deg)');
            ylabel(labels(1).String); xlabel(labels(2).String);
    %         h=axis;
            axis([par_axis(1) par_axis(2) par_axis(3) par_axis(4)]);


            hold on;
            errorbar(data.x,data.y,data.ysterr,'go',...
                'MarkerFaceColor','g',...
                'MarkerSize',MarkerSize);
        end
        filename = strcat(save_dir, '/', sub, 'plot', ROI_choice, '.png');
        saveas(gcf, filename);
    end;
end

clearvars -except ROI_choice_all subdir;
close all;
end