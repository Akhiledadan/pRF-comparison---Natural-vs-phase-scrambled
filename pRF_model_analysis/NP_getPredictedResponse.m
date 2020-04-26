function prediction = NP_getPredictedResponse(stim,model,data,params)
% NP_getPredictedResponse - calculate predicted response for every voxel
% from the given roi and condition
%
% input : stim  - stimulus parameters
%         model - model parameters - should have sigma, x,y and beta 
% output: pred  - predicted reponse (eg: 240 x #voxels timeseries)
%
% Author: Akhil Edadan <a.edadan@uu.nl>, 2019

[X,Y]  = meshgrid(-stim.stimSize:0.1:stim.stimSize);
sigma  = model.sigma;
theta  = 0;
x      = model.x;
y      = model.y;

%% make predictions for each RF
numVox = size(model.sigma,2);
for voxel = 1:numVox
    
    gauss                   = rfGaussian2d(X,Y,sigma(voxel),sigma(voxel),theta,x(voxel),y(voxel)); % make the gaussian from the model
    
    gauss                   = gauss(:);
    RFs                     = gauss(stim.stimwindow,:);
    
    pred                    = params.analysis.allstimimages * RFs; % params.analysis.allstimimages is already convolved with HRF
    
    [trends, ntrends, dcid] = rmMakeTrends(params, 0);
    
    beta                    = pinv([pred trends(:,dcid)])*data.tSeries(:,voxel); % recomputing the beta values
    beta(1)                 = max(beta(1),0);
    
    % Calculate the prediction
    prediction(:,voxel) = [pred trends(:,dcid)] * beta;
    
end


end