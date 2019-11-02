
load('20190412T152714.mat');
if params.NatVPhs == 1
    cond = 'natural';
else
    cond = 'phaseScram';
end
c = 1;
numIm = size(original_stimulus.images{1,1},3);
for i = 2:10:numIm
    
    saveDir = '/mnt/storage_2/projects/Nat_PhScr/MS/finalFig/stimuli';
    
    curIm = original_stimulus.images{1,1}(:,:,i);
    figure(1), imagesc(curIm); colormap gray; axis image; axis off;
    
    
    fileName = sprintf('%s_im_%d',cond,c);
    c = c+1;
    
    imwrite(curIm, fullfile(saveDir,[fileName '.png']));
    
end

