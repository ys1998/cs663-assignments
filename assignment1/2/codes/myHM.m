function res = myHM(input_image, input_mask, ref_image, ref_mask)
% load images
I1 = imread(input_image);
I2 = imread(ref_image);
[H,W,C] = size(I1);
res = zeros(H,W,C);
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
                res(i,j,ch) = pos-1;
            end
        end
    end
end
imshow(uint8(res));
end