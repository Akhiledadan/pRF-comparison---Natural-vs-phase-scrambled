function auc = NP_areaUnderCurve(ii,x,y,ve)
% function that fits a line from the     
if isstruct(x) || isstruct(y) || isstruct(ve) 
    x_b = []; y_b = []; ve_b = [];
    for idx = 1:length(ii)
        x_b = [x_b x(ii(idx)).data];
        y_b = [y_b y(ii(idx)).data];
        ve_b = [ve_b ve(ii(idx)).data];
    end
    B = linreg(x_b,y_b,ve_b);
else
    B1 = linreg(x,y(ii,1),ve(ii,1));
 %   B2 = linreg(x(ii,2),y(ii,2),ve(ii,2));
end
    
B1(:);
yHat1 = [ones(size(x,1),1) x] * B1';
auc = trapz(x,yHat1);

end