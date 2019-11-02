function pred = NP_getPredictedResponse(stim,model)
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

% first scale all the pRFs with their betas and then convolve it with the
% stimulus
pRFs         = gauss(stim.stimwindow,:);
scaledPrfs   = repmat(beta', [size(pRFs, 1) 1]) .* pRFs;
pred         = (scaledPrfs' * stim.images) + repmat(betaDC', [1 size(stim.images, 2)]);

% save the predicted responses for loading later
%pred   = (gauss(stim.stimwindow,:)' * stim.images) .* repmat(beta', [size(pRFs, 1) 1]);

end