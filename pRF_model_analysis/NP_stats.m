function NP_stats(paramsToCompare,paramsToCompare_type,rois,stats_folder)
% NP_stats - repeated measures anova to compare auc or
% central values of pRF size between different conditions for same subject

% folder containing results
if ~exist('stats_folder','var')
    stats_folder = strcat('/mnt/storage_2/projects/Nat_PhScr/Data/All/results/2DGaussian_Ecc_Sig_',rois);
end

if ~exist('verbose','var')
    verbose = false;
end

% "absolute" - Used for the manuscript
if strcmpi(paramsToCompare_type,'absolute') % If the absolute values are used for ANOVA. Difference between the means/std of two distribution are compared
    
    if strcmpi(paramsToCompare,'central')
        filename_res = sprintf('central.mat');
        load(fullfile(stats_folder,filename_res));
        
    elseif strcmpi(paramsToCompare,'AUC')
        filename_res = sprintf('AUC.mat');
        load(fullfile(stats_folder,filename_res));
        
    end
    
    % "V123" - Used for the manuscript
    switch rois
        
        case 'V123LO'
            t = table(cen.nat(:,1),cen.nat(:,2),cen.nat(:,3),cen.nat(:,4),cen.scram(:,1),cen.scram(:,2),cen.scram(:,3),cen.scram(:,4),...
                'VariableNames',{'Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8'});
            within = table({'nat';'nat';'nat';'nat';'scram';'scram';'scram';'scram'},{'V1';'V2';'V3';'LO';'V1';'V2';'V3';'LO'},...
                'VariableNames',{'condition','roi'});
            rm = fitrm(t,'Y1-Y8~1','WithinDesign',within);
            ranova(rm, 'WithinModel','condition*roi')
            
        case 'V123LO12'
            t = table(cen.nat(:,1),cen.nat(:,2),cen.nat(:,3),cen.nat(:,4),cen.nat(:,5),cen.scram(:,1),cen.scram(:,2),cen.scram(:,3),cen.scram(:,4),cen.scram(:,5),...
                'VariableNames',{'Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10'});
            within = table({'nat';'nat';'nat';'nat';'nat';'scram';'scram';'scram';'scram';'scram'},{'V1';'V2';'V3';'LO1';'LO2';'V1';'V2';'V3';'LO1';'LO2';},...
                'VariableNames',{'condition','roi'});
            rm = fitrm(t,'Y1-Y10~1','WithinDesign',within);
            ranova(rm, 'WithinModel','condition*roi')
            
        case 'V123'
            t = table(cen.nat(:,1),cen.nat(:,2),cen.nat(:,3),cen.scram(:,1),cen.scram(:,2),cen.scram(:,3),'VariableNames',{'Y1','Y2','Y3','Y4','Y5','Y6'});
            within = table({'nat';'nat';'nat';'scram';'scram';'scram'},{'V1';'V2';'V3';'V1';'V2';'V3';},'VariableNames',{'condition','roi'});
            rm = fitrm(t,'Y1-Y6~1','WithinDesign',within);
            ranova(rm, 'WithinModel','condition*roi')
            
            checkRoiDifference = 1;
            if checkRoiDifference
                % V12
                fprintf('\n V12 \n');
                t = table(cen.nat(:,1),cen.nat(:,2),cen.scram(:,1),cen.scram(:,2),'VariableNames',{'Y1','Y2','Y3','Y4'});
                within = table({'nat';'nat';'scram';'scram'},{'V1';'V2';'V1';'V2'},'VariableNames',{'condition','roi'});
                rm = fitrm(t,'Y1-Y4~1','WithinDesign',within);
                ranova(rm, 'WithinModel','condition*roi')
                
                % V13
                fprintf('\n V13 \n');
                t = table(cen.nat(:,1),cen.nat(:,3),cen.scram(:,1),cen.scram(:,3),'VariableNames',{'Y1','Y2','Y3','Y4'});
                within = table({'nat';'nat';'scram';'scram'},{'V1';'V2';'V1';'V2'},'VariableNames',{'condition','roi'});
                rm = fitrm(t,'Y1-Y4~1','WithinDesign',within);
                ranova(rm, 'WithinModel','condition*roi')
                
                % V23
                fprintf('\n V23 \n');
                t = table(cen.nat(:,2),cen.nat(:,3),cen.scram(:,2),cen.scram(:,3),'VariableNames',{'Y1','Y2','Y3','Y4'});
                within = table({'nat';'nat';'scram';'scram'},{'V1';'V2';'V1';'V2'},'VariableNames',{'condition','roi'});
                rm = fitrm(t,'Y1-Y4~1','WithinDesign',within);
                ranova(rm, 'WithinModel','condition*roi')
                
                
                % V1 , V2 , V3
                fprintf('V1 \n');
                [~,p,~,stats]=ttest(cen.nat(:,1),cen.scram(:,1)) % V1
                fprintf('V2 \n');
                [~,p,~,stats]=ttest(cen.nat(:,2),cen.scram(:,2)) % V2
                fprintf('V3 \n');
                [~,p,~,stats]=ttest(cen.nat(:,3),cen.scram(:,3)) % V3
                
            end
    end
    
    
    
elseif strcmpi(paramsToCompare_type,'difference') % if the difference between the conditions are used for the ANOVA. Mean/std of the difference of the absolute values are compared
    
    if strcmpi(paramsToCompare,'central')
        filename_res = sprintf('central.mat');
        load(fullfile(stats_folder,filename_res));
        D=cenRelDiff;
        
    elseif strcmpi(paramsToCompare,'AUC')
        filename_res = sprintf('AUC.mat');
        load(fullfile(stats_folder,filename_res));
        D=auc;
        
    end
    
    
    switch rois
        
        case 'V123LO'
            t = table(D(:,1),D(:,2), D(:,3), D(:,4),D(:,5),'VariableNames',{'Y1','Y2','Y3','Y4','Y5'});
            within = table({'V1';'V2';'V3';'V3ab';'LO'},'VariableNames',{'roi'});
            rm = fitrm(t,'Y1-Y5~1','WithinDesign',within);
            ranova(rm, 'WithinModel','roi')
            plot(D','o-')
            
        case 'V123'
            % for V1, V2, V3 only:
            
            D=D(:,1:3);
            t = table(D(:,1),D(:,2), D(:,3),'VariableNames',{'Y1','Y2','Y3'});
            within = table({'V1';'V2';'V3'},'VariableNames',{'roi'});
            rm = fitrm(t,'Y1-Y3~1','WithinDesign',within);
            ranova(rm, 'WithinModel','roi')
            
            [~,p]=ttest(D(:,1),D(:,3)); % V1 vs V3
            
    end
    
    
end
end