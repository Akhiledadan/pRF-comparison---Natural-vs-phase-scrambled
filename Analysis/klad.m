% %Select the subject folder to use
% Graydir = uigetdir(pwd,'Select Gray directory');
% 
% files = dir(Graydir);
% dirFlags = [files.isdir];
% subfolders = files(dirFlags);
% names = {subfolders.name};
% selection = ~cellfun('isempty',strfind(names,'pRF'));
% pRF_folders = names(selection);
% 
% for i= 1:length(pRF_folders)
%     pRF_dir = cell2mat(fullfile(Graydir,pRF_folders(i)));
%     filesModel = dir(pRF_dir);
%     namesModel = {filesModel.name};
%     selection_fFit = ~cellfun('isempty',strfind(namesModel,'-fFit'));
%     rmfile = filesModel(selection_fFit);
%     
%     %meanFile = getPathStrDialog(pwd,title,'*.mat');
%     selection_mMap = ~cellfun('isempty',strfind(namesModel,'meanMap'));
%     meanfile = filesModel(selection_mMap);
% end
% 
%     Tresh_name = cell2mat(pRF_folders(i));
%     switch Tresh_name
%         case {'pRF_all'}
%             index_thr = modelData_all.Variance_Explained > Var_Exp_Thr & modelData_all.Eccentricity < Ecc_Thr & modelData_all.Eccentricity > Ecc_Thr_low & modelData_all.Meanmap > Mean_map_Thr;
%         case {'pRF_nat'}
%             index_thr = modelData_nat.Variance_Explained > Var_Exp_Thr & modelData_nat.Eccentricity < Ecc_Thr & modelData_nat.Eccentricity > Ecc_Thr_low & modelData_nat.Meanmap > Mean_map_Thr;
%         case {'pRF_scram'}
%             if ALL_INCL
%                 index_thr = modelData_all.Variance_Explained > Var_Exp_Thr & modelData_all.Eccentricity < Ecc_Thr & modelData_all.Eccentricity > Ecc_Thr_low & modelData_all.Meanmap > Mean_map_Thr & ...
%                 modelData_scram.Variance_Explained > Var_Exp_Thr & modelData_scram.Eccentricity < Ecc_Thr & modelData_scram.Eccentricity > Ecc_Thr_low & modelData_scram.Meanmap > Mean_map_Thr & ...
%                 modelData_nat.Variance_Explained > Var_Exp_Thr & modelData_nat.Eccentricity < Ecc_Thr & modelData_nat.Eccentricity > Ecc_Thr_low & modelData_nat.Meanmap > Mean_map_Thr;
%             else
%                index_thr = modelData_scram.Variance_Explained > Var_Exp_Thr & modelData_scram.Eccentricity < Ecc_Thr & modelData_scram.Eccentricity > Ecc_Thr_low & modelData_scram.Meanmap > Mean_map_Thr & ...
%                modelData_nat.Variance_Explained > Var_Exp_Thr & modelData_nat.Eccentricity < Ecc_Thr & modelData_nat.Eccentricity > Ecc_Thr_low & modelData_nat.Meanmap > Mean_map_Thr;
%             end;
%     end;
%     

for i = 1:100
    a{i} = i;
    b{i} = i.*2;
    c{i} = i*3;
end

a= cell2mat(a);


%disp(a)
disp(length(a))
tres = 40

index1 = a < tres;
disp(length(a(index1)))
disp(length(b(index1)))

parametersData_thr_scram{1}.x = parametersData{1}.x(1,index_thr);
parametersData_thr_scram{1}.y = parametersData{1}.y(1,index_thr);
parametersData_thr_scram{1}.sigma = parametersData{1}.sigma(1,index_thr);
parametersData_thr_scram{1}.ecc = parametersData{1}.ecc(1,index_thr);
parametersData_thr_scram{1}.varexp = parametersData{1}.varexp(1,index_thr);
