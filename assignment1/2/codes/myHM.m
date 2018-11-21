function[] = myHM(input_image, input_mask, ref_image, ref_mask)
tic
% load images
I1 = imread(input_image);
I2 = imread(ref_image);
[H,W,C] = size(I1);
res = zeros(H,W,C);  % HM image
res1 = zeros(H,W,C); % HE image
% load masks
mask1 = imread(input_mask);
mask2 = imread(ref_mask);
% compute histograms
for ch = 1:C
    img1 = I1(:,:,ch); img2 = I2(:,:,ch);
    h1 = hist(img1(logical(mask1)), 0:255);
    h2 = hist(img2(logical(mask2)), 0:255);
    cdf1 = cumsum(h1); cdf2 = cumsum(h2);
    cdf1 = cdf1/cdf1(length(cdf1)); cdf2 = cdf2/cdf2(length(cdf2));
    % perform matching
    for i=1:H
        for j=1:W
            if mask1(i,j)
                % find intensity value 'p' such that cdf2(p) is
                % closest to cdf1(img(i,j))
                [~, pos] = min(abs(cdf2-cdf1(1+img1(i,j))));
                res(i,j,ch) = (pos-1)/255;
                % find histogram equalized pixel value
                res1(i,j,ch) = cdf1(img1(i,j)+1);
            end
        end
    end
end

myNumOfColors = 200;
myColorScale = repmat((0:1/(myNumOfColors-1):1)',1,3);

imagesc(I1); title('Original image');
colormap(myColorScale);
if size(I1,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar


figure; imagesc(res); title('Histogram Matched image');
colormap(myColorScale);
if size(I1,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar

figure; imagesc(res1); title('Histogram Equalized image');
colormap(myColorScale);
if size(I1,3)==3
    colormap jet;
else
    colormap gray;
end
daspect ([1 1 1]);
axis tight;
colorbar

toc
end