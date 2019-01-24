function data = NP_central_val(x_param,y_fit,y_up,y_lo,xfit)


bii = xfit(2)./2;
bii_2 = find(abs(x_param - bii) == min(abs(x_param - bii)));
s = y_fit(bii_2);
s_up = y_up(bii_2);
s_lo = y_lo(bii_2);
% store
data.y = s;
data.up = s_up;
data.lo = s_lo;
data.x = bii;


end