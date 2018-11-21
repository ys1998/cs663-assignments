function [] = myFaceReconstruction(train_x, k_vals, K, H, W)
% train_x - input data (images)
% k_vals - number of eigenfaces used for reconstruction
% K - number of eigenfaces that need to be displayed
% H,W - dimensions of image
x_mean = mean(train_x, 2);
x_ = double(train_x) - x_mean;
L = x_' * x_;
[w, d] = eig(L);
[~, idx] = sort(diag(d), 'descend');
w = w(:, idx);
V = x_ * w;
V = V./vecnorm(V);
% plot top K eigenfaces
figure;
colormap gray;
for k = 1:K
    subplot(ceil(K/5), 5, k); 
    imagesc(reshape(V(:,k), H, W));
    daspect ([1 1 1]); axis tight; axis off;
end
% reconstruct image (first image of train_x) using different no. of eigenfaces
figure;
colormap gray;
for i = 1:length(k_vals)
    Vk = V(:, 1:k_vals(i)); 
    coeffs = Vk' * x_(:,1);
    x_new = x_mean + Vk * coeffs;
    subplot(ceil(length(k_vals)/5), 5, i);    
    imagesc(reshape(x_new, H, W));
    title(strcat('k = ', string(k_vals(i))));
    daspect ([1 1 1]); axis tight; axis off;
end
end