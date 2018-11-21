%% MyMainScript

tic;
%% Your code here
%x = imread('../data/grassNoisy.png');
%myPatchBasedFiltering(x, false);
% after parameter tuning, remove the parameter for loop in the code
% and use these statements
%
 %S = myPatchBasedFiltering('../data/grassNoisy.png', false);
% save(['../images/grassNoisy.mat'], '-struct', 'S');
%
%x = imread('../data/honeyCombNoisy.png');
%myPatchBasedFiltering(x, false);
    %H=load('../data/grassNoisy.mat');
    %matObj = matfile('Barbara.mat');
    %details = whos(matObj)
    %I1 = H.imageOrig;
    %figure;
    %imshow(uint8(I1));
    
    
    
 H = load('../data/Barbara.mat');
 I = H.imageOrig;
 myPatchBasedFiltering(I,I,0,1);
 H = load('../data/grassNoisy.mat');
 I2 = H.imgCorrupt;
 I1 = imread('../data/grass.png');
 myPatchBasedFiltering(I1,I2,1,2);
 H = load('../data/honeyCombReal_Noisy.mat');
 I2 = H.imgCorrupt;
 I1 = imread('../data/honeyCombReal.png');
 myPatchBasedFiltering(I1,I2,1,3);
toc;
