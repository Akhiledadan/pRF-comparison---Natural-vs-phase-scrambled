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
gauss  = rfGaussian2d(X,Y,sigma,sigma,theta,x,y); % make the gaussian from the model
beta   = model.beta;
betaDC = model.betaDC;

beta_all = [beta betaDC'];

% first scale all the pRFs with their betas and then convolve it with the
% stimulus
old = 0;
if old
    pRFs         = gauss(stim.stimwindow,:);
    pred_1       = pRFs' * stim.images;
    
    
    % Calculate the prediction
    trends     = ones(size(pred,2),1);
    numVox     = size(pred,1);
    prediction = nan(size(pred));
    for vox = 1:numVox
        pred         = conv(pred_1(vox,:),model.HRF{1});
        prediction(vox,:) = [pred(vox,:)' trends(:,1)] * beta_all(vox,:)';
    end
end

% pRFs         = gauss(stim.stimwindow,:);
% scaledPrfs   = repmat(beta', [size(pRFs, 1) 1]) .* pRFs;
% pred         = (scaledPrfs' * stim.images) + repmat(betaDC', [1 size(stim.images, 2)]);

% save the predicted responses for loading later
%pred   = (gauss(stim.stimwindow,:)' * stim.images) .* repmat(beta', [size(pRFs, 1) 1]);




%% make predictions for each RF
numVox = size(model.sigma,2);
for voxel = 1:numVox
    
    gauss                   = rfGaussian2d(X,Y,sigma(voxel),sigma(voxel),theta,x(voxel),y(voxel)); % make the gaussian from the model
    
    gauss                   = gauss(:);
    RFs                     = gauss(stim.stimwindow,:);
    
    pred                    = params.analysis.allstimimages * RFs; % params.analysis.allstimimages is already convolved with HRF
    
    [trends, ntrends, dcid] = rmMakeTrends(params, 0);
    
    beta                    = pinv([pred trends(:,dcid)])*data.timeSeries_rois_thr{1}.tSeries(:,voxel); % recomputing the beta values
    beta(1)                 = max(beta(1),0);
    
    % Calculate the prediction
    prediction(:,voxel) = [pred trends(:,dcid)] * beta;
    
end


end