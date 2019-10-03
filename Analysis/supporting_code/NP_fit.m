function [yfit,roi] = NP_fit(x,y,w,xfit)
% Do a linear regression of the two parameters weighted with the variance explained
if isempty(w)
    w = ones(size(y));
end

roi.p  = linreg(x,y,w);
roi.p = flipud(roi.p(:)); % switch to polyval format

yfit = polyval(roi.p,xfit); % %xfit_tmp = linspace(xfit_range(1),xfit_range(2),8)'; xfit_range = [ecc_thr_low ecc_thr_high]

end
