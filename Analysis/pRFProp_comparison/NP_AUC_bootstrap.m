function [AUC_diff,AUC_upper,AUC_lower] = NP_AUC_bootstrap(x_param,y_param)
% AUCootstrap the mean values from all participants in each group and
% calculate the AUC 



w = ones(size(y_param));
%  figure(7),
AUC1 = bootstrp(1000,@(x) NP_areaUnderCurve(x,x_param(:,1),y_param(:,1),w(:,1)),(1:size(x_param(:,1),1)));
%  figure(8),
AUC2 = bootstrp(1000,@(x) NP_areaUnderCurve(x,x_param(:,2),y_param(:,2),w(:,2)),(1:size(x_param(:,2),1)));

AUC_diff = AUC1 - AUC2;

% Upper and lower AUCounds (calculated as the 2.5 percentile and 97.5 percentile of the values)
pct1 = 100*0.05/2;
pct2 = 100-pct1;
AUC_lower = prctile(AUC_diff,pct1);
AUC_upper = prctile(AUC_diff,pct2);

% Select the values within 2.5 and 97.25 percentile for calculating
% the mean
keep1 = AUC_diff(:,1)>AUC_lower(1) &  AUC_diff(:,1)<AUC_upper(1);
keep = keep1;

% 100 values for plotting the upper (97.5) and lower AUCounds (2.5) of the
% AUCootstrapped data
AUC_y = median(AUC_diff(keep,:),1);
AUC_upper = max(AUC_diff(keep,:),[],1);
AUC_lower = min(AUC_diff(keep,:),[],1);

end