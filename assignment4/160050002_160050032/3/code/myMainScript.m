%% MyMainScript
%% 
disp('ORL Dataset');
tic;
[x_tr, y_tr, x_te, y_te] = loadDataset('../../../att_faces', 32, 6, 112, 92);
myMatchingIdentity(x_tr, y_tr, x_te, y_te, 25, 4);
toc;
