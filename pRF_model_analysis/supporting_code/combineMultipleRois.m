function combineMultipleRois
% Function to combine multiple ROIs in mrVista (.mat) space for multiple subjects 
%
% written by Akhil Edadan (a.edadan@uu.nl) 

% list of subject folders
subjects = {'dlsubj003','dlsubj123','dlsubj127','dlsubj128','dlsubjDR','dlsubjEV','dlsubjJG','dlsubjLA','dlsubjLR','dlsubjLS'};

roisToCombine = {'LO'};
rois = [{'LO1','LO2'}];


for sub_idx = 1:length(subjects)

    subjID = subjects{sub_idx};
    fprintf('\n combining rois for subject: %s \n',subjID);
    
    dirPth = NP_loadPaths(subjID);
    
    dirPth.sub_sess_path = dirPth.mrvDirPth;
    dirPth.roi_path = dirPth.roiPth;
    dirPth.coords_path = dirPth.coordsPth;
    saveDir = dirPth.roi_path;
    
    load(fullfile(dirPth.coords_path,'coords.mat'));
    
    % Combine ROIs
    for rc = 1:length(roisToCombine)
        match = contains(rois,roisToCombine{rc});
        
        %matchIdx = find(match);
        
        matchIdx = 1:length(rois);
        tmpData = [];
        for ii = 1:length(matchIdx)
            load(fullfile(dirPth.roi_path, rois{matchIdx(ii)}));
            [~, indices] = intersect(coords', ROI.coords', 'rows' );
            tmpData = [tmpData; indices];
        end
        
        roiName{rc} = roisToCombine{rc};
        roiLoc{rc} = unique(tmpData, 'rows');
        roiCoords{rc} = coords(:,roiLoc{rc});
        
        ROI.coords = roiCoords{rc};
        ROI.name = roisToCombine{rc};
        save(fullfile(saveDir,roiName{rc}),'ROI');            
        
    end
    
end

end