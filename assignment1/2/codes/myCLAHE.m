function res = myCLAHE(image_path, win_size, threshold)
% image_path : path to input image
% win_size   : size of neighborhood
% res        : array storing resulting image
tic
img = im2uint8(imread(image_path));
if win_size > 0
    [H, W, C] = size(img);
    res = zeros(H, W, C);

    w = int16((win_size - 1)/2);
    for ch = 1:C
        st_chunk = img(1:w,1:w,ch);
        org_hgram = hist(st_chunk(:), 0:255);
        for i = 1:H
            hgram = org_hgram;
            if(i<=w+1)
                for t=1+img(i+w,1:w,ch)
                    hgram(t) = hgram(t) + 1;
                end
            elseif i>w+1 & i<=H-w
                for t=1+img(i+w,1:w,ch)
                    hgram(t) = hgram(t) + 1;
                end
                for t=1+img(i-w-1,1:w,ch)
                    hgram(t) = hgram(t) - 1;
                end
            elseif i>H-w
                for t=1+img(i-w-1,1:w,ch)
                    hgram(t) = hgram(t) - 1;
                end
            end
            org_hgram = hgram;
            for j = 1:W
                if(j<=w+1)
                    for t=1+img(max(1,i-w):min(H,i+w),j+w,ch)
                        hgram(t) = hgram(t) + 1;
                    end
                elseif j>w+1 & j<=W-w
                    for t=1+img(max(1,i-w):min(H,i+w),j+w,ch)
                        hgram(t) = hgram(t) + 1;
                    end
                    for t=1+img(max(1,i-w):min(H,i+w),j-w-1,ch)
                        hgram(t) = hgram(t) - 1;
                    end
                elseif j>W-w
                    for t=1+img(max(1,i-w):min(H,i+w),j-w-1,ch)
                        hgram(t) = hgram(t) - 1;
                    end
                end
                pdf = min(threshold, max(0, hgram/sum(hgram)));
                pdf = pdf + (1.0 - sum(pdf))/256; 
                cdf = cumsum(pdf);
                res(i,j,ch) = cdf(1+img(i,j,ch));
            end
        end
    end
    myNumOfColors = 200;
    myColorScale = repmat((0:1/(myNumOfColors-1):1)',1,3);
    imagesc(res);title(['Window size / Threshold = ' num2str(win_size) '/' num2str(threshold)]);
    colormap(myColorScale);
    if size(img,3)==3
        colormap jet;
    else
        colormap gray;
    end
    daspect ([1 1 1]);
    axis tight;
    colorbar
elseif win_size == -1
    myNumOfColors = 200;
    myColorScale = repmat((0:1/(myNumOfColors-1):1)',1,3);
    imagesc(img); title('Original Image');
    colormap(myColorScale);
    if size(img,3)==3
        colormap jet;
    else
        colormap gray;
    end
    daspect ([1 1 1]);
    axis tight;
    colorbar
end
toc
end