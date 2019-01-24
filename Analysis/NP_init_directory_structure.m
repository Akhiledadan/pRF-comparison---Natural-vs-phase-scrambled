function NP_init_directory_structure
% Not intended to be called by the user
% Function that creates the NP folder structure.

main_dir = pwd;

get_dir_for = {
    'Anatomy'
    'Functionals'
    'Stimuli'
    'Results'
    };


for n = 1:length(get_dir_for)
    
    
    make_dir = fullfile(main_dir,get_dir_for{n});
    
    mkdir(make_dir);
    
    
end
    
end