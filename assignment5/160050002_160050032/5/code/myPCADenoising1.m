function [] = myPCADenoising1(img)
rng(0);

sigma = 20;

im = double(imread(img));
im1 = im + randn(size(im))*sigma;
[H,W] = size(im1);
N = (H - 6)*(W - 6);
P = zeros(49, N);
cntr = 1;
for j=1:W-6
    for i=1:H-6
        chunk = im1(i:i+6, j:j+6);
        P(:, cntr) = chunk(:);
        cntr = cntr + 1;
    end
end

PPt = P*P';
[U, ~] = eig(PPt);

alpha = U' * P;
alpha_bar_sqr = sum(alpha.^2, 2)/N;
alpha_bar_sqr = max(alpha_bar_sqr - sigma^2, 0);

factor = alpha_bar_sqr ./ ( alpha_bar_sqr + sigma^2);
alpha_new = factor .* alpha;
P_new = U * alpha_new;

im2 = zeros(H, W);
count = zeros(H, W);
cntr = 1;
for j=1:W-6
    for i=1:H-6
        im2(i:i+6, j:j+6) = im2(i:i+6, j:j+6) + reshape(P_new(:, cntr), 7, 7);
        count(i:i+6, j:j+6) = count(i:i+6, j:j+6) + ones(7,7);
        cntr = cntr + 1;
    end
end
im2 = im2 ./ count;

imshow(mat2gray(im1));
title('Noisy Image');

figure;
imshow(mat2gray(im2));
title('Denoised Image');

err = norm(im2 - im, 'fro') / norm(im, 'fro');
disp('RMSE = ' + string(err));

end