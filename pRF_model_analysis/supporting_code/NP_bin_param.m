function [data,b_upper_plot,b_lower_plot,b_xfit,b_y] = NP_bin_param(x_param,y_param,w,xfit,opt)
% NP_bin_param - To divide the dependent pRF parameter into different bins and calculate the mean of the 
% independent pRF parameter in the bins.
%
%

if ~exist('w','var') || isempty(w)
    w = ones(size(x_param));
end

x_Thr_low = xfit(1);
x_Thr = xfit(2);

%% Binning can be done either with equal intervals or with equal number of items in each bin (~ 20 bins)
% Divide the data into bins with required bin size and calculate the
% mean values of the parameter in the bin

x_bin = struct();
y_bin = struct();
w_bin = struct();
switch opt.binType
    %----- Binning with equal intervals -----%
    case {'Eq_interval'}
        fprintf('binning with %s',opt.binType);
        
        binsize = 0.5;
        x_ecc = (x_Thr_low:binsize:x_Thr)';
        i=1;
        bin_idx = nan(size(x_param));
        for b=x_Thr_low:binsize:x_Thr
            bii = x_param >  b-binsize./2 & x_param <= b+binsize./2;
            if any(bii),
                % weighted mean of sigma
                s = wstat(y_param(bii),w(bii));
                % store
                ii2 = find(x_ecc==b);
                data.y(ii2) = s.mean;
                data.ysterr(ii2) = s.sterr;
                data.x(ii2) = x_ecc(ii2);
                
                bin_idx(bii) = b;
                % values inside the bins
                y_bin(i).data = y_param(bii);
                x_bin(i).data = x_param(bii);
                w_bin(i).data = w(bii);
                i=i+1;
            else
                fprintf(1,'[%s]:Warning:No data in eccentricities %.1f to %.1f.\n',...
                    mfilename,b-binsize./2,b+binsize./2);
            end
            
        end
        
    case {'Eq_size'}
        % ----- Binning with equal percentile of data in each bin ----- %
        
       num_bin = 20;
       bins = ceil(num_bin*floor(tiedrank(x_param))./length(x_param));
    
        c=0;
        for idx_bin = 1:num_bin
            
            bii = (bins==idx_bin);
            
            x_bin(idx_bin).data = x_param(bins==idx_bin);
            y_bin(idx_bin).data = y_param(bins==idx_bin);
            w_bin(idx_bin).data = w(bins==idx_bin);
            
            numItems_bin = sum(bii);
            
            if numItems_bin
                % weighted mean of sigma
                s = wstat(y_param(bii),w(bii));
                % store
                data.y(idx_bin) = s.mean;
                data.ysterr(idx_bin) = s.sterr;
                data.x(idx_bin) = mean(x_bin(idx_bin).data(:));
            else
                data.x(idx_bin) = mean(x_bin(idx_bin).data(:));
                c = c+1;
            end
        end
        
        if c>0
            idx_zero         = find(data.y==0);
            data.y(idx_zero) = mean([data.y(idx_zero-1),data.y(idx_zero+1)],2); % if there
            data.y_sterr(idx_zero) = mean([data.y_sterr(idx_zero-1),data.y_sterr(idx_zero+1)],2); % if there
        end
        
end
%%

boottype='bin';
% Bootstrap the data  and calculate the error margins
if strcmp(boottype,'bin')
    x_data = x_bin;
    y_data = y_bin;
    w_data = w_bin;
    B = bootstrp(1000,@(x) localfit(x,x_data,y_data,w_data),(1:numel(x_data)));
elseif strcmp(boottype,'all')
    B = bootstrp(1000,@(x) localfit(x,x_param,y_param,w),(1:numel(x_param)));
end

B = B';

% Upper and lower bounds (calculated as the 2.5 percentile and 97.5 percentile of the values)
pct1 = 100*0.05/2;
pct2 = 100-pct1;
b_lower = prctile(B',pct1);
b_upper = prctile(B',pct2);

% Select the values within 2.5 and 97.25 percentile for calculating
% the mean
keep1 = B(1,:)>b_lower(1) &  B(1,:)<b_upper(1);
keep2 = B(2,:)>b_lower(2) &  B(2,:)<b_upper(2);
keep = keep1 & keep2;

% make the x axis values for plotting the fit line as linearly spaced values from minimum to maximum x axis values
%b_xfit = linspace(min(xfit),max(xfit),100)';
b_xfit = data.x;

% 100 values for plotting the upper (97.5) and lower bounds (2.5) of the
% bootstrapped data
fits = [ones(size(b_xfit,2),1) b_xfit'] * B(:,keep);
b_y = median(fits,2);
b_upper_plot = max(fits,[],2);
b_lower_plot = min(fits,[],2);

end