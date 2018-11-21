function [P2,D2]=sortem(P,D)
% function taken from https://in.mathworks.com/matlabcentral/fileexchange/18904-sort-eigenvectors-eigenvalues
D2=diag(sort(diag(D),'descend')); % make diagonal matrix out of sorted diagonal values of input D
[c, ind]=sort(diag(D),'descend'); % store the indices of which columns the sorted eigenvalues come from
P2=P(:,ind); % arrange the columns in this order
