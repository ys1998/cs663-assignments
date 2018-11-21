%% MyMainScript
%% Reconstruction of first image
% First image displays the top 25 eigenfaces, and the second one shows the
% reconstruction of an image from the dataset using different
% dimensionalities of the eigenspace. In the first image, corresponding
% eigenvalues increase as we move from left to right, and from top to
% bottom.
disp('Yale Dataset');
tic;
[x_tr, ~, ~, ~] = loadDataset('../../../CroppedYale', 38, 40, 192, 168);
myFaceReconstruction(x_tr, [2, 10, 20, 50, 75, 100, 125, 150, 175], 25, 192, 168);
toc;
