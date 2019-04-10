function model = rmGridFit_twoGaussiansDoGSigmasOnly(model,data,params,wProcess,t)
% rmSearchFit_twoGaussiansDoG - wrapper for 'fine' two DoG Gaussian fit
%
% model = rmSearchFit_twoGaussiansDoG(model,prediction,data,params);
%
% Second gaussian negative only. 
%
% 2008/01 SOD: split of from rmSearchFit.
% 2019/04 AE: Modified from rmSearchFit_twoGaussiansDoGSigmasOnly.

% fminsearch options
searchOptions = params.analysis.fmins.options;
vethresh      = params.analysis.fmins.vethresh;

% convert to double just in case
params.analysis.X = double(params.analysis.X);
params.analysis.Y = double(params.analysis.Y);
params.analysis.allstimimages = double(params.analysis.allstimimages);


% Set the search space for sigma1 and sigma2
% This can be obtained from the lower and upper range values from
% rmSearchFit_range.m

% get starting upper and lower range and reset TolFun 
% (raw rss computation (similar to norm) and TolFun adjustments)
[range,TolFun] = rmSearchFit_range(params,model,data);

% Define the upper and lower values of the sigma1 and sigma2 to create the
% search space.
s1.min = min(range.lower(3,:));
s1.max = min(range.upper(3,:));
s2.min = min(range.lower(4,:));
s2.max = min(range.upper(4,:));
nSigmas = 24;

% Create the grid 
s1.sigmaValues = linspace(s1.min,s1.max,nSigmas); % For positive gaussian 
s2.sigmaValues = linspace(s2.min,s2.max,nSigmas); % For negative gaussian

% Set the min RSS for every voxel to be the RSS value obtained from the all
% fit. If the RSS is above for the best fitting voxel, retain this value
minrss = model.rss;

% amount of negative fits
nNegFit  = 0;
trends   = t.trends;
t_id     = t.dcid+2;
rssinf   = inf(size(data(1,:)),'single');

% initialize
if ~isfield(model,'rss2')
    model.rss2 = zeros(size(model.rss));
end

if ~isfield(model,'rssPos')
    model.rsspos = zeros(size(model.rss));
end

if ~isfield(model,'rssNeg')
    model.rssneg = zeros(size(model.rss));
end

%-----------------------------------
% Go for each voxel
%-----------------------------------
progress = 0;tic;
for ii = 1:numel(wProcess),

    % progress monitor (10 dots)
    if floor(ii./numel(wProcess)*10)>progress,
        % print out estimated time left
        if progress==0,
            esttime = toc.*10;
            if floor(esttime./3600)>0,
                fprintf(1,'[%s]:Estimated processing time: %d voxels: %d hours.\n',...
                    mfilename,numel(wProcess),ceil(esttime./3600));
            else
                fprintf(1,'[%s]:Estimated processing time: %d voxels: %d minutes.\n',...
                    mfilename,numel(wProcess),ceil(esttime./60));
            end;
            fprintf(1,'[%s]:Nonlinear optimization (x,y,sigma):',mfilename);
        end;
        fprintf(1,'.');drawnow;
        progress = progress + 1;
    end;

    % volume index
    vi = wProcess(ii);
    vData = double(data(:,ii));
    
    % reset tolFun: Precision of evaluation function. 
    % We define RMS improvement relative to the initial raw 'no-fit' data
    % RMS. So, 1 means stop if there is less than 1% improvement on the fit:
    searchOptions.TolFun = TolFun(ii);
    
    % compute part of the pRF computations related to position (x,y) here
    % for speed reasons
    Xv = params.analysis.X-range.start(1);
    Yv = params.analysis.Y-range.start(2);
    XvYv = (Yv.*Yv + Xv.*Xv);
    
    
    
    
    

for s1_idx = s1.sigmaValues
    for s2_idx = s2.sigmaValues
        [rss_iter,b] = rmModelGridFit_twoGaussiansDoGSigmasOnly([s1_idx,s2_idx],vData,XvYv,params.analysis.allstimimages,trends);
        
        if rss_iter < minrss(vi) & s2_idx >= 2 * s1_idx & b(1)>0 & b(1)>-b(2) & b(2)<=0
            model.s(vi)        = s1_idx;
            model.s_major(vi)        = s1_idx;
            model.s_minor(vi)        = s1_idx;
            %model.s_theta(vi)        = params.analysis.theta(vi);
            model.rss(vi)      = rss_iter;
            model.b([1:2 t_id],vi)    = b;
            model.s2(vi)       = s2_idx;
        end
    end
end
        

end;

% end time monitor
et  = toc;
if floor(et/3600)>0,
    fprintf(1,'Done [%d hours].\n',ceil(et/3600));
else
    fprintf(1,'Done [%d minutes].\n',ceil(et/60));
end;
fprintf(1,'[%s]:Removed negative fits: %d (%.1f%%).\n',...
    mfilename,nNegFit,nNegFit./numel(wProcess).*100);

return;

%-----------------------------------
% make sure that the pRF can only be moved "step" away from original
% poisiton "startParams"
% For the two Gaussian model we add the additional constraint that the
% second Gaussian is at least twice as large as the first.
function [C, Ceq]=distanceCon(x,minRatio)
Ceq = [];
C   = minRatio - 0.001 - x(2)./x(1);
return;
%-----------------------------------

