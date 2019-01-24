function [yfit,xfit_tmp] = NP_fit(x,y,w,xfit)
% Do a linear regression of the two parameters weighted with the variance explained

roi.p  = linreg(x,y,w);
roi.p = flipud(roi.p(:)); % switch to polyval format
xfit_tmp = linspace(xfit(1),xfit(2),8)';
yfit = polyval(roi.p,xfit_tmp); % xfit = [ecc_thr_low ecc_thr_high]

end