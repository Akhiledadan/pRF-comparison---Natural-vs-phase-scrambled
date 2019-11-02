function latestmodel = getlatestmodel(models)
%This function returns the latest file from the directory passsed as input
%argument

%I contains the index to the biggest number which is the latest file
[A,I] = max([models(:).datenum]);

if ~isempty(I)
    latestmodel = models(I);
end

end