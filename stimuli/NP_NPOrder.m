% NP_NPOrder: Loads stimulus file and outputs whether natural or phase
% scrambled condition was presented and the corresponding fixation dot
% performance
%
% written by Akhil Edadan (a.edadan@uu.nl)

sub = dir(pwd);


for sub_idx = 3:length(sub)

cd (sub(sub_idx).name);    

fprintf('Subject %s \n', sub(sub_idx).name);

stim = dir(pwd);


for stim_idx = 3:length(stim)
    
   tmp  = load(fullfile(stim(stim_idx).folder,stim(stim_idx).name));
    
   fprintf('loading %s \t',stim(stim_idx).name)

   nat = tmp.params.NatVPhs; 
   pc  = tmp.pc;
   
   %[pc_recalculated,rc_recalculated] = getFixationPerformance(tmp.params.fix,tmp.stimulus,tmp.response);
   
   if nat == 1
       fprintf('natural \t\t %1.f \n',pc);
   else
       fprintf('phase scrambled \t %1.f \n',pc);
   end
       
   clear tmp;
end

cd ..

end


% Note1: for subjects: dlsubjEV, dlsubjDR and dlsubj128 
% stimulus files for the first run is MISSING
%
% Note2: Scanner start time for sub128 is 16:11 but the stimulus time is
% 16:45. Checked the scanner booking, It was from 15:30 to 17:00. So, I guess
% something went wrong in the beginning with scanner and we started
% scanning only at 16:45
%
% Note3: for subJG - fixation performance is 0 because the button box was
% not working properly.
%
%  




