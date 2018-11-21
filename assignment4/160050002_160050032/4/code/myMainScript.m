%% Custom SVD implementation
tic;
A = [1,2,3;4,-5,6];
[U,S,V] = MySVD(A);
disp(U*S*V');
% Verify result ignoring precision errors
if max(real(U*S*V') - A) < 1e-6
    disp('SVD successful.');
end
toc;