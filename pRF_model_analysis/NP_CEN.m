function [cenVal_1,cenVal_2,cenVal_diff,cenVal_relDiff] = NP_CEN(params_comp)
% NP_CEN -  to calculate the central values from the pRF size vs
% eccentricity fit

x = 2.5; 
% for natural condition
M_1           = params_comp.bin.fitStats_1.p(1);
C_1           = params_comp.bin.fitStats_1.p(2);

cenVal_1      =  M_1 .* x + C_1; 

% for phase scrambled condition 
M_2           = params_comp.bin.fitStats_2.p(1);
C_2           = params_comp.bin.fitStats_2.p(2);

cenVal_2      =  M_2 .* x + C_2;

% difference 
cenVal_diff   = cenVal_1-cenVal_2;

% relative difference - to account for the increase in pRF size with visual
% areas and the resulting decrease in precision in percentage
cenVal_relDiff= (cenVal_diff./(mean([cenVal_1,cenVal_2])))*100 ;

end