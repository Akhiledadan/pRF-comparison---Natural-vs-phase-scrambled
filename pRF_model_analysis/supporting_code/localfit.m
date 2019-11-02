function B=localfit(ii,x,y,ve)
if isstruct(x) || isstruct(y) || istruct(ve) 
    x_b = []; y_b = []; ve_b = [];
    for idx = 1:length(ii)
        x_b = [x_b x(ii(idx)).data];
        y_b = [y_b y(ii(idx)).data];
        ve_b = [ve_b ve(ii(idx)).data];
    end
    B = linreg(x_b,y_b,ve_b);
else
    B = linreg(x(ii),y(ii),ve(ii));
end
    
%B = linreg(x(ii),y(ii),ve(ii));
B(:);
return