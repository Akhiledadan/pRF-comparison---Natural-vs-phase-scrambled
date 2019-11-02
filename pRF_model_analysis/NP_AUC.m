function [AUC_diff] = NP_AUC(x_param,y_param)
% AUCootstrap the mean values from all participants in each group and
% calculate the AUC 

w = ones(size(y_param));
ii = 1:size(y_param,1);
%  figure(7),
AUC1 = NP_areaUnderCurve(ii,x_param(:,1),y_param(:,1),w(:,1));
AUC2 = NP_areaUnderCurve(ii,x_param(:,2),y_param(:,2),w(:,2));

AUC_diff = AUC1 - AUC2;

end