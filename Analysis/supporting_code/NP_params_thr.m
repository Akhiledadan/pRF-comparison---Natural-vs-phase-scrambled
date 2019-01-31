function model_data_thr =  NP_params_thr(model_data,thr_index)
% NP_params_thr - function to obtain the thresholed pRF parameters 
% Run after - model_data = GetInfoModel(model_file,coords_file,roi_file) 
%

model_data_thr.HRF = model_data.HRF;
model_data_thr.sigma = model_data.sigma(thr_index);
model_data_thr.sigma_norm = model_data_thr.sigma ./ (mean(model_data_thr.sigma,2));
model_data_thr.ecc = model_data.ecc(thr_index);
model_data_thr.latx = model_data.latx(thr_index);
model_data_thr.laty = model_data.laty(thr_index);
model_data_thr.beta = model_data.beta(thr_index);
model_data_thr.varexp = model_data.varexp(thr_index);
model_data_thr.rss = model_data.rss(thr_index);
model_data_thr.pol = model_data.pol(thr_index);
model_data_thr.x = model_data.x(thr_index);
model_data_thr.y = model_data.y(thr_index);
model_data_thr.dc = model_data.dc(thr_index);
model_data_thr.posvol = model_data.posvol(thr_index);


end