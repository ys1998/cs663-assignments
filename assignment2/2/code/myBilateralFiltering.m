function S = myBilateralFiltering(img, sigma_s, sigma_i, corrupt)
rng(0);
% gaussian kernel size
ks_s = max(5, floor(4*sigma_s));
if rem(ks_s, 2) == 0
    ks_s = ks_s + 1;
end

F = img;
[H,W] = size(F);

% linearly scale the image to [0,1]
F = (F - min(F(:))) / (max(F(:)) - min(F(:)));

% add Gaussian noise
if corrupt == false
    std = 0.05;
    noise = randn(size(F)) * std;
    corr_F = F + noise;
    corr_F = (corr_F - min(corr_F(:))) / (max(corr_F(:)) - min(corr_F(:)));
else
    corr_F = F;
end

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
res = (res - min(res(:))) / (max(res(:)) - min(res(:)));

% print useful information and prepare return value
if corrupt == false
    S.original = F; S.corrupted = corr_F; S.result = res;
    disp(['RSMD for sigma_s = ', num2str(sigma_s), ' and sigma_i = ', num2str(sigma_i), ' => ', num2str(norm(res-F, 'fro')/sqrt(H*W))]);
else
    S.corrupted = corr_F; S.result = res;
end

% display original and sharpened image side by side
if corrupt == false
    figure;
    subplot(2,1,1); imagesc([F, corr_F, res]); title(['(left) Original, (center) Corrupted, (right) Denoised \sigma_s = ',num2str(sigma_s),' \sigma_i = ',num2str(sigma_i)]);
    colormap gray; daspect([1 1 1]); axis tight;
    colorbar;
    subplot(2,1,2); imagesc(G_space(:,:,1)); title(['Spatial Gaussian (size = ', num2str(ks_s),')']);
    colormap gray; daspect([1 1 1]); axis tight; 
    colorbar;
else
    figure;
    subplot(2,1,1); imagesc([corr_F, res]); title(['(left) Corrupted, (right) Denoised \sigma_s = ',num2str(sigma_s),' \sigma_i = ',num2str(sigma_i)]);
    colormap gray; daspect([1 1 1]); axis tight;
    colorbar;
    subplot(2,1,2); imagesc(G_space(:,:,1)); title(['Spatial Gaussian (size = ', num2str(ks_s),')']);
    colormap gray; daspect([1 1 1]); axis tight; 
    colorbar;
end
end