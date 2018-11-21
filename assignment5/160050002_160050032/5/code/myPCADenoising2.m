function [] = myPCADenoising2(img)
rng(0);

sigma = 20;

im = double(imread(img));
im1 = im + randn(size(im))*sigma;
[H,W] = size(im1);
patches = zeros(H-6, W-6, 49);
for j=1:W-6
    for i=1:H-6
        chunk = im1(i:i+6, j:j+6);
        patches(i, j, :) = chunk(:);
    end
end

im2 = zeros(H, W);
count = zeros(H, W);
h = waitbar(0, 'Denoising image');
for j=1:W
    for i=1:H
        x_id = max(1, j-15):min(W-6, j+15-6);
        y_id = max(1, i-15):min(H-6, i+15-6);
        P_all = reshape(patches(x_id, y_id, :), length(x_id)*length(y_id), 49)';
        Pi = patches(min(i, H-6), min(j, W-6), :); Pi = Pi(:);
        sim = vecnorm(P_all - Pi);
        [~, I] = mink(sim, 200);
        P = P_all(:, I);
        
        PPt = P*P';
        [U, ~] = eig(PPt);
        alpha = U' * P;
        alpha_bar_sqr = sum(alpha.^2, 2)/size(P, 2);
        alpha_bar_sqr = max(alpha_bar_sqr - sigma^2, 0);
        factor = alpha_bar_sqr ./ ( alpha_bar_sqr + sigma^2);
        alpha_new = factor .* (U' * Pi);
        Pi_new = U * alpha_new;
        
        im2(min(i, H-6):min(i, H-6)+6, min(j, W-6):min(j, W-6)+6) = ...
        im2(min(i, H-6):min(i, H-6)+6, min(j, W-6):min(j, W-6)+6) + reshape(Pi_new, 7, 7);
        
        count(min(i, H-6):min(i, H-6)+6, min(j, W-6):min(j, W-6)+6) = ...
        count(min(i, H-6):min(i, H-6)+6, min(j, W-6):min(j, W-6)+6) + ones(7,7);
        waitbar(((j-1)*H + i)/(H*W), h); 
    end
end

im2 = im2 ./ count;
close(h);

imshow(mat2gray(im1));
title('Noisy Image');

figure;
imshow(mat2gray(im2));
title('Denoised Image');

err = norm(im2 - im, 'fro') / norm(im, 'fro');
disp('RMSE = ' + string(err));

end