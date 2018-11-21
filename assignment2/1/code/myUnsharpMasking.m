function[] = myUnsharpMasking(img_path, sigma, scale)
% load .mat file in memory
% image is loaded as 'imageOrig'
x = load(img_path);
[~, file, ~] = fileparts(img_path);
F = x.imageOrig;
% create mask for blurring
G = fspecial('gaussian', 5, sigma);
% blur image using convolution
blurred_F = imfilter(F, G, 'replicate', 'conv');
% compute sharpened image
res = F + scale*(F-blurred_F);
% stretch images linearly
F = (F - min(F(:))) / (max(F(:)) - min(F(:)));
res = (res - min(res(:))) / (max(res(:)) - min(res(:)));

% save images
S.original = F; S.result = res;
save(['../images/',file,'.mat'], '-struct', 'S');

% display original and sharpened image side by side
figure;
imagesc([F, res]); title(['(left) Original, (right) Sharpened \sigma=',num2str(sigma),' scale=',num2str(scale)]);
colormap gray; daspect([1 1 1]); axis tight;
colorbar;
end