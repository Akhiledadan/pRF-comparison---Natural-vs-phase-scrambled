function dirPth = NP_loadPaths(subjID)

%% ----- General -----
dirPth  = struct();
dirPth.rootPth = NP_rootPath;
dirPth.subjID  = subjID;

%% ----- mrVista path -----
dirPth.mrvDirPth     = fullfile(NP_rootPath,'data',subjID,'vistaSession');
dirPth.roiPth        = fullfile(NP_rootPath,'data',subjID,'vistaSession','Anatomy','ROIs');
dirPth.modelPth      = fullfile(NP_rootPath,'data',subjID,'vistaSession','Gray');
dirPth.coordsPth     = fullfile(NP_rootPath,'data',subjID,'vistaSession','Gray');

%% ----- folder to save results (figures, data) ------

dirPth.saveDirFig     = fullfile(NP_rootPath,'data',subjID,'plots');
dirPth.saveDirRes     = fullfile(NP_rootPath,'data',subjID,'results');
dirPth.saveDirMSFig     = fullfile(NP_rootPath,'data',subjID,'MSFigs');


dirPth.saveDirSup1 = '/mnt/storage_2/projects/Nat_PhScr/MS/finalFig/supplementary/S_1/';
dirPth.saveDirSup2 = '/mnt/storage_2/projects/Nat_PhScr/MS/finalFig/supplementary/S_2/';

