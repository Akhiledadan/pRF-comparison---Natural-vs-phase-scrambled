% rmFiles = 'Gray/Averages_pRF/retModel-20160803-141902-fFit.mat';
% coordsFile = 'Gray/coords.mat';
% ROIFiles = 'Gray/ROIs/V1.mat';
 
% n = variance_explained(variance_explained>0.15);
% size(n)


function parametersData = GetInfoModel(rmFiles,coordsFile,ROIFiles)

rmFilesToCompare = rmFiles;

numOfM = length(rmFilesToCompare);


%% get data for both models
k = 1;
oneGaus = 0;

for i = 1
%for i = 1:numOfM
    %rmData = load(rmFilesToCompare{i}, 'model', 'params');
    rmData = load(rmFilesToCompare, 'model', 'params');
    
    if isequal(rmData.model{1}.description,'2D pRF fit (x,y,sigma, positive only)')         %check if there is a 1G model, for the split for the second treshold
        oneGaus = 1;
    end
    parametersData{i}.HRF = rmData.params.analysis.Hrf;
    parametersData{i}.sigma = rmGet(rmData.model{1}, 'sigma');
    parametersData{i}.ecc = rmGet(rmData.model{1}, 'ecc');
    parametersData{i}.latx = rmGet(rmData.model{1}, 'latx');
    parametersData{i}.laty = rmGet(rmData.model{1}, 'laty');
    parametersData{i}.beta = rmGet(rmData.model{1}, 'beta');
    parametersData{i}.betaDC = parametersData{i}.beta(1,:,2);
    parametersData{i}.varexp = rmGet(rmData.model{1}, 'varexp');
    parametersData{i}.rss = rmGet(rmData.model{1}, 'rss');
    parametersData{i}.pol = rmGet(rmData.model{1}, 'pol');
    parametersData{i}.x = rmGet(rmData.model{1}, 'x');
    parametersData{i}.y = rmGet(rmData.model{1}, 'y');
    parametersData{i}.dc = rmGet(rmData.model{1}, 'bcomp2');
    parametersData{i}.posvol = rmGet(rmData.model{1}, 'volume');
    if ~(isequal(rmData.model{1}.description,'2D pRF fit (x,y,sigma, positive only)'))
       %parametersData{i}.dc = rmGet(rmData.model{1}, 'bcomp3');
       parametersData{i}.sigma2 = rmGet(rmData.model{1}, 'sigma2');
       parametersData{i}.beta2 = rmGet(rmData.model{1}, 'bcomp2'); 
       parametersData{i}.dc = rmGet(rmData.model{1}, 'bcomp3');
       %parametersData{i}.si = rmGet(rmData.model{1},'allsistats','sts',6.25);
       %parametersData{i}.ss = rmGet(rmData.model{1},'surroundsize');
       
       %  parametersData{i}.totalvol = rmGet(rmData.model{1}, 'volume2');
%        parametersData{i}.varexp2 = rmGet(rmData.model{1}, 'varexp2');
%         parametersData{i}.sr = rmGet(rmData.model{1}, 'sr');
%         parametersData{i}.br = rmGet(rmData.model{1}, 'br');
%         parametersData{i}.rss2 = rmGet(rmData.model{1}, 'rss2');
%         parametersData{i}.vr = rmGet(rmData.model{1}, 'vr');
%         parametersData{i}.vr2 = rmGet(rmData.model{1}, 'vr2');
%        parametersData{i}.varexppos = rmGet(rmData.model{1}, 'varexppos');
%        parametersData{i}.varexpneg = rmGet(rmData.model{1}, 'varexpneg');
%         parametersData{i}.rssneg = rmGet(rmData.model{1}, 'rssneg');
%         parametersData{i}.rawrss = rmGet(rmData.model{1}, 'rawrss');
        
    end



c = load(coordsFile);   
allCrds = c.coords;
r = load(ROIFiles);
roi = r.ROI;




    % get data from ROI of all models
    [tmp, roi.iCrds] = intersectCols(allCrds,roi.coords);
    parameterNames = fieldnames(parametersData{i});
    %roiCoords = roi.iCrds;
    for j=2:numel(parameterNames)
        parameterName = parameterNames(j);
        data = getfield(parametersData{i},parameterName{1});
        if strcmp(parameterName,'si')
            dataROI = data(:,roi.iCrds);
        else
            dataROI = data(roi.iCrds);
        end
        parametersData{i} = setfield(parametersData{i}, parameterName{1}, dataROI);
        
    end


    
end


end
  
% parametersData = GetInfoModel(rmFiles,coordsFile,ROIFiles);
% Model_Info.Variance_Explained = parametersData{1,1}.varexp;
% Model_Info.Eccentricity = parametersData{1,1}.ecc;

