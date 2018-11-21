%% MyMainScript
%% ORL Dataset
[x_tr, y_tr, x_te, y_te] = loadDataset('../../../att_faces',  32, 6, 112, 92);
disp('ORL Dataset');
tic;
myFaceRecognition(x_tr, y_tr, x_te, y_te, [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170], 'eig', 0);
toc; tic;
myFaceRecognition(x_tr, y_tr, x_te, y_te, [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170], 'svd', 0);
toc;

%% Yale Dataset
[x_tr, y_tr, x_te, y_te] = loadDataset('../../../CroppedYale', 38, 40, 192, 168);
disp('Yale Dataset');
tic;
myFaceRecognition(x_tr, y_tr, x_te, y_te, [1, 2, 3, 5, 10, 15, 20, 30, 50, 60, 65, 75, 100, 200, 300, 500, 1000], 'svd', 2);
toc;
