function [] = myBilateralFiltering(img, sigma_s, sigma_i)
rng(0);

% gaussian kernel size
ks_s = 7;
sigma = 20;

im = double(imread(img));
[H, W] = size(im);
corr_F = im + randn(size(im)) * sigma;

% padd corrupted image with zeros
padsize = (ks_s - 1)/2;
padded_corr_F = padarray(corr_F, [padsize padsize], 'both');

% prepare spatial gaussian
G_space = fspecial('gaussian', ks_s, sigma_s);

% iterate over the image
res = zeros(H, W);
denom = 2*sigma_i^2;
h = waitbar(0, 'Denoising image');
for k=1:H*W
    [i, j] = ind2sub([H W], k);
    chunk = padded_corr_F(i:i+2*padsize, j:j+2*padsize);
    wts = G_space.*exp(-(chunk-padded_corr_F(i+padsize, j+padsize))/denom);
    res(k) = sum(sum(wts.*chunk))/sum(sum(wts));
    waitbar(k/(H*W), h);
end
close(h);

imshow(mat2gray(corr_F));
title('Noisy Image');

figure;
imshow(mat2gray(res));
title('Denoised Image');

err = norm(res - im, 'fro') / norm(im, 'fro');
disp('RMSE = ' + string(err));

end