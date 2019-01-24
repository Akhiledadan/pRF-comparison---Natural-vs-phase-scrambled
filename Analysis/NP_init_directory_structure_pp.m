function NP_init_directory_structure_pp
% Function that creates the NP folder structure for preprocessing.

main_dir = pwd;

get_dir_for = {
    'Anatomy'
    'Functional'
    };

get_subdir_for = {
    'Functional/raw'
    'Functional/preprocessed'
    };

for n = 1:length(get_dir_for)
    
    
    make_dir = fullfile(main_dir,get_dir_for{n});
    
    mkdir(make_dir);
    
   
end
    

for n = 1:length(get_subdir_for)
    
    
    make_subdir = fullfile(main_dir,get_subdir_for{n});
    
    mkdir(make_subdir);
    
   
end

end
