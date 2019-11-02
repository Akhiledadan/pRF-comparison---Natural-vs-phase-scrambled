function h = errorbar_group(model_series,model_error)
% Plots errorbar on group bars
% Usage: errorbar_group(bar value,errorbar value)
%
%model_series = [10 40 50 60; 20 50 60 70; 30 60 80 90];
%model_error = [1 4 8 6; 2 5 9 12; 3 6 10 13];    
h = bar(model_series,'BarWidth',1);
clr = [0.5 1 0.5;0.5 0.5 1;1 0 0 ];
colormap(clr);
ngroups = size(model_series, 1);
nbars = size(model_series, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
hold on;
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none','LineWidth',5,'CapSize',10);
end
end